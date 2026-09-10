import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for GeneratedReportsApi
void main() {
  final instance = FevApiClient().getGeneratedReportsApi();

  group(GeneratedReportsApi, () {
    // Delete Generated Report
    //
    //Future<GeneratedReportDeleted> deleteGeneratedReport(String reportId) async
    test('test deleteGeneratedReport', () async {
      // TODO
    });

    // Export Generated Report
    //
    //Future<GeneratedReportExportResponse> exportGeneratedReport(String reportId, String format) async
    test('test exportGeneratedReport', () async {
      // TODO
    });

    // Finalize Generated Report
    //
    //Future<GeneratedReportDetail> finalizeGeneratedReport(String reportId, FinalizeGeneratedReportRequest finalizeGeneratedReportRequest) async
    test('test finalizeGeneratedReport', () async {
      // TODO
    });

    // Generate Report
    //
    //Future<GeneratedReportDetail> generateReport(CreateGeneratedReportRequest createGeneratedReportRequest) async
    test('test generateReport', () async {
      // TODO
    });

    // Get Generated Report
    //
    //Future<GeneratedReportDetail> getGeneratedReport(String reportId) async
    test('test getGeneratedReport', () async {
      // TODO
    });

    // List Generated Reports
    //
    //Future<GeneratedReportListPage> listGeneratedReports({ String reportType, String status, String cursor, int limit }) async
    test('test listGeneratedReports', () async {
      // TODO
    });

    // Regenerate Generated Report
    //
    //Future<GeneratedReportDetail> regenerateGeneratedReport(String reportId, RegenerateGeneratedReportRequest regenerateGeneratedReportRequest) async
    test('test regenerateGeneratedReport', () async {
      // TODO
    });

    // Update Generated Report
    //
    //Future<GeneratedReportDetail> updateGeneratedReport(String reportId, UpdateGeneratedReportRequest updateGeneratedReportRequest) async
    test('test updateGeneratedReport', () async {
      // TODO
    });
  });
}
