import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';

typedef GetInspectionFn = Future<InspectionDetail> Function(String id);
typedef CreateInspectionFn = Future<InspectionDetail> Function(CreateInspectionRequest request);
typedef UpdateInspectionFn = Future<InspectionDetail> Function(
  String id,
  UpdateInspectionRequest request,
);
typedef LifecycleFn = Future<InspectionDetail> Function(String id);
typedef CompleteInspectionFn = Future<InspectionDetail> Function(
  String id,
  CompleteInspectionRequest request,
);
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
typedef AttachMediaFn = Future<InspectionDetail> Function(
  String inspectionId,
  AttachInspectionMediaRequest request,
);
typedef UpdateMediaFn = Future<InspectionDetail> Function(
  String inspectionId,
  String mediaId,
  UpdateInspectionMediaRequest request,
);
typedef DetachMediaFn = Future<InspectionDetail> Function(String inspectionId, String mediaId);
typedef AttachVoiceNoteFn = Future<InspectionDetail> Function(
  String inspectionId,
  AttachVoiceNoteRequest request,
);
typedef UpdateVoiceNoteFn = Future<InspectionDetail> Function(
  String inspectionId,
  String voiceNoteId,
  UpdateVoiceNoteRequest request,
);
typedef DetachVoiceNoteFn = Future<InspectionDetail> Function(
  String inspectionId,
  String voiceNoteId,
);
typedef CreateAnnotationFn = Future<InspectionDetail> Function(
  String inspectionId,
  CreateAnnotationRequest request,
);
typedef UpdateAnnotationFn = Future<InspectionDetail> Function(
  String inspectionId,
  String annotationId,
  UpdateAnnotationRequest request,
);
typedef DeleteAnnotationFn = Future<InspectionDetail> Function(
  String inspectionId,
  String annotationId,
);

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
    CompleteInspectionFn? completeInspection,
    LifecycleFn? cancelInspection,
    AssignTemplateFn? assignChecklistTemplate,
    GetChecklistTemplatesFn? getChecklistTemplates,
    GetChecklistTemplateFn? getChecklistTemplate,
    AttachMediaFn? attachInspectionMedia,
    UpdateMediaFn? updateInspectionMedia,
    DetachMediaFn? detachInspectionMedia,
    AttachVoiceNoteFn? attachInspectionVoiceNote,
    UpdateVoiceNoteFn? updateInspectionVoiceNote,
    DetachVoiceNoteFn? detachInspectionVoiceNote,
    CreateAnnotationFn? createInspectionAnnotation,
    UpdateAnnotationFn? updateInspectionAnnotation,
    DeleteAnnotationFn? deleteInspectionAnnotation,
  })  : _getInspection = getInspection,
        _createInspection = createInspection,
        _updateInspection = updateInspection,
        _startInspection = startInspection,
        _completeInspection = completeInspection,
        _cancelInspection = cancelInspection,
        _assignChecklistTemplate = assignChecklistTemplate,
        _getChecklistTemplates = getChecklistTemplates,
        _getChecklistTemplate = getChecklistTemplate,
        _attachInspectionMedia = attachInspectionMedia,
        _updateInspectionMedia = updateInspectionMedia,
        _detachInspectionMedia = detachInspectionMedia,
        _attachInspectionVoiceNote = attachInspectionVoiceNote,
        _updateInspectionVoiceNote = updateInspectionVoiceNote,
        _detachInspectionVoiceNote = detachInspectionVoiceNote,
        _createInspectionAnnotation = createInspectionAnnotation,
        _updateInspectionAnnotation = updateInspectionAnnotation,
        _deleteInspectionAnnotation = deleteInspectionAnnotation;

  final GetInspectionFn? _getInspection;
  final CreateInspectionFn? _createInspection;
  final UpdateInspectionFn? _updateInspection;
  final LifecycleFn? _startInspection;
  final CompleteInspectionFn? _completeInspection;
  final LifecycleFn? _cancelInspection;
  final AssignTemplateFn? _assignChecklistTemplate;
  final GetChecklistTemplatesFn? _getChecklistTemplates;
  final GetChecklistTemplateFn? _getChecklistTemplate;
  final AttachMediaFn? _attachInspectionMedia;
  final UpdateMediaFn? _updateInspectionMedia;
  final DetachMediaFn? _detachInspectionMedia;
  final AttachVoiceNoteFn? _attachInspectionVoiceNote;
  final UpdateVoiceNoteFn? _updateInspectionVoiceNote;
  final DetachVoiceNoteFn? _detachInspectionVoiceNote;
  final CreateAnnotationFn? _createInspectionAnnotation;
  final UpdateAnnotationFn? _updateInspectionAnnotation;
  final DeleteAnnotationFn? _deleteInspectionAnnotation;

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
  Future<InspectionDetail> completeInspection(
    String inspectionId,
    CompleteInspectionRequest request,
  ) {
    calls.add('completeInspection:$inspectionId');
    final handler = _completeInspection;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
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
  Future<InspectionDetail> attachInspectionMedia(
    String inspectionId,
    AttachInspectionMediaRequest request,
  ) {
    calls.add('attachInspectionMedia:$inspectionId');
    final handler = _attachInspectionMedia;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
  }

  @override
  Future<InspectionDetail> updateInspectionMedia(
    String inspectionId,
    String mediaId,
    UpdateInspectionMediaRequest request,
  ) {
    calls.add('updateInspectionMedia:$inspectionId:$mediaId');
    final handler = _updateInspectionMedia;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, mediaId, request);
  }

  @override
  Future<InspectionDetail> detachInspectionMedia(String inspectionId, String mediaId) {
    calls.add('detachInspectionMedia:$inspectionId:$mediaId');
    final handler = _detachInspectionMedia;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, mediaId);
  }

  @override
  Future<InspectionDetail> attachInspectionVoiceNote(
    String inspectionId,
    AttachVoiceNoteRequest request,
  ) {
    calls.add('attachInspectionVoiceNote:$inspectionId');
    final handler = _attachInspectionVoiceNote;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
  }

  @override
  Future<InspectionDetail> updateInspectionVoiceNote(
    String inspectionId,
    String voiceNoteId,
    UpdateVoiceNoteRequest request,
  ) {
    calls.add('updateInspectionVoiceNote:$inspectionId:$voiceNoteId');
    final handler = _updateInspectionVoiceNote;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, voiceNoteId, request);
  }

  @override
  Future<InspectionDetail> detachInspectionVoiceNote(String inspectionId, String voiceNoteId) {
    calls.add('detachInspectionVoiceNote:$inspectionId:$voiceNoteId');
    final handler = _detachInspectionVoiceNote;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, voiceNoteId);
  }

  @override
  Future<InspectionDetail> createInspectionAnnotation(
    String inspectionId,
    CreateAnnotationRequest request,
  ) {
    calls.add('createInspectionAnnotation:$inspectionId');
    final handler = _createInspectionAnnotation;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, request);
  }

  @override
  Future<InspectionDetail> updateInspectionAnnotation(
    String inspectionId,
    String annotationId,
    UpdateAnnotationRequest request,
  ) {
    calls.add('updateInspectionAnnotation:$inspectionId:$annotationId');
    final handler = _updateInspectionAnnotation;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, annotationId, request);
  }

  @override
  Future<InspectionDetail> deleteInspectionAnnotation(String inspectionId, String annotationId) {
    calls.add('deleteInspectionAnnotation:$inspectionId:$annotationId');
    final handler = _deleteInspectionAnnotation;
    if (handler == null) throw UnimplementedError();
    return handler(inspectionId, annotationId);
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
