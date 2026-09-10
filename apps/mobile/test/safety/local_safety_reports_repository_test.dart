import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/safety/local_safety_reports_repository.dart';

void main() {
  late AppDatabase db;
  late LocalSafetyReportsRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = LocalSafetyReportsRepository(
      db: db,
      api: const UnavailableSafetyApiContract(),
    );
  });

  tearDown(() async {
    repository.dispose();
    await db.close();
  });

  test('createOffline atomically stores the report and create mutation',
      () async {
    final occurredAt = DateTime.utc(2026, 8, 16, 8, 30);

    final id = await repository.createOffline(
      reporterId: 'inspector-1',
      category: CreateSafetyReportRequestCategoryEnum.gasLeak,
      severity: CreateSafetyReportRequestSeverityEnum.critical,
      title: ' Compressor seal leak ',
      description: ' Gas detected at the north compressor seal. ',
      occurredAt: occurredAt,
      gpsLat: 24.8607,
      gpsLng: 67.0011,
    );

    final report = await (db.select(db.localSafetyReports)
          ..where((row) => row.id.equals(id)))
        .getSingle();
    final outbox = await db.select(db.safetyOutbox).getSingle();

    expect(report.title, 'Compressor seal leak');
    expect(report.description, 'Gas detected at the north compressor seal.');
    expect(report.category, 'gas_leak');
    expect(report.severity, 'critical');
    expect(report.reporterId, 'inspector-1');
    expect(report.occurredAt.millisecondsSinceEpoch,
        occurredAt.millisecondsSinceEpoch);
    expect(report.syncState, SafetyLocalSyncState.localOnly.wireValue);
    expect(outbox.reportId, id);
    expect(outbox.mutationType, 'create');
    expect(outbox.payload, contains('gas_leak'));
    expect(await repository.outboxCount(), 1);
  });

  test('queueForDrain honors retry backoff and manual bypass', () async {
    await repository.createOffline(
      reporterId: 'inspector-1',
      category: CreateSafetyReportRequestCategoryEnum.nearMiss,
      severity: CreateSafetyReportRequestSeverityEnum.medium,
      title: 'Dropped tool',
      description: 'A secured tool fell inside the barricaded area.',
      occurredAt: DateTime.utc(2026, 8, 16),
    );
    final item = (await repository.queueForDrain(
      now: DateTime.utc(2026, 8, 16),
      bypassBackoff: true,
    ))
        .single;
    await repository.markTransientFailure(
      item,
      message: 'offline',
      nextAttemptAt: DateTime.utc(2026, 8, 17),
    );

    expect(
      await repository.queueForDrain(now: DateTime.utc(2026, 8, 16, 12)),
      isEmpty,
    );
    expect(
      await repository.queueForDrain(
        now: DateTime.utc(2026, 8, 16, 12),
        bypassBackoff: true,
      ),
      hasLength(1),
    );
  });

  test('assigned action update is optimistic and durably targeted', () async {
    final now = DateTime.utc(2026, 8, 16);
    final action = CorrectiveActionResponse((b) => b
      ..id = 'action-1'
      ..description = 'Replace damaged guard'
      ..assigneeId = 'technician-1'
      ..dueDate = DateTime.utc(2026, 8, 20)
      ..priority = CorrectiveActionResponsePriorityEnum.high
      ..status = CorrectiveActionResponseStatusEnum.open
      ..createdAt = now
      ..createdBy = 'hse-1'
      ..updatedAt = now);
    final encodedAction = standardSerializers.serializeWith(
      CorrectiveActionResponse.serializer,
      action,
    );
    await db.into(db.localSafetyReports).insert(
          LocalSafetyReportsCompanion.insert(
            id: 'report-1',
            category: 'unsafe_condition',
            severity: 'high',
            title: 'Missing guard',
            description: 'Guard was missing.',
            occurredAt: now,
            reporterId: 'inspector-1',
            createdAt: now,
            updatedAt: now,
            syncState: const drift.Value('synced'),
            correctiveActions: drift.Value(jsonEncode([encodedAction])),
          ),
        );

    await repository.updateCorrectiveActionOffline(
      reportId: 'report-1',
      actionId: 'action-1',
      status: UpdateCorrectiveActionRequestStatusEnum.inProgress,
    );

    final report = await db.select(db.localSafetyReports).getSingle();
    final outbox = await db.select(db.safetyOutbox).getSingle();
    final cached = LocalSafetyReportRecord(report).correctiveActions.single;
    expect(cached.status, CorrectiveActionResponseStatusEnum.inProgress);
    expect(cached.startedAt, isNotNull);
    expect(report.syncState, 'pending_sync');
    expect(outbox.mutationType, 'update_action');
    expect(outbox.targetId, 'action-1');
    expect(outbox.payload, contains('in_progress'));
  });
}
