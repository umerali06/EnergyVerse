import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const session = AuthSession(
  uid: 'demo-acme-maintenance_technician',
  email: 'maintenance_technician@acme.example.invalid',
  emailVerified: true,
);

CurrentUser identityFor(String roleKey, List<String> permissions) => CurrentUser(
      (builder) => builder
        ..uid = 'demo-acme-maintenance_technician'
        ..email = 'maintenance_technician@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = roleKey
        ..emailVerified = true
        ..permissions.addAll(permissions),
    );

WorkOrderListItem _itemFixture({
  String id = 'wo-1',
  String title = 'Replace worn gasket',
  WorkOrderListItemStatusEnum status = WorkOrderListItemStatusEnum.assigned,
  String? technicianId = 'demo-acme-maintenance_technician',
}) {
  final now = DateTime.utc(2026, 1, 1);
  return WorkOrderListItem(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..title = title
      ..priority = WorkOrderListItemPriorityEnum.medium
      ..status = status
      ..technicianId = technicianId
      ..revision = 1
      ..createdAt = now
      ..updatedAt = now,
  );
}

WorkOrderListPage _pageFixture({List<WorkOrderListItem>? items}) =>
    WorkOrderListPage((b) => b..items.addAll(items ?? [_itemFixture()]));

WorkOrderDetail _detailFixtureFromItem(WorkOrderListItem item) {
  final now = DateTime.utc(2026, 1, 1);
  return WorkOrderDetail(
    (b) => b
      ..id = item.id
      ..assetId = item.assetId
      ..facilityId = item.facilityId
      ..title = item.title
      ..priority = WorkOrderDetailPriorityEnum.valueOf(item.priority.name)
      ..status = WorkOrderDetailStatusEnum.valueOf(item.status.name)
      ..technicianId = item.technicianId
      ..revision = item.revision
      ..createdAt = now
      ..createdBy = 'supervisor-1'
      ..updatedAt = now,
  );
}

typedef GetWorkOrdersFn = Future<WorkOrderListPage> Function({
  String? assetId,
  String? facilityId,
  String? status,
  String? technicianId,
  String? cursor,
  int limit,
});

/// `refreshFromNetwork` (`LocalWorkOrdersRepository`) fetches the list, then
/// fetches each item's full detail -- so a widget test rendering the list
/// needs both `getWorkOrders` AND `getWorkOrder` fixtures to actually reach
/// the local cache the screen renders from.
class FakeApi implements ApiContract {
  FakeApi(this.identity, {GetWorkOrdersFn? getWorkOrders})
      : _getWorkOrders = getWorkOrders ??
            (({assetId, facilityId, status, technicianId, cursor, limit = 25}) async =>
                _pageFixture());

  final CurrentUser identity;
  final GetWorkOrdersFn _getWorkOrders;
  final Map<String, WorkOrderListItem> _lastListedItems = {};

  @override
  Future<CurrentUser> getCurrentUser() async => identity;

  @override
  Future<WorkOrderListPage> getWorkOrders({
    String? assetId,
    String? facilityId,
    String? status,
    String? technicianId,
    String? cursor,
    int limit = 25,
  }) async {
    final page = await _getWorkOrders(
      assetId: assetId,
      facilityId: facilityId,
      status: status,
      technicianId: technicianId,
      cursor: cursor,
      limit: limit,
    );
    for (final item in page.items) {
      _lastListedItems[item.id] = item;
    }
    return page;
  }

  @override
  Future<WorkOrderDetail> getWorkOrder(String workOrderId) async {
    final item = _lastListedItems[workOrderId];
    if (item == null) throw UnimplementedError();
    return _detailFixtureFromItem(item);
  }

  @override
  Future<WorkOrderDetail> createWorkOrder(CreateWorkOrderRequest request) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> assignWorkOrder(
          String workOrderId, AssignWorkOrderRequest request) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> acceptWorkOrder(String workOrderId) => throw UnimplementedError();

  @override
  Future<WorkOrderDetail> submitWorkOrderForReview(
          String workOrderId, SubmitWorkOrderForReviewRequest request) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> closeWorkOrder(String workOrderId) => throw UnimplementedError();

