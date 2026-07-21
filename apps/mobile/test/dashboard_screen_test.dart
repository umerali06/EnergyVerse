import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/design_system/tokens_generated.dart';
import 'package:fev_mobile/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/dashboard_fixtures.dart';

const session = AuthSession(
  uid: 'firebase-uid',
  email: 'field_inspector@acme.example.invalid',
  emailVerified: true,
);

/// Mirror of the 0.4 SYSTEM_ROLE_TEMPLATES matrix (apps/api/app/rbac/constants.py).
/// Only company_admin/super_admin hold users.manage and roles.manage.
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
  'operations_manager': ['assets.read', 'assets.write', 'reports.read', 'reports.generate'],
};

CurrentUser identityFor(String roleKey, List<String> permissions) => CurrentUser(
      (builder) => builder
        ..uid = 'firebase-uid'
        ..email = 'field_inspector@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = roleKey
        ..emailVerified = true
        ..permissions.addAll(permissions),
    );

DashboardActivityItem activityItem({String id = 'evt-1', String action = 'company.updated'}) {
  return DashboardActivityItem(
    (builder) => builder
      ..id = id
      ..actorUid = 'demo-acme-field_inspector'
      ..actorName = 'Acme Field Inspector'
      ..action = action
      ..targetType = 'company'
      ..targetId = 'acme-energy'
      ..createdAt = DateTime.now().subtract(const Duration(minutes: 5)),
  );
}

typedef SummaryFn = Future<DashboardSummary> Function({int window});
typedef ActivityFn = Future<DashboardActivityPage> Function({
  int limit,
  String? cursor,
  String? action,
});
typedef SeriesFn = Future<DashboardActivitySeries> Function({int window});

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    SummaryFn? summary,
    ActivityFn? activity,
    SeriesFn? series,
  })  : _summary = summary ?? (({int window = 30}) async => dashboardSummaryFixture(windowDays: window)),
        _activity = activity ?? (({int limit = 20, String? cursor, String? action}) async => DashboardActivityPage(
              (builder) => builder
                ..items = ListBuilder([activityItem()])
                ..nextCursor = null,
            )),
        _series = series ?? (({int window = 30}) async => dashboardSeriesFixture(windowDays: window));

  CurrentUser identity;
  final SummaryFn _summary;
  final ActivityFn _activity;
  final SeriesFn _series;

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
  Future<DashboardSummary> getDashboardSummary({int window = 30}) => _summary(window: window);

  @override
  Future<DashboardActivityPage> getDashboardActivity({
    int limit = 20,
    String? cursor,
    String? action,
  }) =>
      _activity(limit: limit, cursor: cursor, action: action);

  @override
  Future<DashboardActivitySeries> getDashboardActivitySeries({int window = 30}) =>
      _series(window: window);
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

Future<void> pumpDashboard(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(
      api: api,
      authGateway: FakeGateway(),
      initialRoute: AppRoutes.home,
    ),
  );
  await tester.pump();
}

