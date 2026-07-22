import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/audit_fixtures.dart';
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
    'audit.read',
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

typedef GetAuditLogsFn = Future<AuditLogPage> Function({
  DateTime? fromDate,
  DateTime? toDate,
  String? actorUid,
  String? action,
  String? targetType,
  String? q,
  String? cursor,
  int limit,
});
typedef GetAuditLogFacetsFn = Future<AuditLogFacets> Function({
  DateTime? fromDate,
  DateTime? toDate,
});

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    GetAuditLogsFn? getAuditLogs,
    GetAuditLogFacetsFn? getAuditLogFacets,
  })  : _getAuditLogs = getAuditLogs ??
            (({
              DateTime? fromDate,
              DateTime? toDate,
              String? actorUid,
              String? action,
              String? targetType,
              String? q,
              String? cursor,
              int limit = 20,
            }) async =>
                auditLogPageFixture()),
        _getAuditLogFacets = getAuditLogFacets ??
            (({DateTime? fromDate, DateTime? toDate}) async => auditLogFacetsFixture());

  final CurrentUser identity;
  final GetAuditLogsFn _getAuditLogs;
  final GetAuditLogFacetsFn _getAuditLogFacets;

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
      _getAuditLogs(
        fromDate: fromDate,
        toDate: toDate,
        actorUid: actorUid,
        action: action,
        targetType: targetType,
        q: q,
        cursor: cursor,
        limit: limit,
      );

  @override
  Future<AuditLogFacets> getAuditLogFacets({DateTime? fromDate, DateTime? toDate}) =>
      _getAuditLogFacets(fromDate: fromDate, toDate: toDate);
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

Future<void> pumpAudit(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.audit),
  );
  await tester.pump();
}

Future<void> scrollTo(WidgetTester tester, Finder finder, {int maxDrags = 12}) async {
  final list = find.byKey(const Key('audit-scroll'));
  for (var i = 0; i < maxDrags; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  expect(finder.evaluate(), isNotEmpty, reason: 'target not found after $maxDrags scroll steps');
}

void main() {
  testWidgets('shows loading then renders the real tenant audit entries', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpAudit(tester, api: api);
    await tester.pump();

    expect(find.byType(Card), findsWidgets);
    await tester.pumpAndSettle();

    expect(find.textContaining('Acme Field Inspector'), findsWidgets);
  });

  testWidgets('shows an honest empty state when no events match', (tester) async {
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAuditLogs: ({
        DateTime? fromDate,
        DateTime? toDate,
        String? actorUid,
        String? action,
        String? targetType,
        String? q,
        String? cursor,
        int limit = 20,
      }) async =>
          auditLogPageFixture(items: const []),
    );
    await pumpAudit(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('No events found'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the list request fails', (tester) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAuditLogs: ({
        DateTime? fromDate,
        DateTime? toDate,
        String? actorUid,
        String? action,
        String? targetType,
        String? q,
        String? cursor,
        int limit = 20,
      }) async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpAudit(tester, api: api);
    await tester.pumpAndSettle();

    final retry = find.text('Retry');
    expect(retry, findsOneWidget);
    expect(attempts, 1);
    await tester.ensureVisible(retry);
    await tester.pumpAndSettle();
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('loads more events via cursor pagination and appends without duplicating', (
    tester,
  ) async {
    var calls = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAuditLogs: ({
        DateTime? fromDate,
        DateTime? toDate,
        String? actorUid,
        String? action,
        String? targetType,
        String? q,
        String? cursor,
        int limit = 20,
      }) async {
        calls += 1;
        if (cursor == null) {
          return auditLogPageFixture(
            items: [auditLogEntryFixture(id: 'e1')],
            nextCursor: 'cursor-1',
          );
        }
        expect(cursor, 'cursor-1');
        return auditLogPageFixture(
          items: [
            auditLogEntryFixture(
              id: 'e2',
              actorName: 'Second Actor',
              action: 'role.updated',
            ),
          ],
        );
      },
    );
    await pumpAudit(tester, api: api);
    await tester.pumpAndSettle();

    final loadMore = find.byKey(const Key('load-more-audit'));
    await scrollTo(tester, loadMore);
    await tester.tap(loadMore);
    await tester.pumpAndSettle();

    expect(find.textContaining('Second Actor'), findsWidgets);
    expect(find.byKey(const Key('load-more-audit')), findsNothing);
    expect(calls, 2);
  });

  testWidgets('opens an event detail sheet with the before/after diff', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpAudit(tester, api: api);
    await tester.pumpAndSettle();

    await tester.tap(find.textContaining('Acme Field Inspector').first);
    await tester.pumpAndSettle();

    expect(find.text('BEFORE'), findsOneWidget);
    expect(find.text('AFTER'), findsOneWidget);
  });

  testWidgets('hides Audit Log for a role without audit.read at the route level', (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpAudit(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
  });
}
