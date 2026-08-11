import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';

typedef GetWorkOrderFn = Future<WorkOrderDetail> Function(String id);
typedef GetWorkOrdersFn = Future<WorkOrderListPage> Function({
  String? assetId,
  String? facilityId,
  String? status,
  String? technicianId,
  String? cursor,
  int limit,
});
typedef AcceptWorkOrderFn = Future<WorkOrderDetail> Function(String id);
typedef SubmitWorkOrderForReviewFn = Future<WorkOrderDetail> Function(
  String id,
  SubmitWorkOrderForReviewRequest request,
);

/// A configurable [ApiContract] double for work-order repository/sync-engine
/// tests -- mirrors `FakeSyncApi`'s shape exactly. Only the four methods
/// `LocalWorkOrdersRepository`/`WorkOrderSyncEngine` actually call are
/// overridable via a constructor callback; every other method (including
/// assign/close/cancel/create/delete, which mobile never calls -- those are
/// supervisor actions taken from the admin app) throws unconditionally.
class FakeWorkOrderApi implements ApiContract {
  FakeWorkOrderApi({
    GetWorkOrderFn? getWorkOrder,
    GetWorkOrdersFn? getWorkOrders,
    AcceptWorkOrderFn? acceptWorkOrder,
    SubmitWorkOrderForReviewFn? submitWorkOrderForReview,
  })  : _getWorkOrder = getWorkOrder,
        _getWorkOrders = getWorkOrders,
        _acceptWorkOrder = acceptWorkOrder,
        _submitWorkOrderForReview = submitWorkOrderForReview;

  final GetWorkOrderFn? _getWorkOrder;
  final GetWorkOrdersFn? _getWorkOrders;
  final AcceptWorkOrderFn? _acceptWorkOrder;
  final SubmitWorkOrderForReviewFn? _submitWorkOrderForReview;

  final List<String> calls = [];

  @override
  Future<WorkOrderDetail> getWorkOrder(String workOrderId) {
    calls.add('getWorkOrder:$workOrderId');
    final handler = _getWorkOrder;
    if (handler == null) throw UnimplementedError();
    return handler(workOrderId);
  }

  @override
  Future<WorkOrderListPage> getWorkOrders({
    String? assetId,
    String? facilityId,
    String? status,
    String? technicianId,
    String? cursor,
    int limit = 25,
  }) {
    calls.add('getWorkOrders');
    final handler = _getWorkOrders;
    if (handler == null) throw UnimplementedError();
    return handler(
      assetId: assetId,
      facilityId: facilityId,
      status: status,
      technicianId: technicianId,
      cursor: cursor,
      limit: limit,
    );
  }

  @override
  Future<WorkOrderDetail> acceptWorkOrder(String workOrderId) {
    calls.add('acceptWorkOrder:$workOrderId');
    final handler = _acceptWorkOrder;
    if (handler == null) throw UnimplementedError();
    return handler(workOrderId);
  }

  @override
  Future<WorkOrderDetail> submitWorkOrderForReview(
    String workOrderId,
    SubmitWorkOrderForReviewRequest request,
  ) {
    calls.add('submitWorkOrderForReview:$workOrderId');
    final handler = _submitWorkOrderForReview;
    if (handler == null) throw UnimplementedError();
    return handler(workOrderId, request);
  }

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
  Future<WorkOrderDetail> closeWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDetail> cancelWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<WorkOrderDeleted> deleteWorkOrder(String workOrderId) =>
      throw UnimplementedError();

  @override
  Future<HealthResponse> getHealth() => throw UnimplementedError();

  @override
  Future<CurrentUser> getCurrentUser() => throw UnimplementedError();

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
  Future<AssetDashboardSummary> getDashboardAssetsSummary() =>
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
  Future<AssetHistoryPage> getAssetHistory(String assetId) =>
      throw UnimplementedError();

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
  Future<InspectionDetail> getInspection(String inspectionId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> createInspection(CreateInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> updateInspection(
          String inspectionId, UpdateInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> startInspection(String inspectionId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> completeInspection(
          String inspectionId, CompleteInspectionRequest request) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) =>
      throw UnimplementedError();

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
