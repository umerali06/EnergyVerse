import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for AuditApi
void main() {
  final instance = FevApiClient().getAuditApi();

  group(AuditApi, () {
    // Export Audit Logs
    //
    //Future<JsonObject> exportAuditLogs({ Date fromDate, Date toDate, String actorUid, String action, String targetType, String q }) async
    test('test exportAuditLogs', () async {
      // TODO
    });

    // Get Audit Log Facets
    //
    //Future<AuditLogFacets> getAuditLogFacets({ Date fromDate, Date toDate }) async
    test('test getAuditLogFacets', () async {
      // TODO
    });

    // List Audit Logs
    //
    //Future<AuditLogPage> listAuditLogs({ Date fromDate, Date toDate, String actorUid, String action, String targetType, String q, String cursor, int limit }) async
    test('test listAuditLogs', () async {
      // TODO
    });
  });
}
