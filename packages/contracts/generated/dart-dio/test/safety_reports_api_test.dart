import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for SafetyReportsApi
void main() {
  final instance = FevApiClient().getSafetyReportsApi();

  group(SafetyReportsApi, () {
    // Assign Safety Report
    //
    //Future<SafetyReportDetail> assignSafetyReport(String reportId, AssignSafetyReportRequest assignSafetyReportRequest) async
    test('test assignSafetyReport', () async {
      // TODO
    });

    // Cancel Corrective Action
    //
    //Future<SafetyReportDetail> cancelCorrectiveAction(String reportId, String actionId, CancelCorrectiveActionRequest cancelCorrectiveActionRequest) async
    test('test cancelCorrectiveAction', () async {
      // TODO
    });

    // Close Safety Report
    //
    //Future<SafetyReportDetail> closeSafetyReport(String reportId) async
    test('test closeSafetyReport', () async {
      // TODO
    });

    // Create Corrective Action
    //
    //Future<SafetyReportDetail> createCorrectiveAction(String reportId, CreateCorrectiveActionRequest createCorrectiveActionRequest) async
    test('test createCorrectiveAction', () async {
      // TODO
    });

    // Create Safety Report
    //
    //Future<SafetyReportDetail> createSafetyReport(CreateSafetyReportRequest createSafetyReportRequest) async
    test('test createSafetyReport', () async {
      // TODO
    });

    // Delete Safety Evidence
    //
    //Future<SafetyReportDetail> deleteSafetyEvidence(String reportId, String evidenceId) async
    test('test deleteSafetyEvidence', () async {
      // TODO
    });

    // Delete Safety Report
    //
    //Future<SafetyReportDeleted> deleteSafetyReport(String reportId) async
    test('test deleteSafetyReport', () async {
      // TODO
    });

    // Get Safety Report
    //
    //Future<SafetyReportDetail> getSafetyReport(String reportId) async
    test('test getSafetyReport', () async {
      // TODO
    });

    // List Safety Reports
    //
    //Future<SafetyReportListPage> listSafetyReports({ String status, String category, String severity, String reporterId, String cursor, int limit }) async
    test('test listSafetyReports', () async {
      // TODO
    });

    // Transition Safety Report
    //
    //Future<SafetyReportDetail> transitionSafetyReport(String reportId, TransitionSafetyReportRequest transitionSafetyReportRequest) async
    test('test transitionSafetyReport', () async {
      // TODO
    });

    // Update Corrective Action
    //
    //Future<SafetyReportDetail> updateCorrectiveAction(String reportId, String actionId, UpdateCorrectiveActionRequest updateCorrectiveActionRequest) async
    test('test updateCorrectiveAction', () async {
      // TODO
    });

    // Upload Safety Evidence
    //
    //Future<SafetyReportDetail> uploadSafetyEvidence(String reportId, String kind, MultipartFile file) async
    test('test uploadSafetyEvidence', () async {
      // TODO
    });
  });
}
