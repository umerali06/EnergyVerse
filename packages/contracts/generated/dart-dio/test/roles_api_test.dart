import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for RolesApi
void main() {
  final instance = FevApiClient().getRolesApi();

  group(RolesApi, () {
    // List Roles
    //
    //Future<RoleList> listRoles() async
    test('test listRoles', () async {
      // TODO
    });
  });
}
