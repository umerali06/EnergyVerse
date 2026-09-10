import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/design_system/theme.dart';
import 'package:fev_mobile/facilities/digital_twin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/assets_fixtures.dart';
import '../support/subscription_fixtures.dart';

class FakeFacilitiesApi implements ApiContract {
  @override
  Future<SubscriptionResponse> getSubscription() async =>
      subscriptionResponseFixture();

  @override
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async {
    return facilityListPageFixture(items: [
      facilityFixture(id: 'facility-north', name: 'North Refinery'),
    ]);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget buildTestableScreen(ApiContract api) {
  return MaterialApp(
    theme: AppThemes.dark,
    home: Scaffold(
      body: DigitalTwinScreen(api: api),
    ),
  );
}

void main() {
  testWidgets('DigitalTwinScreen renders title, facility selector, and spatial nodes', (tester) async {
    final api = FakeFacilitiesApi();
    await tester.pumpWidget(buildTestableScreen(api));
    await tester.pumpAndSettle();

    expect(find.text('3D Digital Twin'), findsOneWidget);
    expect(find.text('North Refinery'), findsWidgets);
    expect(find.text('P-101A'), findsOneWidget);
    expect(find.text('C-201'), findsOneWidget);
    expect(find.text('TK-301'), findsOneWidget);
  });

  testWidgets('DigitalTwinScreen filters nodes when status chip is selected', (tester) async {
    final api = FakeFacilitiesApi();
    await tester.pumpWidget(buildTestableScreen(api));
    await tester.pumpAndSettle();

    // Select "Critical" filter chip
    await tester.tap(find.widgetWithText(FilterChip, 'Critical'));
    await tester.pumpAndSettle();

    // TK-301 is Critical and should remain visible; P-101A (Healthy) should disappear
    expect(find.text('TK-301'), findsOneWidget);
    expect(find.text('P-101A'), findsNothing);
  });

  testWidgets('DigitalTwinScreen opens asset detail bottom sheet when spatial node is tapped', (tester) async {
    final api = FakeFacilitiesApi();
    await tester.pumpWidget(buildTestableScreen(api));
    await tester.pumpAndSettle();

    // Tap asset node P-101A
    await tester.tap(find.text('P-101A'));
    await tester.pumpAndSettle();

    // Bottom sheet details display
    expect(find.text('3D Spatial Coordinates'), findsOneWidget);
    expect(find.text('Main Crude Charge Pump'), findsOneWidget);
    expect(find.text('View Asset Details'), findsOneWidget);
  });
}
