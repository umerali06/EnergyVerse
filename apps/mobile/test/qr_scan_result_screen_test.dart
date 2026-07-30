import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:fev_mobile/qr/qr_scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/assets_fixtures.dart';
import 'support/fake_qr_api.dart';
import 'support/qr_fixtures.dart';

Future<void> pumpResultScreen(
  WidgetTester tester,
  QrScanResult result, {
  required LocalInspectionsRepository repository,
}) async {
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(
                body: QrScanResultScreen(
                  result: result,
                  repository: repository,
                  inspectorId: 'demo-acme-field_inspector',
                ),
              ),
            );
          }
          if (settings.name == '/inspections/detail') {
            final inspectionId = settings.arguments as String;
            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(body: Text('Inspection detail: $inspectionId')),
            );
          }
          return null;
        },
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('renders asset info/status and the reserved honest-empty sections', (tester) async {
    final result = qrScanResultFixture(
      asset: assetDetailFixture(assetTag: 'PMP-001', name: 'Feed Pump'),
    );
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repository = LocalInspectionsRepository(
      db: db,
      api: FakeQrApi(resolveQrCode: (_) async => result),
    );
    await pumpResultScreen(tester, result, repository: repository);

    expect(find.text('PMP-001'), findsOneWidget);
    expect(find.text('Feed Pump'), findsOneWidget);
    expect(find.text('No maintenance history yet'), findsOneWidget);
    expect(find.text('No open work orders'), findsOneWidget);
    expect(find.text('Start Inspection'), findsOneWidget);
  });

  testWidgets(
    '"Start Inspection" writes a local draft instantly and lands on the detail screen',
    (tester) async {
      final result = qrScanResultFixture(asset: assetDetailFixture(id: 'asset-1'));
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final repository = LocalInspectionsRepository(
        db: db,
        api: FakeQrApi(resolveQrCode: (_) async => result),
      );
      await pumpResultScreen(tester, result, repository: repository);

      final startInspection = find.text('Start Inspection');
      await tester.ensureVisible(startInspection);
      await tester.pumpAndSettle();
      await tester.tap(startInspection);
      await tester.pumpAndSettle();

      // A plain one-shot query, not `watchInspections()` -- a fresh watch
      // stream's first emission depends on Drift's internal invalidation
      // timer, which never fires without an extra pump under the fake
      // clock `flutter_test` runs widget tests on.
      final created = await db.select(db.localInspections).get();
      expect(created, hasLength(1));
      expect(created.single.assetId, 'asset-1');
      expect(created.single.inspectionType, 'ad_hoc');
      expect(created.single.syncState, LocalSyncState.localOnly.wireValue);
      expect(find.text('Inspection detail: ${created.single.id}'), findsOneWidget);
    },
  );

  // There is deliberately no "Start Inspection surfaces an error on failure"
  // case here anymore: createDraft is a local-only write with no network
  // call in its path (Phase 7.2's whole point), so it no longer has the
  // network-failure mode the pre-7.2 version of this test exercised.
  // Sync failures (the new failure mode, once the queued create actually
  // replays) are covered by the sync engine test suite and the pending-queue
  // screen's error/retry/discard affordances instead.
}
