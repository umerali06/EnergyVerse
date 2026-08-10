import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';

typedef ResolveQrCodeFn = Future<QrScanResult> Function(String code);
typedef CreateInspectionFn = Future<InspectionDetail> Function(
    CreateInspectionRequest request);

CurrentUser defaultQrTestIdentity(
    {List<String> permissions = const ['assets.read']}) {
  return CurrentUser(
    (builder) => builder
      ..uid = 'demo-acme-field_inspector'
      ..email = 'field_inspector@acme.example.invalid'
      ..companyId = 'acme-energy'
      ..companyName = 'Acme Energy'
      ..roleKey = 'field_inspector'
      ..emailVerified = true
      ..permissions.addAll(permissions),
  );
}

/// A minimal [ApiContract] double for QR-focused tests: every method is
/// unimplemented except [getCurrentUser] and [resolveQrCode], which callers
/// can inject.
class FakeQrApi implements ApiContract {
  FakeQrApi({
    required ResolveQrCodeFn resolveQrCode,
    CurrentUser? identity,
    CreateInspectionFn? createInspection,
  })  : _resolveQrCode = resolveQrCode,
        _identity = identity ?? defaultQrTestIdentity(),
        _createInspection = createInspection;

  final ResolveQrCodeFn _resolveQrCode;
  final CurrentUser _identity;
  final CreateInspectionFn? _createInspection;

  @override
  Future<QrScanResult> resolveQrCode(String code) => _resolveQrCode(code);

  @override
  Future<InspectionDetail> createInspection(CreateInspectionRequest request) {
    final handler = _createInspection;
    if (handler == null) throw UnimplementedError();
    return handler(request);
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
  Future<InspectionDetail> getInspection(String inspectionId) =>
      throw UnimplementedError();

  @override
  Future<CurrentUser> getCurrentUser() async => _identity;

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
  Future<DashboardActivitySeries> getDashboardActivitySeries(
          {int window = 30}) =>
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
  Future<AuditLogFacets> getAuditLogFacets(
          {DateTime? fromDate, DateTime? toDate}) =>
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
  Future<FacilityListPage> getFacilities({
    String? search,
    String? status,
    String sort = 'name',
    String? cursor,
    int limit = 25,
  }) =>
      throw UnimplementedError();

  @override
  Future<FacilityDetail> getFacility(String facilityId) =>
      throw UnimplementedError();

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
  Future<InspectionDetail> updateInspection(
    String inspectionId,
    UpdateInspectionRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> startInspection(String inspectionId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> completeInspection(
    String inspectionId,
    CompleteInspectionRequest request,
  ) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) =>
      throw UnimplementedError();

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
  Future<InspectionDetail> detachInspectionMedia(
          String inspectionId, String mediaId) =>
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
  Future<InspectionDetail> detachInspectionVoiceNote(
          String inspectionId, String voiceNoteId) =>
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
  Future<InspectionDetail> deleteInspectionAnnotation(
          String inspectionId, String annotationId) =>
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
