import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/dashboard_fixtures.dart';
import 'support/users_fixtures.dart';

const session = AuthSession(
  uid: 'demo-acme-company_admin',
  email: 'company_admin@acme.example.invalid',
  emailVerified: true,
);

const roleMatrix = <String, List<String>>{
  'company_admin': [
    'assets.read',
    'reports.read',
    'reports.generate',
    'users.manage',
    'roles.manage',
    'company.settings',
  ],
  'field_inspector': ['assets.read', 'reports.read', 'reports.generate'],
};

CurrentUser identityFor(String roleKey, List<String> permissions) => CurrentUser(
      (builder) => builder
        ..uid = 'demo-acme-company_admin'
        ..email = 'company_admin@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = roleKey
        ..emailVerified = true
        ..permissions.addAll(permissions),
    );

typedef ListUsersFn = Future<UserListPage> Function({
  String? search,
  String? roleId,
  String? status,
  String sort,
  String? cursor,
  int limit,
});
typedef GetUserFn = Future<UserDetail> Function(String userId);

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    ListUsersFn? listUsers,
    GetUserFn? getUser,
  })  : _listUsers = listUsers ??
            (({
              String? search,
              String? roleId,
              String? status,
              String sort = 'name',
              String? cursor,
              int limit = 25,
            }) async =>
                userListPageFixture()),
        _getUser = getUser ?? ((userId) async => userDetailFixture(id: userId));

  final CurrentUser identity;
  final ListUsersFn _listUsers;
  final GetUserFn _getUser;

  @override
  Future<CurrentUser> getCurrentUser() async => identity;

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
  Future<DashboardSummary> getDashboardSummary({int window = 30}) async =>
      dashboardSummaryFixture(windowDays: window);

  @override
  Future<DashboardActivityPage> getDashboardActivity({
    int limit = 20,
    String? cursor,
    String? action,
  }) async =>
      emptyDashboardActivityPage();

  @override
  Future<DashboardActivitySeries> getDashboardActivitySeries({int window = 30}) async =>
      dashboardSeriesFixture(windowDays: window);

  @override
  Future<UserListPage> getUsers({
    String? search,
    String? roleId,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) =>
      _listUsers(
        search: search,
        roleId: roleId,
        status: status,
        sort: sort,
        cursor: cursor,
        limit: limit,
      );

  @override
  Future<UserDetail> getUser(String userId) => _getUser(userId);
}

class FakeGateway implements AuthGateway {
  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(session);

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => 'id-token';

  @override
  Future<AuthSession> refreshSession() async => session;

  @override
  Future<void> sendEmailVerification() async {}

  @override
  Future<void> sendPasswordResetEmail(String email) async {}

  @override
  Future<AuthSession> signIn(String email, String password) async => session;

  @override
  Future<void> signOut() async {}
}

Future<void> pumpUsers(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.users),
  );
  await tester.pump();
}

Future<void> scrollTo(WidgetTester tester, Finder finder, {int maxDrags = 12}) async {
  final list = find.byKey(const Key('users-scroll'));
  for (var i = 0; i < maxDrags; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  expect(finder.evaluate(), isNotEmpty, reason: 'target not found after $maxDrags scroll steps');
}

void main() {
  testWidgets('shows loading then renders the real tenant users', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpUsers(tester, api: api);
    await tester.pump();

    expect(find.byType(Card), findsWidgets);
    await tester.pumpAndSettle();

    expect(find.text('Acme Field Inspector'), findsOneWidget);
    expect(find.text('field_inspector@acme.example.invalid'), findsOneWidget);
  });

  testWidgets('shows an honest empty state when no users match', (tester) async {
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      listUsers: ({
        String? search,
        String? roleId,
        String? status,
        String sort = 'name',
        String? cursor,
        int limit = 25,
      }) async =>
          userListPageFixture(items: const []),
    );
    await pumpUsers(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('No users found'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the list request fails', (tester) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      listUsers: ({
        String? search,
        String? roleId,
        String? status,
        String sort = 'name',
        String? cursor,
        int limit = 25,
      }) async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpUsers(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(attempts, 1);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('loads more users via cursor pagination and appends without duplicating', (
    tester,
  ) async {
    var calls = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      listUsers: ({
        String? search,
        String? roleId,
        String? status,
        String sort = 'name',
        String? cursor,
        int limit = 25,
      }) async {
        calls += 1;
        if (cursor == null) {
          return userListPageFixture(
            items: [userListItemFixture(id: 'u1')],
            nextCursor: 'cursor-1',
          );
        }
        expect(cursor, 'cursor-1');
        return userListPageFixture(
          items: [
            userListItemFixture(
              id: 'u2',
              email: 'second@acme.example.invalid',
              displayName: 'Second User',
            ),
          ],
        );
      },
    );
    await pumpUsers(tester, api: api);
    await tester.pumpAndSettle();

    final loadMore = find.byKey(const Key('load-more-users'));
    await scrollTo(tester, loadMore);
    await tester.tap(loadMore);
    await tester.pumpAndSettle();

    expect(find.text('Second User'), findsOneWidget);
    expect(find.byKey(const Key('load-more-users')), findsNothing);
    expect(calls, 2);
  });

  testWidgets('opens a user detail sheet with effective permissions', (tester) async {
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getUser: (userId) async =>
          userDetailFixture(id: userId, permissions: ['assets.read', 'inspections.read']),
    );
    await pumpUsers(tester, api: api);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Acme Field Inspector'));
    await tester.pumpAndSettle();

    expect(find.text('assets.read'), findsWidgets);
    expect(find.text('inspections.read'), findsOneWidget);
  });

  testWidgets('hides Users for a role without users.manage at the route level', (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpUsers(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    expect(find.text('Acme Field Inspector'), findsNothing);
  });
}
