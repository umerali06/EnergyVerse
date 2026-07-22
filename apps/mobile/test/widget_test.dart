import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

class _SignedOutGateway implements AuthGateway {
  @override
  Stream<AuthSession?> authStateChanges() => Stream.value(null);

  @override
  Future<String?> getIdToken({bool forceRefresh = false}) async => null;

  @override
  Future<AuthSession> refreshSession() => throw UnimplementedError();

  @override
  Future<void> sendEmailVerification() => throw UnimplementedError();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      throw UnimplementedError();

  @override
  Future<AuthSession> signIn(String email, String password) =>
      throw UnimplementedError();

  @override
  Future<void> signOut() async {}
}

class _UnusedApi implements ApiContract {
  @override
  Future<CurrentUser> getCurrentUser() => throw UnimplementedError();

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

  @override
  Future<CompanyProfile> getCompanyProfile() => throw UnimplementedError();

  @override
  Future<AuditLogPage> getAuditLogs({
    DateTime? fromDate,
    DateTime? toDate,
    String? actorUid,
    String? action,
    String? targetType,
    String? q,
    String? cursor,
    int limit = 20,
  }) =>
      throw UnimplementedError();

  @override
  Future<AuditLogFacets> getAuditLogFacets({DateTime? fromDate, DateTime? toDate}) =>
      throw UnimplementedError();
}

void main() {
  testWidgets('renders the login screen', (tester) async {
    await tester.pumpWidget(
      FevApp(api: _UnusedApi(), authGateway: _SignedOutGateway()),
    );
    // Signed-out state redirects the protected home route to /login.
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
