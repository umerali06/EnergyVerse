import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/qr/qr_scan_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/assets_fixtures.dart';
import 'support/qr_fixtures.dart';

Future<void> pumpResultScreen(WidgetTester tester, QrScanResult result) async {
  await tester.pumpWidget(
    AppThemeScope(
      controller: AppThemeController(),
      child: MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(body: QrScanResultScreen(result: result)),
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
    await pumpResultScreen(tester, result);

    expect(find.text('PMP-001'), findsOneWidget);
    expect(find.text('Feed Pump'), findsOneWidget);
    expect(find.text('No inspections yet'), findsOneWidget);
    expect(find.text('No maintenance history yet'), findsOneWidget);
    expect(find.text('No open work orders'), findsOneWidget);
    expect(find.text('Start Inspection'), findsOneWidget);
  });

  testWidgets('"Start Inspection" is a clearly-labeled stub, not a real flow', (tester) async {
    final result = qrScanResultFixture(asset: assetDetailFixture());
    await pumpResultScreen(tester, result);

    final startInspection = find.text('Start Inspection');
    await tester.ensureVisible(startInspection);
    await tester.pumpAndSettle();
    await tester.tap(startInspection);
    await tester.pumpAndSettle();

    expect(find.text('Inspections is coming soon'), findsOneWidget);
  });
}
