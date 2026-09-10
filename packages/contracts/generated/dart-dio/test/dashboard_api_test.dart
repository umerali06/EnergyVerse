import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for DashboardApi
void main() {
  final instance = FevApiClient().getDashboardApi();

  group(DashboardApi, () {
    // Dashboard Activity
    //
    //Future<DashboardActivityPage> getDashboardActivity({ int limit, String cursor, String action }) async
    test('test getDashboardActivity', () async {
      // TODO
    });

    // Dashboard Activity Series
    //
    //Future<DashboardActivitySeries> getDashboardActivitySeries({ int window }) async
    test('test getDashboardActivitySeries', () async {
      // TODO
    });

    // Dashboard Assets Summary
    //
    //Future<AssetDashboardSummary> getDashboardAssetsSummary() async
    test('test getDashboardAssetsSummary', () async {
      // TODO
    });

    // Dashboard Permits Summary
    //
    //Future<PermitDashboardSummary> getDashboardPermitsSummary() async
    test('test getDashboardPermitsSummary', () async {
      // TODO
    });

    // Dashboard Reports Summary
    //
    //Future<ReportDashboardSummary> getDashboardReportsSummary() async
    test('test getDashboardReportsSummary', () async {
      // TODO
    });

    // Dashboard Safety Summary
    //
    //Future<SafetyDashboardSummary> getDashboardSafetySummary() async
    test('test getDashboardSafetySummary', () async {
      // TODO
    });

    // Dashboard Summary
    //
    //Future<DashboardSummary> getDashboardSummary({ int window }) async
    test('test getDashboardSummary', () async {
      // TODO
    });
  });
}
