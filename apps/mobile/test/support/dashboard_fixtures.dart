import 'package:built_collection/built_collection.dart';
import 'package:fev_api_client/fev_api_client.dart';

/// Minimal real-shaped dashboard fixtures for tests that don't exercise the
/// dashboard itself (auth/shell/permission suites) — DashboardScreen just
/// needs something stable to resolve to once it lands on "/".
DashboardSummary dashboardSummaryFixture({
  String companyName = 'Acme Energy',
  int usersTotal = 7,
  int usersActive = 7,
  int rolesTotal = 7,
  int auditEvents = 3,
  int windowDays = 30,
}) {
  return DashboardSummary(
    (builder) => builder
      ..companyName = companyName
      ..subscriptionTier = 'standard'
      ..companyCreatedAt = DateTime.utc(2026, 1, 1)
      ..usersTotal = usersTotal
      ..usersActive = usersActive
      ..rolesTotal = rolesTotal
      ..auditEvents = auditEvents
      ..windowDays = windowDays,
  );
}

DashboardActivityPage emptyDashboardActivityPage() {
  return DashboardActivityPage((builder) => builder..items = ListBuilder([]));
}

DashboardActivitySeries dashboardSeriesFixture({int windowDays = 30}) {
  return DashboardActivitySeries(
    (builder) => builder
      ..windowDays = windowDays
      ..points = ListBuilder([
        for (var i = 0; i < windowDays; i++)
          DashboardSeriesPoint(
            (pointBuilder) => pointBuilder
              ..date = Date.now().toDateTime().subtract(Duration(days: windowDays - 1 - i)).toDate()
              ..count = 0,
          ),
      ]),
  );
}
