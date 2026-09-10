import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart' hide Value;
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/permissions.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/safety/local_safety_reports_repository.dart';
import 'package:fev_mobile/safety/local_safety_evidence_repository.dart';
import 'package:fev_mobile/safety/safety_report_detail_screen.dart';
import 'package:fev_mobile/safety/safety_reports_screen.dart';
import 'package:fev_mobile/safety/safety_evidence_upload_worker.dart';
import 'package:fev_mobile/safety/safety_sync_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders a cached safety report and enforces write visibility',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final repository = LocalSafetyReportsRepository(
      db: db,
      api: const UnavailableSafetyApiContract(),
    );
    final connectivity = StreamController<List<ConnectivityResult>>.broadcast();
    final engine = SafetySyncEngine(
      repository: repository,
      api: const UnavailableSafetyApiContract(),
      connectivityStreamFactory: () => connectivity.stream,
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
      connectivityDebounce: Duration.zero,
    );
    final theme = AppThemeController();
    addTearDown(() {
      theme.dispose();
      repository.dispose();
      unawaited(connectivity.close());
      unawaited(db.close());
    });

    final now = DateTime.utc(2026, 8, 16, 9);
    await tester.runAsync(
      () => db.into(db.localSafetyReports).insert(
            LocalSafetyReportsCompanion.insert(
              id: 'safety-1',
              category: 'gas_leak',
              severity: 'critical',
              title: 'Compressor seal leak',
              description: 'Gas detected near the north seal.',
              occurredAt: now,
              reporterId: 'inspector-1',
              createdAt: now,
              updatedAt: now,
              syncState: const Value('local_only'),
            ),
          ),
    );

    await tester.pumpWidget(
      AppThemeScope(
        controller: theme,
        child: PermissionProvider(
          controller: PermissionController(
            initialPermissions: const ['safety.read'],
          ),
          child: SafetySyncProvider(
            engine: engine,
            repository: repository,
            child: MaterialApp(
              theme: AppThemes.light,
              home: const Scaffold(body: SafetyReportsScreen()),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Compressor seal leak'), findsOneWidget);
    await tester.ensureVisible(find.text('Compressor seal leak'));
    await tester.pump();
    expect(find.text('CRITICAL'), findsOneWidget);
    expect(find.text('LOCAL ONLY'), findsOneWidget);
    expect(find.byKey(const Key('report-incident')), findsNothing);

    engine.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(Duration.zero);
  });

  testWidgets('detail renders cached incident fields while offline',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final repository = LocalSafetyReportsRepository(
      db: db,
      api: const UnavailableSafetyApiContract(),
    );
    final connectivity = StreamController<List<ConnectivityResult>>.broadcast();
    final engine = SafetySyncEngine(
      repository: repository,
      api: const UnavailableSafetyApiContract(),
      connectivityStreamFactory: () => connectivity.stream,
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
      connectivityDebounce: Duration.zero,
    );
    final theme = AppThemeController();
    final evidenceRepository = LocalSafetyEvidenceRepository(db: db);
    final evidenceWorker = SafetyEvidenceUploadWorker(
      evidenceRepository: evidenceRepository,
      reportsRepository: repository,
      api: const UnavailableSafetyApiContract(),
      connectivityStreamFactory: () => connectivity.stream,
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1),
    );
    addTearDown(() {
      theme.dispose();
      evidenceRepository.dispose();
      repository.dispose();
      unawaited(connectivity.close());
      unawaited(db.close());
    });
    final now = DateTime.utc(2026, 8, 16, 9);
    final action = CorrectiveActionResponse((b) => b
      ..id = 'action-1'
      ..description = 'Install replacement guard'
      ..assigneeId = 'technician-1'
      ..dueDate = DateTime.utc(2026, 8, 20)
      ..priority = CorrectiveActionResponsePriorityEnum.high
      ..status = CorrectiveActionResponseStatusEnum.open
      ..createdAt = now
      ..createdBy = 'hse-1'
      ..updatedAt = now);
    final actionsJson = jsonEncode([
      standardSerializers.serializeWith(
          CorrectiveActionResponse.serializer, action)
    ]);
    await tester.runAsync(
      () => db.into(db.localSafetyReports).insert(
            LocalSafetyReportsCompanion.insert(
              id: 'safety-detail-1',
              category: 'unsafe_condition',
              severity: 'high',
              title: 'Missing machine guard',
              description: 'The coupling guard was missing during inspection.',
              occurredAt: now,
              gpsLat: const Value(24.8607),
              gpsLng: const Value(67.0011),
              reporterId: 'inspector-1',
              createdAt: now,
              updatedAt: now,
              syncState: const Value('synced'),
              revision: const Value(3),
              correctiveActions: Value(actionsJson),
            ),
          ),
    );

    await tester.pumpWidget(
      AppThemeScope(
        controller: theme,
        child: PermissionProvider(
          controller: PermissionController(
            initialPermissions: const ['safety.read', 'safety.write'],
          ),
          child: SafetySyncProvider(
            engine: engine,
            repository: repository,
            child: SafetyEvidenceProvider(
              worker: evidenceWorker,
              repository: evidenceRepository,
              child: MaterialApp(
                theme: AppThemes.light,
                home: const Scaffold(
                  body: SafetyReportDetailScreen(
                    reportId: 'safety-detail-1',
                    currentUserId: 'technician-1',
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump();

    expect(find.text('Missing machine guard'), findsOneWidget);
    expect(find.text('24.860700, 67.001100'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('safety-detail-scroll')), const Offset(0, -450));
    await tester.pump();
    expect(find.text('Install replacement guard'), findsOneWidget);
    expect(find.text('Start action'), findsOneWidget);
    await tester.drag(
        find.byKey(const Key('safety-detail-scroll')), const Offset(0, -450));
    await tester.pump();
    expect(find.text('The coupling guard was missing during inspection.'),
        findsOneWidget);

    evidenceWorker.dispose();
    engine.dispose();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(Duration.zero);
  });
}
