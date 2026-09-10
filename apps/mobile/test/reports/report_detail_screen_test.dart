import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/reports/report_create_sheet.dart';
import 'package:fev_mobile/reports/report_detail_screen.dart';
import 'package:fev_mobile/reports/reports_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'reports_screen_test.dart';

void main() {
  testWidgets('ReportCreateSheet triggers report generation on submit',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final theme = AppThemeController();
    addTearDown(theme.dispose);

    CreateGeneratedReportRequest? capturedRequest;
    await tester.pumpWidget(
      AppThemeScope(
        controller: theme,
        child: MaterialApp(
          theme: AppThemes.light,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => showModalBottomSheet<bool>(
                  context: ctx,
                  isScrollControlled: true,
                  builder: (_) => ReportCreateSheet(
                    onSubmit: (req) async {
                      capturedRequest = req;
                    },
                  ),
                ),
                child: const Text('Open Sheet'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();

    final inputFinder = find.byKey(const Key('report-source-id-input'));
    expect(inputFinder, findsOneWidget);

    await tester.enterText(inputFinder, 'insp-12345');
    await tester.enterText(
      find.byKey(const Key('report-title-input')),
      'Custom Unit Test Report',
    );

    final submitButton = find.text('Generate Draft');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(capturedRequest, isNotNull);
    expect(capturedRequest!.sourceId, 'insp-12345');
    expect(capturedRequest!.title, 'Custom Unit Test Report');
  });

  testWidgets(
      'ReportDetailScreen renders AI advisory narrative and supports draft finalization',
      (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = FakeReportsApi();
    final controller = ReportsController(api: api);
    final theme = AppThemeController();
    addTearDown(theme.dispose);

    await tester.pumpWidget(
      AppThemeScope(
        controller: theme,
        child: MaterialApp(
          theme: AppThemes.light,
          home: ReportDetailScreen(
            reportId: 'rep-draft-1',
            controller: controller,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Advisory Narrative'), findsOneWidget);
    expect(find.text('Advisory executive narrative.'), findsNWidgets(2));

    final saveButton = find.text('Save Edits');
    expect(saveButton, findsOneWidget);

    final finalizeButton = find.text('Attest & Finalize');
    expect(finalizeButton, findsOneWidget);
    await tester.tap(finalizeButton);
    await tester.pumpAndSettle();

    expect(find.text('I attest that I have reviewed the advisory AI narrative and human edits. Finalizing will freeze this report revision permanently.'), findsOneWidget);

    await tester.tap(find.text('Attest & Finalize').last);
    await tester.pumpAndSettle();

    expect(find.text('Report finalized and locked.'), findsOneWidget);
  });
}