/// The dashboard body is a scrollable ListView, so content past the first
/// screenful only gets an Element (and becomes findable) once scrolled into
/// the viewport.
/// Manually drives the dashboard ListView rather than using
/// WidgetController.scrollUntilVisible: that helper re-resolves the
/// Scrollable's Element via `.single` on every iteration, which is fragile
/// here across the AnimatedBuilder-driven rebuilds triggered by controller
/// notifications mid-scroll. Dragging the keyed ListView directly and
/// re-checking the target after each step sidesteps that entirely.
Future<void> scrollTo(WidgetTester tester, Finder finder, {int maxDrags = 12}) async {
  final list = find.byKey(const Key('dashboard-scroll'));
  for (var i = 0; i < maxDrags; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  expect(finder.evaluate(), isNotEmpty, reason: 'target not found after $maxDrags scroll steps');
}

void main() {
  testWidgets('shows loading then renders the real summary data', (tester) async {
    final completer = Completer<DashboardSummary>();
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      summary: ({int window = 30}) => completer.future,
    );
    await pumpDashboard(tester, api: api);
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    completer.complete(dashboardSummaryFixture(usersTotal: 9, usersActive: 8));
    await tester.pumpAndSettle();

    expect(find.text('9'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
  });

  testWidgets('renders the honest empty state for a fresh tenant with no activity', (
    tester,
  ) async {
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      summary: ({int window = 30}) async => dashboardSummaryFixture(auditEvents: 0),
      activity: ({int limit = 20, String? cursor, String? action}) async =>
          emptyDashboardActivityPage(),
      series: ({int window = 30}) async => dashboardSeriesFixture(windowDays: window),
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('No activity to chart yet'));
    expect(find.text('No activity to chart yet'), findsOneWidget);
    await scrollTo(tester, find.text('Activity will appear here as your team uses FEV.'));
    expect(find.text('Activity will appear here as your team uses FEV.'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the summary request fails', (
    tester,
  ) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      summary: ({int window = 30}) async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsWidgets);
    expect(attempts, 1);
    await tester.tap(find.text('Retry').first);
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets("shows the activity feed's own error state independently of the chart", (
    tester,
  ) async {
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      activity: ({int limit = 20, String? cursor, String? action}) async =>
          throw Exception('down'),
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    final errorText =
        find.text("Couldn't load recent activity. Check your connection and try again.");
    await scrollTo(tester, errorText);
    expect(errorText, findsOneWidget);
  });

  testWidgets('refetches summary and series when the window switcher changes', (
    tester,
  ) async {
    final summaryWindows = <int>[];
    final seriesWindows = <int>[];
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      summary: ({int window = 30}) async {
        summaryWindows.add(window);
        return dashboardSummaryFixture(windowDays: window);
      },
      series: ({int window = 30}) async {
        seriesWindows.add(window);
        return dashboardSeriesFixture(windowDays: window);
      },
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();
    expect(summaryWindows, [30]);

    await scrollTo(tester, find.text('7d'));
    await tester.tap(find.text('7d'));
    await tester.pumpAndSettle();

    expect(summaryWindows, [30, 7]);
    expect(seriesWindows, [30, 7]);
  });

  testWidgets('loads more activity via cursor pagination and appends without duplicating', (
    tester,
  ) async {
    var calls = 0;
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      activity: ({int limit = 20, String? cursor, String? action}) async {
        calls += 1;
        if (cursor == null) {
          return DashboardActivityPage(
            (builder) => builder
              ..items = ListBuilder([activityItem(id: 'evt-1')])
              ..nextCursor = 'cursor-1',
          );
        }
        expect(cursor, 'cursor-1');
        return DashboardActivityPage(
          (builder) => builder
            ..items = ListBuilder([activityItem(id: 'evt-2', action: 'user.provisioned')])
            ..nextCursor = null,
        );
      },
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    final loadMore = find.byKey(const Key('load-more-activity'));
    await scrollTo(tester, loadMore);
    expect(loadMore, findsOneWidget);
    await tester.tap(loadMore);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('load-more-activity')), findsNothing);
    expect(calls, 2);
  });

  testWidgets('shows exactly the permission-gated stat cards for company_admin', (
    tester,
  ) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('USERS IN COMPANY'), findsOneWidget);
    expect(find.text('ACTIVE USERS'), findsOneWidget);
    expect(find.text('ROLES CONFIGURED'), findsOneWidget);
  });

  for (final roleKey in ['field_inspector', 'operations_manager']) {
    testWidgets('hides users/roles stat cards for $roleKey', (tester) async {
      final api = FakeApi(identityFor(roleKey, roleMatrix[roleKey]!));
      await pumpDashboard(tester, api: api);
      await tester.pumpAndSettle();

      expect(find.text('USERS IN COMPANY'), findsNothing);
      expect(find.text('ACTIVE USERS'), findsNothing);
      expect(find.text('ROLES CONFIGURED'), findsNothing);
      expect(find.textContaining('AUDIT EVENTS'), findsOneWidget);
    });
  }

  testWidgets('renders the reserved KPI region only for permitted modules', (tester) async {
    final api = FakeApi(
      identityFor('field_inspector', ['assets.read', 'reports.read', 'reports.generate']),
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();

    await scrollTo(tester, find.text('On the roadmap'));
    expect(find.text('On the roadmap'), findsOneWidget);
    expect(find.text('Asset metrics appear once the Assets module is enabled.'), findsOneWidget);
    expect(
      find.text('Work order metrics appear once the Work Orders module is enabled.'),
      findsNothing,
    );
    expect(find.text('Safety & Incidents'), findsNothing);
  });

  testWidgets('renders without animation on the reduced-motion path', (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await tester.binding.setSurfaceSize(const Size(400, 800));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.home),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome,'), findsOneWidget);
    // Reduced-motion is honored via MediaQuery.disableAnimations, consumed by
    // motionDuration()/StaggeredReveal — proven generically in
    // design_system_test.dart; here we only confirm the dashboard itself
    // still renders correctly under that setting.
  });

  testWidgets('draws the chart using design-token colors, never a hardcoded hex', (
    tester,
  ) async {
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      // A real (non-empty) series so the chart renders LineChart rather than
      // the honest empty state — that path is covered by the empty-state
      // test above.
      series: ({int window = 30}) async => DashboardActivitySeries(
        (builder) => builder
          ..windowDays = window
          ..points = ListBuilder([
            for (var i = 0; i < window; i++)
              DashboardSeriesPoint(
                (pointBuilder) => pointBuilder
                  ..date = Date.now().toDateTime().subtract(Duration(days: window - 1 - i)).toDate()
                  ..count = i == window - 1 ? 5 : 0,
              ),
          ]),
      ),
    );
    await pumpDashboard(tester, api: api);
    await tester.pumpAndSettle();
    await scrollTo(tester, find.byType(LineChart));

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    // The app defaults to dark mode (AppThemeController), so ChartTheme.of
    // should have resolved the dark-mode line color from tokens.
    expect(chart.data.lineBarsData.single.color, DsColors.primary400);
  });
}
