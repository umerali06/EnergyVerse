import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';

typedef GetInspectionFn = Future<InspectionDetail> Function(String id);
typedef CreateInspectionFn = Future<InspectionDetail> Function(CreateInspectionRequest request);
typedef UpdateInspectionFn = Future<InspectionDetail> Function(
  String id,
  UpdateInspectionRequest request,
);
typedef LifecycleFn = Future<InspectionDetail> Function(String id);
typedef AssignTemplateFn = Future<InspectionDetail> Function(
  String id,
  AssignChecklistTemplateRequest request,
);
typedef GetChecklistTemplatesFn = Future<ChecklistTemplateListPage> Function({
  String? category,
  String? cursor,
  int limit,
});
typedef GetChecklistTemplateFn = Future<ChecklistTemplateDetail> Function(String templateId);

/// A configurable [ApiContract] double for repository/sync-engine tests --
/// every inspections-write method is overridable via a constructor
/// callback (defaulting to `throw UnimplementedError()`), and every
/// unrelated method throws unconditionally since none of these tests touch
/// dashboard/users/roles/etc.
class FakeSyncApi implements ApiContract {
  FakeSyncApi({
    GetInspectionFn? getInspection,
    CreateInspectionFn? createInspection,
    UpdateInspectionFn? updateInspection,
    LifecycleFn? startInspection,
    LifecycleFn? completeInspection,
    LifecycleFn? cancelInspection,
    AssignTemplateFn? assignChecklistTemplate,
    GetChecklistTemplatesFn? getChecklistTemplates,
    GetChecklistTemplateFn? getChecklistTemplate,
  })  : _getInspection = getInspection,
        _createInspection = createInspection,
        _updateInspection = updateInspection,
        _startInspection = startInspection,
        _completeInspection = completeInspection,
        _cancelInspection = cancelInspection,
        _assignChecklistTemplate = assignChecklistTemplate,
        _getChecklistTemplates = getChecklistTemplates,
        _getChecklistTemplate = getChecklistTemplate;

  final GetInspectionFn? _getInspection;
  final CreateInspectionFn? _createInspection;
  final UpdateInspectionFn? _updateInspection;
  final LifecycleFn? _startInspection;
  final LifecycleFn? _completeInspection;
  final LifecycleFn? _cancelInspection;
  final AssignTemplateFn? _assignChecklistTemplate;
  final GetChecklistTemplatesFn? _getChecklistTemplates;
  final GetChecklistTemplateFn? _getChecklistTemplate;

  final List<String> calls = [];

  @override
  Future<InspectionDetail> getInspection(String inspectionId) {
    calls.add('getInspection:$inspectionId');
    final handler = _getInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId);
  }

  @override
  Future<InspectionDetail> createInspection(CreateInspectionRequest request) {
    calls.add('createInspection:${request.id}');
    final handler = _createInspection;
    if (handler == null) throw UnimplementedError();
    return handler(request);
  }

  @override
  Future<InspectionDetail> updateInspection(String inspectionId, UpdateInspectionRequest request) {
    calls.add('updateInspection:$inspectionId');
    final handler = _updateInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
  }

  @override
  Future<InspectionDetail> startInspection(String inspectionId) {
    calls.add('startInspection:$inspectionId');
    final handler = _startInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId);
  }

  @override
  Future<InspectionDetail> completeInspection(String inspectionId) {
    calls.add('completeInspection:$inspectionId');
    final handler = _completeInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId);
  }

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) {
    calls.add('cancelInspection:$inspectionId');
    final handler = _cancelInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId);
  }

  @override
  Future<InspectionDetail> assignChecklistTemplate(
    String inspectionId,
    AssignChecklistTemplateRequest request,
  ) {
    calls.add('assignChecklistTemplate:$inspectionId');
    final handler = _assignChecklistTemplate;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
  }

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
  Future<ChecklistTemplateListPage> getChecklistTemplates({
    String? category,
    String? cursor,
    int limit = 25,
  }) {
    final handler = _getChecklistTemplates;
    if (handler == null) throw UnimplementedError();
    return handler(category: category, cursor: cursor, limit: limit);
  }

  @override
  Future<ChecklistTemplateDetail> getChecklistTemplate(String templateId) {
    final handler = _getChecklistTemplate;
    if (handler == null) throw UnimplementedError();
    return handler(templateId);
  }
}
