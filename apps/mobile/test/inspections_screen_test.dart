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
  uid: 'demo-acme-field_inspector',
  email: 'field_inspector@acme.example.invalid',
  emailVerified: true,
);

const roleMatrix = <String, List<String>>{
  'field_inspector': ['inspections.read', 'inspections.write'],
  'executive': ['reports.read'],
};

CurrentUser identityFor(String roleKey, List<String> permissions) => CurrentUser(
      (builder) => builder
        ..uid = 'demo-acme-field_inspector'
        ..email = 'field_inspector@acme.example.invalid'
        ..companyId = 'acme-energy'
        ..companyName = 'Acme Energy'
        ..roleKey = roleKey
        ..emailVerified = true
        ..permissions.addAll(permissions),
    );

InspectionListItem _inspectionItemFixture({
  String id = 'inspection-1',
  String title = 'Q3 Routine Inspection',
  InspectionListItemStatusEnum status = InspectionListItemStatusEnum.completed,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionListItem(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'demo-acme-field_inspector'
      ..status = status
      ..inspectionType = InspectionListItemInspectionTypeEnum.routine
      ..title = title
      ..revision = 1
      ..createdAt = now
      ..updatedAt = now,
  );
}

InspectionListPage _pageFixture({List<InspectionListItem>? items, String? nextCursor}) =>
    InspectionListPage((b) => b
      ..items.addAll(items ?? [_inspectionItemFixture()])
      ..nextCursor = nextCursor);

InspectionDetail _inspectionDetailFixture({
  String id = 'inspection-1',
  String title = 'Q3 Routine Inspection',
  InspectionDetailStatusEnum status = InspectionDetailStatusEnum.completed,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionDetail(
    (b) => b
      ..id = id
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'demo-acme-field_inspector'
      ..status = status
      ..inspectionType = InspectionDetailInspectionTypeEnum.routine
      ..title = title
      ..revision = 1
      ..clientCreatedAt = now
      ..createdAt = now
      ..updatedAt = now,
  );
}

typedef GetInspectionsFn = Future<InspectionListPage> Function({
  String? assetId,
  String? facilityId,
  String? status,
  String? inspectorId,
  String? cursor,
  int limit,
});

typedef GetInspectionFn = Future<InspectionDetail> Function(String inspectionId);

class FakeApi implements ApiContract {
  FakeApi(this.identity, {GetInspectionsFn? getInspections, GetInspectionFn? getInspection})
      : _getInspections = getInspections ?? (({
          String? assetId,
          String? facilityId,
          String? status,
          String? inspectorId,
          String? cursor,
          int limit = 25,
        }) async =>
            _pageFixture()),
        _getInspection = getInspection ?? ((id) async => _inspectionDetailFixture(id: id));

  final CurrentUser identity;
  final GetInspectionsFn _getInspections;
  final GetInspectionFn _getInspection;

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
      _getInspections(
        assetId: assetId,
        facilityId: facilityId,
        status: status,
        inspectorId: inspectorId,
        cursor: cursor,
        limit: limit,
      );

  @override
  Future<InspectionDetail> getInspection(String inspectionId) => _getInspection(inspectionId);

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

Future<void> pumpInspections(WidgetTester tester, {required FakeApi api}) async {
  await tester.pumpWidget(
    FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.inspections, database: AppDatabase(NativeDatabase.memory())),
  );
  await tester.pump();
}

/// Drift's query-stream cancellation schedules a zero-duration internal
/// Timer when a subscriber (e.g. the app shell's sync-status banner)
/// unmounts. `flutter_test`'s pending-timer invariant check runs at the end
/// of the test body itself -- before any `addTearDown` callback -- so this
/// must be called inline, as the last step of every test that pumps
/// [FevApp], to unmount and flush that timer before the check fires.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  testWidgets('shows loading then renders real tenant inspections', (tester) async {
    final api = FakeApi(identityFor('field_inspector', roleMatrix['field_inspector']!));
    await pumpInspections(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('Q3 Routine Inspection'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('shows an honest empty state when no inspections match', (tester) async {
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      getInspections: ({assetId, facilityId, status, inspectorId, cursor, limit = 25}) async =>
          _pageFixture(items: const []),
    );
    await pumpInspections(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text('No inspections found'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('re-fetches when the status filter changes', (tester) async {
    final calls = <String?>[];
    final api = FakeApi(
      identityFor('field_inspector', roleMatrix['field_inspector']!),
      getInspections: ({assetId, facilityId, status, inspectorId, cursor, limit = 25}) async {
        calls.add(status);
        return _pageFixture();
      },
    );
    await pumpInspections(tester, api: api);
    await tester.pumpAndSettle();

    await tester.tap(find.text('All statuses'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('In progress').last);
    await tester.pumpAndSettle();

    expect(calls, contains('in_progress'));
    await disposeApp(tester);
  });

  testWidgets('renders the honest 403 screen for a role without inspections.read', (tester) async {
    final api = FakeApi(identityFor('executive', roleMatrix['executive']!));
    await pumpInspections(tester, api: api);
    await tester.pumpAndSettle();

    expect(find.text("You can't view this area"), findsOneWidget);
    await disposeApp(tester);
  });
}
