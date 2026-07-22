import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/dashboard_fixtures.dart';

const session = AuthSession(
  uid: 'firebase-uid',
  email: 'field_inspector@acme.example.invalid',
  emailVerified: true,
);

/// Mirror of the Phase 0.4 SYSTEM_ROLE_TEMPLATES matrix
/// (apps/api/app/rbac/constants.py). If this drifts from the API, the
/// table-driven expectations below are wrong.
const roleMatrix = <String, List<String>>{
  'company_admin': [
    'assets.read',
    'assets.write',
    'inspections.read',
    'inspections.write',
    'permits.read',
    'permits.approve',
    'work_orders.read',
    'work_orders.write',
    'reports.read',
    'reports.generate',
    'safety.read',
    'safety.write',
    'users.manage',
    'roles.manage',
    'company.settings',
  ],
  'field_inspector': [
    'assets.read',
    'inspections.read',
    'inspections.write',
    'permits.read',
    'work_orders.read',
    'reports.read',
    'reports.generate',
    'safety.read',
    'safety.write',
  ],
  'executive': [
    'assets.read',
    'inspections.read',
    'permits.read',
    'work_orders.read',
    'reports.read',
    'safety.read',
  ],
};

CurrentUser identityFor(String roleKey, List<String> permissions) =>
    CurrentUser(
      (builder) => builder
        ..uid = 'firebase-uid'
        ..email = 'field_inspector@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = roleKey
        ..emailVerified = true
        ..permissions.addAll(permissions),
    );

class FakeApi implements ApiContract {
  FakeApi(this.result);

  CurrentUser result;
  int requests = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    return result;
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
      throw UnimplementedError();

  @override
  Future<UserDetail> getUser(String userId) => throw UnimplementedError();

  @override
  Future<RoleList> getRoles() => throw UnimplementedError();

  @override
  Future<RoleDetail> getRole(String roleId) => throw UnimplementedError();
}

class FakeGateway implements AuthGateway {
  int signOutCalls = 0;

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
  Future<void> signOut() async {
    signOutCalls += 1;
  }
}

Future<void> pumpShell(
  WidgetTester tester, {
  required List<String> permissions,
  String roleKey = 'field_inspector',
  String initialRoute = AppRoutes.home,
  FakeGateway? gateway,
}) async {
  await tester.pumpWidget(
    FevApp(
      authGateway: gateway ?? FakeGateway(),
      api: FakeApi(identityFor(roleKey, permissions)),
      initialRoute: initialRoute,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('bottom navigation filtering (0.4 matrix)', () {
    testWidgets('company_admin sees all primaries and every More module', (
      tester,
    ) async {
      await pumpShell(
        tester,
        permissions: roleMatrix['company_admin']!,
        roleKey: 'company_admin',
      );
      for (final key in ['nav-/', 'nav-/assets', 'nav-/work-orders', 'nav-more']) {
        expect(find.byKey(Key(key)), findsOneWidget);
      }
      await tester.tap(find.byKey(const Key('nav-more')));
      await tester.pumpAndSettle();
      for (final route in [
        '/inspections',
        '/permits',
        '/safety',
        '/reports',
        '/documents',
        '/users',
        '/settings',
      ]) {
        await tester.scrollUntilVisible(
          find.byKey(Key('more-$route')),
          100,
          scrollable: find
              .descendant(
                of: find.byType(BottomSheet),
                matching: find.byType(Scrollable),
              )
              .first,
        );
        expect(find.byKey(Key('more-$route')), findsOneWidget);
      }
    });

    testWidgets('field_inspector sees everything except Admin & Settings', (
      tester,
    ) async {
      await pumpShell(tester, permissions: roleMatrix['field_inspector']!);
      expect(find.byKey(const Key('nav-/assets')), findsOneWidget);
      expect(find.byKey(const Key('nav-/work-orders')), findsOneWidget);
      await tester.tap(find.byKey(const Key('nav-more')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('more-/settings')), findsNothing);
      expect(find.byKey(const Key('more-/users')), findsNothing);
      expect(find.byKey(const Key('more-/safety')), findsOneWidget);
    });

    testWidgets('a minimal custom permission set hides gated destinations', (
      tester,
    ) async {
      await pumpShell(
        tester,
        permissions: const ['safety.read'],
        roleKey: 'custom_safety_viewer',
      );
      expect(find.byKey(const Key('nav-/')), findsOneWidget);
      expect(find.byKey(const Key('nav-/assets')), findsNothing);
      expect(find.byKey(const Key('nav-/work-orders')), findsNothing);
      await tester.tap(find.byKey(const Key('nav-more')));
      await tester.pumpAndSettle();
      // Dashboard and Documents carry no requiredPermission by design.
      expect(find.byKey(const Key('more-/safety')), findsOneWidget);
      expect(find.byKey(const Key('more-/documents')), findsOneWidget);
      expect(find.byKey(const Key('more-/inspections')), findsNothing);
      expect(find.byKey(const Key('more-/settings')), findsNothing);
    });
  });

  testWidgets('tapping a bottom destination routes to its Coming soon page', (
    tester,
  ) async {
    await pumpShell(tester, permissions: roleMatrix['field_inspector']!);
    await tester.tap(find.byKey(const Key('nav-/assets')));
    await tester.pumpAndSettle();
    expect(find.text('Assets is coming soon'), findsOneWidget);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 1);
  });

  testWidgets('a More destination routes and marks the More tab active', (
    tester,
  ) async {
    await pumpShell(tester, permissions: roleMatrix['field_inspector']!);
    await tester.tap(find.byKey(const Key('nav-more')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('more-/reports')));
    await tester.pumpAndSettle();
    expect(find.text('Reports is coming soon'), findsOneWidget);
    expect(find.byType(BottomSheet), findsNothing);
    final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(bar.selectedIndex, 3);
  });

  testWidgets('unknown routes land on the branded 404 inside the shell', (
    tester,
  ) async {
    await pumpShell(
      tester,
      permissions: roleMatrix['field_inspector']!,
      initialRoute: '/does-not-exist',
    );
    expect(find.text("This page doesn't exist"), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Welcome,'), findsOneWidget);
  });

  testWidgets('user menu shows identity and role/company details', (
    tester,
  ) async {
    await pumpShell(tester, permissions: roleMatrix['field_inspector']!);
    await tester.tap(find.byKey(const Key('user-menu')));
    await tester.pumpAndSettle();
    expect(find.text('Field Inspector'), findsOneWidget);
    // The email/company also appear in the dashboard content behind the menu.
    expect(find.text('field_inspector@acme.example.invalid'), findsWidgets);
    expect(find.text('Acme Energy'), findsWidgets);
    expect(find.text('Refresh session'), findsOneWidget);
    expect(find.text('Sign out'), findsOneWidget);
  });

  testWidgets('theme toggle switches the persisted theme mode', (tester) async {
    await pumpShell(tester, permissions: roleMatrix['field_inspector']!);
    final before = Theme.of(tester.element(find.byType(NavigationBar))).brightness;
    await tester.tap(find.byKey(const Key('theme-toggle')));
    await tester.pumpAndSettle();
    final after = Theme.of(tester.element(find.byType(NavigationBar))).brightness;
    expect(after, isNot(before));
  });
}
