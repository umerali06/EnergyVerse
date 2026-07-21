import 'package:test/test.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// tests for UsersApi
void main() {
  final instance = FevApiClient().getUsersApi();

  group(UsersApi, () {
    // Get User
    //
    //Future<UserDetail> getUser(String userId) async
    test('test getUser', () async {
      // TODO
    });

    // Invite User
    //
    //Future<UserDetail> inviteUser(InviteUserRequest inviteUserRequest) async
    test('test inviteUser', () async {
      // TODO
    });

    // List Users
    //
    //Future<UserListPage> listUsers({ String search, String roleId, String status, String sort, String cursor, int limit }) async
    test('test listUsers', () async {
      // TODO
    });

    // Set User Status
    //
    //Future<UserDetail> setUserStatus(String userId, UpdateUserStatusRequest updateUserStatusRequest) async
    test('test setUserStatus', () async {
      // TODO
    });

    // Update User
    //
    //Future<UserDetail> updateUser(String userId, UpdateUserRequest updateUserRequest) async
    test('test updateUser', () async {
      // TODO
    });
  });
}
