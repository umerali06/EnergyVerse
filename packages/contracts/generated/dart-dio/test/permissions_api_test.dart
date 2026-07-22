import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for PermissionsApi
void main() {
  final instance = FevApiClient().getPermissionsApi();

  group(PermissionsApi, () {
    // List Permission Catalog
    //
    //Future<PermissionCatalog> listPermissionCatalog() async
    test('test listPermissionCatalog', () async {
      // TODO
    });
  });
}
