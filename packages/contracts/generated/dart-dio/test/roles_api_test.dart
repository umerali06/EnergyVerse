import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for RolesApi
void main() {
  final instance = FevApiClient().getRolesApi();

  group(RolesApi, () {
    // Create Role
    //
    //Future<RoleDetail> createRole(CreateRoleRequest createRoleRequest) async
    test('test createRole', () async {
      // TODO
    });

    // Delete Role
    //
    //Future<RoleDeleted> deleteRole(String roleId) async
    test('test deleteRole', () async {
      // TODO
    });

    // Get Role
    //
    //Future<RoleDetail> getRole(String roleId) async
    test('test getRole', () async {
      // TODO
    });

    // List Roles
    //
    //Future<RoleList> listRoles() async
    test('test listRoles', () async {
      // TODO
    });

    // Update Role
    //
    //Future<RoleDetail> updateRole(String roleId, UpdateRoleRequest updateRoleRequest) async
    test('test updateRole', () async {
      // TODO
    });
  });
}
