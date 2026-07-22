import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/company_fixtures.dart';
import 'support/dashboard_fixtures.dart';

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

typedef GetCompanyProfileFn = Future<CompanyProfile> Function();

class FakeApi implements ApiContract {
  FakeApi(this.identity, {GetCompanyProfileFn? getCompanyProfile})
      : _getCompanyProfile = getCompanyProfile ?? (() async => companyProfileFixture());

  final CurrentUser identity;
  final GetCompanyProfileFn _getCompanyProfile;

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
      throw UnimplementedError();

  @override
  Future<UserDetail> getUser(String userId) => throw UnimplementedError();

  @override
  Future<RoleList> getRoles() => throw UnimplementedError();

  @override
  Future<RoleDetail> getRole(String roleId) => throw UnimplementedError();

  @override
  Future<CompanyProfile> getCompanyProfile() => _getCompanyProfile();
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

Future<void> pumpSettings(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.settings),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows loading then renders the company profile', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Acme Energy'), findsOneWidget);
    expect(find.text('Electric Utility'), findsOneWidget);
    expect(find.text('PROFESSIONAL'), findsOneWidget);
    expect(find.textContaining('Company since'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the profile request fails', (tester) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getCompanyProfile: () async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(attempts, 1);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('hides Company Settings for a role without company.settings at the route level',
      (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    expect(find.text('Acme Energy'), findsNothing);
  });
}
