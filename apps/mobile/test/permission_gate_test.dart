import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _IdentityApi implements ApiContract {
  _IdentityApi(this.permissionKeys);

  final Iterable<String> permissionKeys;
  int requests = 0;

  @override
  Future<CurrentUser> getCurrentUser() async {
    requests += 1;
    return CurrentUser(
      (builder) => builder
        ..uid = 'test-uid'
        ..email = 'test@example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = 'custom'
        ..emailVerified = true
        ..permissions.addAll(permissionKeys),
    );
  }

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

void main() {
  test('can, hasAny, and hasAll evaluate a sample permission set', () {
    final access = PermissionAccess(const [
      'assets.read',
      'assets.write',
      'reports.read',
    ]);

    expect(access.can('assets.write'), isTrue);
    expect(access.can('users.manage'), isFalse);
    expect(access.hasAny(const ['users.manage', 'reports.read']), isTrue);
    expect(access.hasAny(const ['users.manage', 'roles.manage']), isFalse);
    expect(access.hasAll(const ['assets.read', 'assets.write']), isTrue);
    expect(access.hasAll(const ['assets.read', 'users.manage']), isFalse);
  });

  test(
    'loads permissions once through the generated-client API service seam',
    () async {
      final api = _IdentityApi(const ['assets.read', 'assets.write']);
      final controller = PermissionController(api: api);

      await controller.loadFromMe();

      expect(api.requests, 1);
      expect(controller.status, PermissionStatus.ready);
      expect(controller.can('assets.write'), isTrue);
      controller.dispose();
    },
  );

  testWidgets('role with permission sees the protected block', (tester) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.write'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('Protected asset action'), findsOneWidget);
    expect(find.text('No access'), findsNothing);
    controller.dispose();
  });

  testWidgets('role without permission sees the no-access state', (
    tester,
  ) async {
    final controller = PermissionController(
      initialPermissions: const ['assets.read'],
    );
    await tester.pumpWidget(
      MaterialApp(
        home: PermissionProvider(
          controller: controller,
          child: const PermissionGate(
            permission: 'assets.write',
            fallback: Text('No access'),
            child: Text('Protected asset action'),
          ),
        ),
      ),
    );

    expect(find.text('No access'), findsOneWidget);
    expect(find.text('Protected asset action'), findsNothing);
    controller.dispose();
  });
}