  @override
  Future<WorkOrderDetail> cancelWorkOrder(String workOrderId) => throw UnimplementedError();

  @override
  Future<WorkOrderDeleted> deleteWorkOrder(String workOrderId) => throw UnimplementedError();

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
  Future<DashboardSummary> getDashboardSummary({int window = 30}) => throw UnimplementedError();

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
  Future<AssetDashboardSummary> getDashboardAssetsSummary() => throw UnimplementedError();

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
      throw UnimplementedError();

  @override
  Future<AssetDetail> getAsset(String assetId) => throw UnimplementedError();

  @override
  Future<AssetHistoryPage> getAssetHistory(String assetId) => throw UnimplementedError();

  @override
  Future<QrScanResult> resolveQrCode(String code) => throw UnimplementedError();

  @override
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

  @override
  Future<FacilityDetail> getFacility(String facilityId) => throw UnimplementedError();

  @override
  Future<AreaListPage> getAreas({
    String? facilityId,
    String? search,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

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
  }) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> getInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspection(CreateInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspection(
          String inspectionId, UpdateInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> startInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> completeInspection(
          String inspectionId, CompleteInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> assignChecklistTemplate(
          String inspectionId, AssignChecklistTemplateRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> attachInspectionMedia(
          String inspectionId, AttachInspectionMediaRequest request) =>
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
          String inspectionId, AttachVoiceNoteRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionVoiceNote(
    String inspectionId,
    String voiceNoteId,
    UpdateVoiceNoteRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> detachInspectionVoiceNote(
          String inspectionId, String voiceNoteId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspectionAnnotation(
          String inspectionId, CreateAnnotationRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspectionAnnotation(
    String inspectionId,
    String annotationId,
    UpdateAnnotationRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> deleteInspectionAnnotation(
          String inspectionId, String annotationId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspectionArMeasurement(
          String inspectionId, CreateArMeasurementRequest request) =>
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
    String inspectionId,
    String measurementId,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> analyzeInspectionMedia(String inspectionId, String mediaId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> reviewInspectionAiAnalysis(
          String inspectionId, String analysisId) =>
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

Future<void> pumpWorkOrders(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(
      api: api,
      authGateway: FakeGateway(),
      initialRoute: AppRoutes.workOrders,
      database: AppDatabase(NativeDatabase.memory()),
    ),
  );
  await tester.pump();
}

/// See `inspections_screen_test.dart`'s identical helper doc comment for why
/// this must run inline as the last step of a test that pumps [FevApp].
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  testWidgets('shows loading then renders the real assigned work order', (tester) async {
    final api = FakeApi(
      identityFor('maintenance_technician', const ['work_orders.read', 'work_orders.write']),
    );
    await pumpWorkOrders(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Replace worn gasket'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('shows an honest empty state when no work orders match', (tester) async {
    final api = FakeApi(
      identityFor('maintenance_technician', const ['work_orders.read', 'work_orders.write']),
      getWorkOrders: ({assetId, facilityId, status, technicianId, cursor, limit = 25}) async =>
          _pageFixture(items: const []),
    );
    await pumpWorkOrders(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('No work orders found'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('shows the branded 403 for a role without work_orders.read', (tester) async {
    final api = FakeApi(identityFor('executive', const ['reports.read']));
    await pumpWorkOrders(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.textContaining('work_orders.read'), findsWidgets);
    await disposeApp(tester);
  });

  testWidgets('toggling "assigned to me only" off re-fetches without a technician filter',
      (tester) async {
    final requestedTechnicianIds = <String?>[];
    final api = FakeApi(
      identityFor('maintenance_technician', const ['work_orders.read', 'work_orders.write']),
      getWorkOrders: ({assetId, facilityId, status, technicianId, cursor, limit = 25}) async {
        requestedTechnicianIds.add(technicianId);
        return _pageFixture();
      },
    );
    await pumpWorkOrders(tester, api: api);
    await tester.pumpAndSettle();

    expect(requestedTechnicianIds, contains('demo-acme-maintenance_technician'));

    await tester.tap(find.byKey(const Key('work-orders-mine-only')));
    await tester.pumpAndSettle();

    expect(requestedTechnicianIds.last, isNull);
    await disposeApp(tester);
  });
}
