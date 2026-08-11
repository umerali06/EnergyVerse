import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const session = AuthSession(
  uid: 'demo-acme-maintenance_technician',
  email: 'maintenance_technician@acme.example.invalid',
  emailVerified: true,
);

CurrentUser _identity() => CurrentUser(
      (builder) => builder
        ..uid = 'demo-acme-maintenance_technician'
        ..email = 'maintenance_technician@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = 'maintenance_technician'
        ..emailVerified = true
        ..permissions.addAll(const ['work_orders.read', 'work_orders.write']),
    );

WorkOrderDetail _detailFixture({
  String status = 'assigned',
  String? technicianId = 'demo-acme-maintenance_technician',
}) {
  final now = DateTime.utc(2026, 1, 1);
  return WorkOrderDetail(
    (b) => b
      ..id = 'wo-1'
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..title = 'Replace worn gasket'
      ..priority = WorkOrderDetailPriorityEnum.medium
      ..status = WorkOrderDetailStatusEnum.values.firstWhere((s) => s.name == status)
      ..technicianId = technicianId
      ..revision = 1
      ..createdAt = now
      ..createdBy = 'supervisor-1'
      ..updatedAt = now,
  );
}

typedef GetWorkOrderFn = Future<WorkOrderDetail> Function(String id);
typedef AcceptWorkOrderFn = Future<WorkOrderDetail> Function(String id);
typedef SubmitForReviewFn = Future<WorkOrderDetail> Function(
  String id,
  SubmitWorkOrderForReviewRequest request,
);

class FakeApi implements ApiContract {
  FakeApi({
    GetWorkOrderFn? getWorkOrder,
    AcceptWorkOrderFn? acceptWorkOrder,
    SubmitForReviewFn? submitWorkOrderForReview,
  })  : _getWorkOrder = getWorkOrder ?? ((id) async => _detailFixture()),
        _acceptWorkOrder = acceptWorkOrder,
        _submitWorkOrderForReview = submitWorkOrderForReview;

  final GetWorkOrderFn _getWorkOrder;
  final AcceptWorkOrderFn? _acceptWorkOrder;
  final SubmitForReviewFn? _submitWorkOrderForReview;
  final List<String> calls = [];

  @override
  Future<CurrentUser> getCurrentUser() async => _identity();

  @override
  Future<WorkOrderListPage> getWorkOrders({
    String? assetId,
    String? facilityId,
    String? status,
    String? technicianId,
    String? cursor,
    int limit = 25,
  }) async =>
      WorkOrderListPage((b) => b..items.addAll(const []));

  @override
  Future<WorkOrderDetail> getWorkOrder(String workOrderId) {
    calls.add('getWorkOrder');
    return _getWorkOrder(workOrderId);
  }

  @override
  Future<WorkOrderDetail> acceptWorkOrder(String workOrderId) {
    calls.add('acceptWorkOrder');
    final handler = _acceptWorkOrder;
    if (handler == null) throw UnimplementedError();
    return handler(workOrderId);
  }

  @override
  Future<WorkOrderDetail> submitWorkOrderForReview(
    String workOrderId,
    SubmitWorkOrderForReviewRequest request,
  ) {
    calls.add('submitWorkOrderForReview');
    final handler = _submitWorkOrderForReview;
    if (handler == null) throw UnimplementedError();
    return handler(workOrderId, request);
  }

  @override
  Future<WorkOrderDetail> createWorkOrder(CreateWorkOrderRequest request) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> assignWorkOrder(
          String workOrderId, AssignWorkOrderRequest request) =>
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

Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  testWidgets('shows Accept task for the assigned technician when status is assigned',
      (tester) async {
    final api = FakeApi(getWorkOrder: (id) async => _detailFixture(status: 'assigned'));
    await tester.pumpWidget(
      FevApp(
        api: api,
        authGateway: FakeGateway(),
        database: AppDatabase(NativeDatabase.memory()),
      ),
    );
    await tester.pump();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoutes.workOrderDetail, arguments: 'wo-1');
    await tester.pumpAndSettle();

    expect(find.text('Accept task'), findsOneWidget);
    expect(find.text('Submit for review'), findsNothing);
    await disposeApp(tester);
  });

  // Accept/submit-for-review dispatch to the API asynchronously through
  // WorkOrderSyncEngine's background outbox drain (see D-066's offline-first
  // choice) -- not synchronously on tap. That drain path (dispatch, revision
  // conflicts, already-applied detection) is exhaustively covered against a
  // real engine in `test/sync/work_order_sync_engine_test.dart`; these
  // widget tests instead verify the LOCAL optimistic write the tap produces
  // immediately, which is what drives the reactive UI regardless of whether
  // the engine has drained yet -- mirrors `inspection_detail_screen_test.dart`'s
  // same posture for its own start/complete buttons.
  testWidgets('accepting optimistically flips the local status to in_progress', (tester) async {
    final api = FakeApi(getWorkOrder: (id) async => _detailFixture(status: 'assigned'));
    await tester.pumpWidget(
      FevApp(
        api: api,
        authGateway: FakeGateway(),
        database: AppDatabase(NativeDatabase.memory()),
      ),
    );
    await tester.pump();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoutes.workOrderDetail, arguments: 'wo-1');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Accept task'));
    await tester.pumpAndSettle();

    expect(find.text('Accept task'), findsNothing);
    expect(find.text('Submit for review'), findsOneWidget);
    // StatusPill renders its label upper-cased.
    expect(find.text('IN PROGRESS'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets(
      'submitting for review fills the sheet and optimistically moves to pending review',
      (tester) async {
    final api = FakeApi(getWorkOrder: (id) async => _detailFixture(status: 'inProgress'));
    await tester.pumpWidget(
      FevApp(
        api: api,
        authGateway: FakeGateway(),
        database: AppDatabase(NativeDatabase.memory()),
      ),
    );
    await tester.pump();
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pushNamed(AppRoutes.workOrderDetail, arguments: 'wo-1');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Submit for review'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextField, 'Completion notes'),
      'Replaced the gasket and tested for leaks.',
    );
    await tester.tap(find.text('Submit for review').last);
    await tester.pumpAndSettle();

    expect(find.text('PENDING REVIEW'), findsOneWidget);
    expect(
      find.text('Replaced the gasket and tested for leaks.'),
      findsOneWidget,
    );
    await disposeApp(tester);
  });
}
