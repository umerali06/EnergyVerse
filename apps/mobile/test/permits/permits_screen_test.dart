import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/permits/local_permits_repository.dart';
import 'package:fev_mobile/permits/permit_detail_screen.dart';
import 'package:fev_mobile/permits/permit_sync_engine.dart';
import 'package:fev_mobile/permits/permits_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

PermitDetail detail() {
  final now = DateTime.utc(2026, 8, 19, 12);
  return PermitDetail((b) => b
    ..id = 'permit-1'
    ..permitNumber = 'PTW-20260819-ABCD1234'
    ..title = 'Replace relief valve'
    ..description = 'Controlled replacement after isolation.'
    ..permitType = PermitDetailPermitTypeEnum.hotWork
    ..facilityId = 'facility-1'
    ..templateId = 'template-1'
    ..templateName = 'Hot work standard'
    ..templateVersion = 3
    ..status = PermitDetailStatusEnum.pendingSignatures
    ..revision = 4
    ..highestResidualRisk = PermitDetailHighestResidualRiskEnum.medium
    ..validFrom = now.subtract(const Duration(hours: 1))
    ..validUntil = now.add(const Duration(hours: 8))
    ..workerIds.replace(['worker-1'])
    ..workerCount = 1
    ..workerAcknowledgements.replace([])
    ..checklistSnapshot.replace([])
    ..approvalSnapshot.replace([])
    ..riskAssessment.replace([])
    ..createdAt = now
    ..updatedAt = now);
}

class Api implements PermitApiContract {
  @override
  Future<PermitDetail> getPermit(String permitId) async => detail();
  @override
  Future<PermitDetail> acknowledgePermit(
          String permitId, AcknowledgePermitRequest request) async =>
      detail();
  @override
  Future<PermitListPage> getPermits(
          {String? workerId, String? cursor, int limit = 25}) =>
      throw const ApiException(code: 'network_error', message: 'offline');
}

Future<
    ({
      AppDatabase db,
      LocalPermitsRepository repository,
      PermitSyncEngine engine,
      AppThemeController theme
    })> setup() async {
  final db = AppDatabase(NativeDatabase.memory());
  final api = Api();
  final repository = LocalPermitsRepository(db: db, api: api);
  await repository.refreshDetailFromNetwork('permit-1');
  final engine = PermitSyncEngine(
      repository: repository,
      api: api,
      connectivityStreamFactory: () =>
          const Stream<List<ConnectivityResult>>.empty(),
      checkConnectivity: () async => [ConnectivityResult.none],
      periodicInterval: const Duration(days: 1));
  return (
    db: db,
    repository: repository,
    engine: engine,
    theme: AppThemeController()
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('assigned permit list renders the durable offline cache',
      (tester) async {
    final state = (await tester.runAsync(setup))!;
    await tester.pumpWidget(AppThemeScope(
        controller: state.theme,
        child: PermitSyncProvider(
            engine: state.engine,
            repository: state.repository,
            child: MaterialApp(
                theme: AppThemes.light,
                home: const Scaffold(
                    body: PermitsScreen(workerId: 'worker-1'))))));
    await tester.pump();
    expect(find.text('Replace relief valve'), findsOneWidget);
    expect(find.text('PTW-20260819-ABCD1234'), findsOneWidget);
    expect(find.text('PENDING SIGNATURES'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(Duration.zero);
    state.engine.dispose();
    state.theme.dispose();
    await state.db.close();
  }, timeout: const Timeout(Duration(seconds: 30)));

  testWidgets('worker attestation queues durably while offline',
      (tester) async {
    final state = (await tester.runAsync(setup))!;
    await tester.pumpWidget(AppThemeScope(
        controller: state.theme,
        child: PermitSyncProvider(
            engine: state.engine,
            repository: state.repository,
            child: MaterialApp(
                theme: AppThemes.light,
                home: const Scaffold(
                    body: PermitDetailScreen(
                        permitId: 'permit-1', workerId: 'worker-1'))))));
    await tester.pump();
    await tester.tap(find.text('Review and sign acknowledgement'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    await tester.ensureVisible(find.text('Sign acknowledgement'));
    await tester.tap(find.text('Sign acknowledgement'));
    await tester.pumpAndSettle();
    expect(await state.repository.outboxCount(), 1);
    expect(find.text('Acknowledgement is safely queued on this device.'),
        findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(Duration.zero);
    state.engine.dispose();
    state.theme.dispose();
    await state.db.close();
  }, timeout: const Timeout(Duration(seconds: 30)));
}
