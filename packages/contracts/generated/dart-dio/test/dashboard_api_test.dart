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

    // Dashboard Summary
    //
    //Future<DashboardSummary> getDashboardSummary({ int window }) async
    test('test getDashboardSummary', () async {
      // TODO
    });
  });
}
