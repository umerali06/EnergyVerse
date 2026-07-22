import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _IdentityApi implements ApiContract {
  _IdentityApi(this.permissionKeys);

  final Iterable<String> permissionKeys;
  int requests = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    return CurrentUser(
      (builder) => builder
        ..uid = 'test-uid'
        ..email = 'test@example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = 'custom'
        ..emailVerified = true
        ..permissions.addAll(permissionKeys),
    );
  }

  @override
  Future<HealthResponse> getHealth() => throw UnimplementedError();

  @override
  Future<CompanyRegistrationResponse> registerCompanyAdmin({
    required String companyName,
    required String displayName,
    required String email,
    required String password,
  }) =>
      throw UnimplementedError();

  @override
  Future<DashboardSummary> getDashboardSummary({int window = 30}) =>
      throw UnimplementedError();

  @override
  Future<DashboardActivityPage> getDashboardActivity({
    int limit = 20,
    String? cursor,
    String? action,
  }) =>
      throw UnimplementedError();

  @override
  Future<DashboardActivitySeries> getDashboardActivitySeries({int window = 30}) =>
      throw UnimplementedError();

  @override
  Future<UserListPage> getUsers({
    String? search,
    String? roleId,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

  @override
  Future<UserDetail> getUser(String userId) => throw UnimplementedError();

  @override
  Future<RoleList> getRoles() => throw UnimplementedError();

  @override
  Future<RoleDetail> getRole(String roleId) => throw UnimplementedError();
}

void main() {
  test('can, hasAny, and hasAll evaluate a sample permission set', () {
    final access = PermissionAccess(const [
      'assets.read',
      'assets.write',
      'reports.read',
    ]);

    expect(access.can('assets.write'), isTrue);
    expect(access.can('users.manage'), isFalse);
    expect(access.hasAny(const ['users.manage', 'reports.read']), isTrue);
    expect(access.hasAny(const ['users.manage', 'roles.manage']), isFalse);
    expect(access.hasAll(const ['assets.read', 'assets.write']), isTrue);
    expect(access.hasAll(const ['assets.read', 'users.manage']), isFalse);
  });

  test(
    'loads permissions once through the generated-client API service seam',
    () async {
      final api = _IdentityApi(const ['assets.read', 'assets.write']);
      final controller = PermissionController(api: api);

      await controller.loadFromMe();

      expect(api.requests, 1);
      expect(controller.status, PermissionStatus.ready);
      expect(controller.can('assets.write'), isTrue);
      controller.dispose();
    },
  );

  testWidgets('role with permission sees the protected block', (tester) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.write'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('Protected asset action'), findsOneWidget);
    expect(find.text('No access'), findsNothing);
    controller.dispose();
  });

  testWidgets('role without permission sees the no-access state', (
    tester,
  ) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.read'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('No access'), findsOneWidget);
    expect(find.text('Protected asset action'), findsNothing);
    controller.dispose();
  });
}
