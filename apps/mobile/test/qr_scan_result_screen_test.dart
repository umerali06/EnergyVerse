import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/qr/qr_scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/assets_fixtures.dart';
import 'support/fake_qr_api.dart';
import 'support/qr_fixtures.dart';

InspectionDetail _inspectionDetailFixture({String id = 'inspection-1', String assetId = 'asset-1'}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionDetail(
    (b) => b
      ..id = id
      ..assetId = assetId
      ..facilityId = 'facility-1'
      ..inspectorId = 'demo-acme-field_inspector'
      ..status = InspectionDetailStatusEnum.draft
      ..inspectionType = InspectionDetailInspectionTypeEnum.adHoc
      ..revision = 1
      ..clientCreatedAt = now
      ..createdAt = now
      ..updatedAt = now,
  );
}

Future<void> pumpResultScreen(
  WidgetTester tester,
  QrScanResult result, {
  required ApiContract api,
}) async {
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute<void>(
              builder: (_) => Scaffold(body: QrScanResultScreen(result: result, api: api)),
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
    await pumpResultScreen(
      tester,
      result,
      api: FakeQrApi(resolveQrCode: (_) async => result),
    );

    expect(find.text('PMP-001'), findsOneWidget);
    expect(find.text('Feed Pump'), findsOneWidget);
    expect(find.text('No maintenance history yet'), findsOneWidget);
    expect(find.text('No open work orders'), findsOneWidget);
    expect(find.text('Start Inspection'), findsOneWidget);
  });

  testWidgets('"Start Inspection" creates a real draft and lands on the detail screen', (
    tester,
  ) async {
    final result = qrScanResultFixture(asset: assetDetailFixture(id: 'asset-1'));
    CreateInspectionRequest? captured;
    final api = FakeQrApi(
      resolveQrCode: (_) async => result,
      createInspection: (request) async {
        captured = request;
        return _inspectionDetailFixture(id: 'inspection-new', assetId: 'asset-1');
      },
    );
    await pumpResultScreen(tester, result, api: api);

    final startInspection = find.text('Start Inspection');
    await tester.ensureVisible(startInspection);
    await tester.pumpAndSettle();
    await tester.tap(startInspection);
    await tester.pumpAndSettle();

    expect(captured, isNotNull);
    expect(captured!.assetId, 'asset-1');
    expect(captured!.inspectionType, CreateInspectionRequestInspectionTypeEnum.adHoc);
    expect(find.text('Inspection detail: inspection-new'), findsOneWidget);
  });

  testWidgets('"Start Inspection" surfaces an error and stays put on failure', (tester) async {
    final result = qrScanResultFixture(asset: assetDetailFixture(id: 'asset-1'));
    final api = FakeQrApi(
      resolveQrCode: (_) async => result,
      createInspection: (request) async => throw Exception('network down'),
    );
    await pumpResultScreen(tester, result, api: api);

    final startInspection = find.text('Start Inspection');
    await tester.ensureVisible(startInspection);
    await tester.pumpAndSettle();
    await tester.tap(startInspection);
    await tester.pumpAndSettle();

    expect(find.text("Couldn't start the inspection. Please try again."), findsOneWidget);
    expect(find.text('Start Inspection'), findsOneWidget);
  });
}
