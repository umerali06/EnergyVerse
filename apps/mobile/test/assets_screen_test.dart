import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/assets_fixtures.dart';
import 'support/dashboard_fixtures.dart';

const session = AuthSession(
  uid: 'demo-acme-company_admin',
  email: 'company_admin@acme.example.invalid',
  emailVerified: true,
);

const roleMatrix = <String, List<String>>{
  'company_admin': ['assets.read', 'facilities.read', 'areas.read'],
  'field_inspector': ['reports.read'],
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

typedef GetAssetsFn = Future<AssetListPage> Function({
  String? facilityId,
  String? areaId,
  String? category,
  String? currentStatus,
  String? parentAssetId,
  String? search,
  String sort,
  String? cursor,
  int limit,
});
typedef GetAssetFn = Future<AssetDetail> Function(String assetId);
typedef GetAssetHistoryFn = Future<AssetHistoryPage> Function(String assetId);

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    GetAssetsFn? getAssets,
    GetAssetFn? getAsset,
    GetAssetHistoryFn? getAssetHistory,
  })  : _getAssets = getAssets ??
            (({
              String? facilityId,
              String? areaId,
              String? category,
              String? currentStatus,
              String? parentAssetId,
              String? search,
              String sort = '-created_at',
              String? cursor,
              int limit = 25,
            }) async =>
                parentAssetId != null ? assetListPageFixture(items: const []) : assetListPageFixture()),
        _getAsset = getAsset ?? ((assetId) async => assetDetailFixture(id: assetId)),
        _getAssetHistory = getAssetHistory ?? ((assetId) async => assetHistoryPageFixture());

  final CurrentUser identity;
  final GetAssetsFn _getAssets;
  final GetAssetFn _getAsset;
  final GetAssetHistoryFn _getAssetHistory;

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
  Future<AssetDashboardSummary> getDashboardAssetsSummary() async => assetDashboardSummaryFixture();

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

  @override
  Future<AssetListPage> getAssets({
    String? facilityId,
    String? areaId,
    String? category,
    String? currentStatus,
    String? parentAssetId,
    String? search,
    String sort = '-created_at',
    String? cursor,
    int limit = 25,
  }) =>
      _getAssets(
        facilityId: facilityId,
        areaId: areaId,
        category: category,
        currentStatus: currentStatus,
        parentAssetId: parentAssetId,
        search: search,
        sort: sort,
        cursor: cursor,
        limit: limit,
      );

  @override
  Future<AssetDetail> getAsset(String assetId) => _getAsset(assetId);

  @override
  Future<AssetHistoryPage> getAssetHistory(String assetId) => _getAssetHistory(assetId);

  @override
  Future<QrScanResult> resolveQrCode(String code) => throw UnimplementedError();

  @override
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async =>
      facilityListPageFixture();

  @override
  Future<FacilityDetail> getFacility(String facilityId) => throw UnimplementedError();

  @override
  Future<AreaListPage> getAreas({
    String? facilityId,
    String? search,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) async =>
      areaListPageFixture();

  @override
  Future<AreaDetail> getArea(String areaId) => throw UnimplementedError();

  @override
  Future<InspectionListPage> getInspections({
    String? assetId,
    String? facilityId,
    String? status,
    String? inspectorId,
    String? cursor,
    int limit = 25,
  }) async =>
      InspectionListPage((b) => b);

  @override
  Future<InspectionDetail> getInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspection(CreateInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspection(
    String inspectionId,
    UpdateInspectionRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> startInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> completeInspection(
    String inspectionId,
    CompleteInspectionRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> assignChecklistTemplate(
    String inspectionId,
    AssignChecklistTemplateRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> attachInspectionMedia(
    String inspectionId,
    AttachInspectionMediaRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionMedia(
    String inspectionId,
    String mediaId,
    UpdateInspectionMediaRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> detachInspectionMedia(String inspectionId, String mediaId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> attachInspectionVoiceNote(
    String inspectionId,
    AttachVoiceNoteRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionVoiceNote(
    String inspectionId,
    String voiceNoteId,
    UpdateVoiceNoteRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> detachInspectionVoiceNote(String inspectionId, String voiceNoteId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspectionAnnotation(
    String inspectionId,
    CreateAnnotationRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionAnnotation(
    String inspectionId,
    String annotationId,
    UpdateAnnotationRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> deleteInspectionAnnotation(String inspectionId, String annotationId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspectionArMeasurement(
    String inspectionId,
    CreateArMeasurementRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionArMeasurement(
    String inspectionId,
    String measurementId,
    UpdateArMeasurementRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> deleteInspectionArMeasurement(
          String inspectionId, String measurementId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> analyzeInspectionMedia(String inspectionId, String mediaId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> reviewInspectionAiAnalysis(String inspectionId, String analysisId) =>
      throw UnimplementedError();

  @override
  Future<ChecklistTemplateListPage> getChecklistTemplates({
    String? category,
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

  @override
  Future<ChecklistTemplateDetail> getChecklistTemplate(String templateId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderListPage> getWorkOrders({
    String? assetId,
    String? facilityId,
    String? status,
    String? technicianId,
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> getWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> createWorkOrder(CreateWorkOrderRequest request) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> assignWorkOrder(
    String workOrderId,
    AssignWorkOrderRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> acceptWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> submitWorkOrderForReview(
    String workOrderId,
    SubmitWorkOrderForReviewRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> closeWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> cancelWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDeleted> deleteWorkOrder(String workOrderId) =>
      throw UnimplementedError();
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

Future<void> pumpAssets(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.assets, database: AppDatabase(NativeDatabase.memory())),
  );
  await tester.pump();
}

Future<void> scrollTo(
  WidgetTester tester,
  Finder finder, {
  int maxDrags = 12,
  Key listKey = const Key('assets-scroll'),
}) async {
  final list = find.byKey(listKey);
  for (var i = 0; i < maxDrags; i++) {
    if (finder.evaluate().isNotEmpty) return;
    await tester.drag(list, const Offset(0, -300));
    await tester.pumpAndSettle();
  }
  expect(finder.evaluate(), isNotEmpty, reason: 'target not found after $maxDrags scroll steps');
}

void main() {
  testWidgets('shows loading then renders the real tenant assets', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpAssets(tester, api: api);
    await tester.pump();

    expect(find.byType(Card), findsWidgets);
    await tester.pumpAndSettle();

    expect(find.text('Feed Pump'), findsOneWidget);
    expect(find.text('PMP-001'), findsOneWidget);
  });

  testWidgets('shows an honest empty state when no assets match', (tester) async {
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAssets: ({
        String? facilityId,
        String? areaId,
        String? category,
        String? currentStatus,
        String? parentAssetId,
        String? search,
        String sort = '-created_at',
        String? cursor,
        int limit = 25,
      }) async =>
          assetListPageFixture(items: const []),
    );
    await pumpAssets(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('No assets found'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the list request fails', (tester) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAssets: ({
        String? facilityId,
        String? areaId,
        String? category,
        String? currentStatus,
        String? parentAssetId,
        String? search,
        String sort = '-created_at',
        String? cursor,
        int limit = 25,
      }) async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpAssets(tester, api: api);
    await tester.pumpAndSettle();

    final retry = find.text('Retry');
    expect(retry, findsOneWidget);
    expect(attempts, 1);
    await tester.ensureVisible(retry);
    await tester.pumpAndSettle();
    await tester.tap(retry, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('loads more assets via cursor pagination and appends without duplicating', (
    tester,
  ) async {
    var calls = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getAssets: ({
        String? facilityId,
        String? areaId,
        String? category,
        String? currentStatus,
        String? parentAssetId,
        String? search,
        String sort = '-created_at',
        String? cursor,
        int limit = 25,
      }) async {
        if (parentAssetId != null) return assetListPageFixture(items: const []);
        calls += 1;
        if (cursor == null) {
          return assetListPageFixture(
            items: [assetListItemFixture(id: 'a1')],
            nextCursor: 'cursor-1',
          );
        }
        expect(cursor, 'cursor-1');
        return assetListPageFixture(
          items: [assetListItemFixture(id: 'a2', assetTag: 'PMP-002', name: 'Second Pump')],
        );
      },
    );
    await pumpAssets(tester, api: api);
    await tester.pumpAndSettle();

    final loadMore = find.byKey(const Key('load-more-assets'));
    await scrollTo(tester, loadMore);
    await tester.tap(loadMore);
    await tester.pumpAndSettle();

    expect(find.text('Second Pump'), findsOneWidget);
    expect(find.byKey(const Key('load-more-assets')), findsNothing);
    expect(calls, 2);
  });

  testWidgets('opens the asset detail route with overview and reserved-tab empty states', (
    tester,
  ) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpAssets(tester, api: api);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Feed Pump'));
    await tester.pumpAndSettle();

    expect(find.text('Acme Co'), findsOneWidget);
    final noSubAssets = find.text('No sub-assets.');
    await scrollTo(tester, noSubAssets, listKey: const Key('asset-overview-scroll'));
    expect(noSubAssets, findsOneWidget);

    await tester.tap(find.text('Inspections'));
    await tester.pumpAndSettle();
    expect(find.text('No inspections yet'), findsOneWidget);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('No history has been recorded for this asset yet.'), findsOneWidget);
  });

  testWidgets('hides Assets for a role without assets.read at the route level', (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpAssets(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    expect(find.text('Feed Pump'), findsNothing);
  });

  testWidgets(
    'arrives pre-filtered when navigated to with a status argument (dashboard KPI deep link)',
    (tester) async {
      String? capturedStatus;
      final api = FakeApi(
        identityFor('company_admin', roleMatrix['company_admin']!),
        getAssets: ({
          String? facilityId,
          String? areaId,
          String? category,
          String? currentStatus,
          String? parentAssetId,
          String? search,
          String sort = '-created_at',
          String? cursor,
          int limit = 25,
        }) async {
          capturedStatus = currentStatus;
          return assetListPageFixture();
        },
      );
      await pumpAssets(tester, api: api);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(Scaffold).first);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.assets, (_) => false, arguments: 'Critical');
      await tester.pumpAndSettle();

      expect(capturedStatus, 'Critical');
      expect(find.text('Critical'), findsWidgets);
    },
  );
}
