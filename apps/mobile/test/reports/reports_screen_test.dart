import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/reports/reports_controller.dart';
import 'package:fev_mobile/reports/reports_screen.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

GeneratedReportListItem report({required String id, required bool finalized}) =>
    GeneratedReportListItem((b) => b
      ..id = id
      ..title = finalized ? 'Weekly safety summary' : 'Draft inspection report'
      ..reportType = finalized
          ? GeneratedReportListItemReportTypeEnum.executiveSummary
          : GeneratedReportListItemReportTypeEnum.inspection
      ..status = finalized
          ? GeneratedReportListItemStatusEnum.finalized
          : GeneratedReportListItemStatusEnum.draft
      ..revision = 2
      ..createdBy = 'manager-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 11));

GeneratedReportListPage page(
        List<GeneratedReportListItem> items, String? nextCursor) =>
    GeneratedReportListPage((b) => b
      ..items = ListBuilder(items)
      ..nextCursor = nextCursor);

class FakeReportsApi implements GeneratedReportsApiContract {
  final calls = <Map<String, Object?>>[];
  final exports = <(String, String)>[];
  int pageIndex = 0;

  @override
  Future<GeneratedReportListPage> getGeneratedReports({
    String? reportType,
    String? status,
    String? cursor,
    int limit = 25,
  }) async {
    calls.add({'reportType': reportType, 'status': status, 'cursor': cursor});
    if (cursor == 'next') {
      return page([report(id: 'report-2', finalized: true)], null);
    }
    return page([
      report(id: 'report-final', finalized: true),
      report(id: 'report-draft', finalized: false),
    ], 'next');
  }

  @override
  Future<GeneratedReportDetail> generateReport(
      CreateGeneratedReportRequest request) async {
    return GeneratedReportDetail((b) => b
      ..id = request.id
      ..title = request.title ?? 'Advisory Inspection Report'
      ..reportType = GeneratedReportDetailReportTypeEnum.inspection
      ..status = GeneratedReportDetailStatusEnum.draft
      ..revision = 1
      ..aiModel = 'claude-3-5-sonnet'
      ..finalizationAttestation = false
      ..createdBy = 'inspector-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 10)
      ..sourceSnapshot.replace({})
      ..narrative.replace(ReportNarrativeResponse(
        (nb) => nb..summary = 'Advisory AI analysis of inspection findings.',
      )));
  }

  @override
  Future<GeneratedReportDetail> getGeneratedReport(String reportId) async {
    return GeneratedReportDetail((b) => b
      ..id = reportId
      ..title = 'Weekly safety summary'
      ..reportType = GeneratedReportDetailReportTypeEnum.executiveSummary
      ..status = GeneratedReportDetailStatusEnum.draft
      ..revision = 1
      ..aiModel = 'claude-3-5-sonnet'
      ..finalizationAttestation = false
      ..createdBy = 'manager-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 11)
      ..sourceSnapshot.replace({})
      ..narrative.replace(ReportNarrativeResponse(
        (nb) => nb..summary = 'Advisory executive narrative.',
      )));
  }

  @override
  Future<GeneratedReportDetail> updateGeneratedReport(
      String reportId, UpdateGeneratedReportRequest request) async {
    return GeneratedReportDetail((b) => b
      ..id = reportId
      ..title = request.title ?? 'Updated title'
      ..reportType = GeneratedReportDetailReportTypeEnum.executiveSummary
      ..status = GeneratedReportDetailStatusEnum.draft
      ..revision = request.expectedRevision + 1
      ..aiModel = 'claude-3-5-sonnet'
      ..finalizationAttestation = false
      ..createdBy = 'manager-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 11)
      ..sourceSnapshot.replace({})
      ..narrative.replace(ReportNarrativeResponse(
        (nb) => nb..summary = request.summary ?? 'Updated summary.',
      )));
  }

  @override
  Future<GeneratedReportDetail> regenerateGeneratedReport(
      String reportId, RegenerateGeneratedReportRequest request) async {
    return GeneratedReportDetail((b) => b
      ..id = reportId
      ..title = 'Weekly safety summary'
      ..reportType = GeneratedReportDetailReportTypeEnum.executiveSummary
      ..status = GeneratedReportDetailStatusEnum.draft
      ..revision = request.expectedRevision + 1
      ..aiModel = 'claude-3-5-sonnet'
      ..finalizationAttestation = false
      ..createdBy = 'manager-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 11)
      ..sourceSnapshot.replace({})
      ..narrative.replace(ReportNarrativeResponse(
        (nb) => nb..summary = 'Regenerated advisory AI narrative.',
      )));
  }

  @override
  Future<GeneratedReportDetail> finalizeGeneratedReport(
      String reportId, FinalizeGeneratedReportRequest request) async {
    return GeneratedReportDetail((b) => b
      ..id = reportId
      ..title = 'Weekly safety summary'
      ..reportType = GeneratedReportDetailReportTypeEnum.executiveSummary
      ..status = GeneratedReportDetailStatusEnum.finalized
      ..revision = request.expectedRevision + 1
      ..aiModel = 'claude-3-5-sonnet'
      ..finalizationAttestation = true
      ..createdBy = 'manager-1'
      ..createdAt = DateTime.utc(2026, 8, 20, 10)
      ..updatedAt = DateTime.utc(2026, 8, 20, 11)
      ..sourceSnapshot.replace({})
      ..narrative.replace(ReportNarrativeResponse(
        (nb) => nb..summary = 'Finalized report summary.',
      )));
  }

  @override
  Future<GeneratedReportDeleted> deleteGeneratedReport(String reportId) async {
    return GeneratedReportDeleted((b) => b..id = reportId);
  }

  @override
  Future<GeneratedReportExportResponse> exportGeneratedReport(
      String reportId, String format) async {
    exports.add((reportId, format));
    return GeneratedReportExportResponse((b) => b
      ..reportId = reportId
      ..format = GeneratedReportExportResponseFormatEnum.pdf
      ..filename = 'weekly-safety-summary.pdf'
      ..contentType = 'application/pdf'
      ..size = 2048
      ..generatedBy = 'executive-1'
      ..generatedAt = DateTime.utc(2026, 8, 20, 12)
      ..url = 'https://storage.example.invalid/signed-report');
  }
}

class FakeLinkOpener implements ReportLinkOpener {
  final urls = <String>[];

  @override
  Future<bool> open(String url) async {
    urls.add(url);
    return true;
  }
}

void main() {
  test('controller applies tenant filters and cursor pagination', () async {
    final api = FakeReportsApi();
    final controller = ReportsController(api: api);
    await controller.start();
    expect(controller.items, hasLength(2));
    expect(controller.nextCursor, 'next');

    await controller.setReportType('safety');
    await controller.setStatus('finalized');
    expect(api.calls.last, {
      'reportType': 'safety',
      'status': 'finalized',
      'cursor': null,
    });
    await controller.loadMore();
    expect(api.calls.last['cursor'], 'next');
    expect(controller.items, hasLength(3));
  });

  testWidgets(
      'renders real reports, gates drafts, and opens a fresh signed export',
      (tester) async {
    final api = FakeReportsApi();
    final opener = FakeLinkOpener();
    final theme = AppThemeController();
    addTearDown(theme.dispose);
    await tester.pumpWidget(AppThemeScope(
      controller: theme,
      child: MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(body: ReportsScreen(api: api, linkOpener: opener)),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Weekly safety summary'), findsOneWidget);
    expect(find.text('Draft inspection report'), findsOneWidget);
    expect(find.byKey(const Key('draft-export-gate')), findsOneWidget);
    expect(find.byKey(const Key('export-pdf-report-final')), findsOneWidget);
    expect(find.byKey(const Key('export-pdf-report-draft')), findsNothing);

    await tester.tap(find.byKey(const Key('export-pdf-report-final')));
    await tester.pumpAndSettle();
    expect(api.exports, [('report-final', 'pdf')]);
    expect(opener.urls, ['https://storage.example.invalid/signed-report']);
    expect(find.text('PDF export ready'), findsOneWidget);
  });
}
