import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/company_fixtures.dart';
import 'support/dashboard_fixtures.dart';

const session = AuthSession(
  uid: 'demo-acme-company_admin',
  email: 'company_admin@acme.example.invalid',
  emailVerified: true,
);

const roleMatrix = <String, List<String>>{
  'company_admin': [
    'assets.read',
    'reports.read',
    'reports.generate',
    'users.manage',
    'roles.manage',
    'company.settings',
  ],
  'field_inspector': ['assets.read', 'reports.read', 'reports.generate'],
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

typedef GetCompanyProfileFn = Future<CompanyProfile> Function();

class FakeApi implements ApiContract {
  FakeApi(this.identity, {GetCompanyProfileFn? getCompanyProfile})
      : _getCompanyProfile = getCompanyProfile ?? (() async => companyProfileFixture());

  final CurrentUser identity;
  final GetCompanyProfileFn _getCompanyProfile;

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
  Future<CompanyProfile> getCompanyProfile() => _getCompanyProfile();

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

Future<void> pumpSettings(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.settings, database: AppDatabase(NativeDatabase.memory())),
  );
  await tester.pump();
}

void main() {
  testWidgets('shows loading then renders the company profile', (tester) async {
    final api = FakeApi(identityFor('company_admin', roleMatrix['company_admin']!));
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Acme Energy'), findsOneWidget);
    expect(find.text('Electric Utility'), findsOneWidget);
    expect(find.text('PROFESSIONAL'), findsOneWidget);
    expect(find.textContaining('Company since'), findsOneWidget);
  });

  testWidgets('shows a retry-capable error state when the profile request fails', (tester) async {
    var attempts = 0;
    final api = FakeApi(
      identityFor('company_admin', roleMatrix['company_admin']!),
      getCompanyProfile: () async {
        attempts += 1;
        throw Exception('boom');
      },
    );
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Retry'), findsOneWidget);
    expect(attempts, 1);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(attempts, 2);
  });

  testWidgets('hides Company Settings for a role without company.settings at the route level',
      (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpSettings(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    expect(find.text('Acme Energy'), findsNothing);
  });
}
