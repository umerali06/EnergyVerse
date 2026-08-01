import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:fev_api_client/fev_api_client.dart';
import 'package:fev_mobile/api/api_service.dart';
import 'package:fev_mobile/auth/app_routes.dart';
import 'package:fev_mobile/auth/firebase_gateway.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:fev_mobile/design_system/primitives.dart';
import 'package:fev_mobile/inspections/local_inspections_repository.dart';
import 'package:fev_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const session = AuthSession(
  uid: 'demo-acme-field_inspector',
  email: 'field_inspector@acme.example.invalid',
  emailVerified: true,
);

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
  InspectionListItemStatusEnum status = InspectionListItemStatusEnum.inProgress,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return InspectionListItem(
    (b) => b
      ..id = 'inspection-1'
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'demo-acme-field_inspector'
      ..status = status
      ..inspectionType = InspectionListItemInspectionTypeEnum.routine
      ..title = 'Q3 Routine Inspection'
      ..revision = 2
      ..createdAt = now
      ..updatedAt = now,
  );
}

InspectionDetail _inspectionDetailFixture({
  InspectionDetailStatusEnum status = InspectionDetailStatusEnum.inProgress,
}) {
  final now = DateTime.utc(2026, 1, 1);
  final startedAt = DateTime.utc(2026, 1, 2);
  return InspectionDetail(
    (b) => b
      ..id = 'inspection-1'
      ..assetId = 'asset-1'
      ..facilityId = 'facility-1'
      ..inspectorId = 'demo-acme-field_inspector'
      ..status = status
      ..inspectionType = InspectionDetailInspectionTypeEnum.routine
      ..title = 'Q3 Routine Inspection'
      ..notes = 'Started ahead of schedule.'
      ..revision = 2
      ..clientCreatedAt = now
      ..createdAt = now
      ..updatedAt = startedAt
      ..startedAt = startedAt
      ..checklistItemsSnapshot.add(
        ChecklistTemplateItem(
          (item) => item
            ..id = 'vibration_normal'
            ..label = 'Vibration normal'
            ..itemType = ChecklistTemplateItemItemTypeEnum.boolean
            ..required_ = true,
        ),
      ),
  );
}

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    this.status = InspectionDetailStatusEnum.inProgress,
    this.offline = false,
  });

  final CurrentUser identity;
  final InspectionDetailStatusEnum status;

  /// Simulates airplane mode: every inspections network call throws, so
  /// [LocalInspectionsRepository]'s best-effort refreshes are no-ops and
  /// whatever is already in the local cache is all the screen ever sees --
  /// exactly the offline-first contract Phase 7.3's auto-start must honor.
  final bool offline;

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
  }) async {
    if (offline) throw const ApiException(code: 'network_error', message: 'offline');
    return InspectionListPage(
      (b) => b
        ..items.add(
          _inspectionItemFixture(
            status: InspectionListItemStatusEnum.valueOf(this.status.name),
          ),
        ),
    );
  }

  @override
  Future<InspectionDetail> getInspection(String inspectionId) async {
    if (offline) throw const ApiException(code: 'network_error', message: 'offline');
    return _inspectionDetailFixture(status: status);
  }

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
  Future<InspectionDetail> completeInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> cancelInspection(String inspectionId) => throw UnimplementedError();

  @override
  Future<InspectionDetail> assignChecklistTemplate(
    String inspectionId,
    AssignChecklistTemplateRequest request,
  ) =>
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

/// Drift's query-stream cancellation schedules a zero-duration internal
/// Timer when a subscriber unmounts; `flutter_test`'s pending-timer
/// invariant check runs at the end of the test body itself, so this must
/// be called inline as the last step of every test that pumps [FevApp].
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 1));
}

void main() {
  testWidgets('a completed inspection renders its checklist read-only', (tester) async {
    final api = FakeApi(
      identityFor('field_inspector', const ['inspections.read']),
      status: InspectionDetailStatusEnum.completed,
    );
    await tester.pumpWidget(
      FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.inspections, database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    // StatusPill always renders its label uppercased (a widget-level style,
    // not something this screen's own label-casing helper controls).
    expect(find.text('COMPLETED'), findsWidgets);
    expect(find.text('Started ahead of schedule.'), findsOneWidget);
    expect(find.textContaining('Vibration normal'), findsOneWidget);
    expect(find.text('Not answered'), findsOneWidget);
    // A completed inspection is locked -- no Pass/Fail inputs or Complete button.
    expect(find.text('Pass'), findsNothing);
    expect(find.text('Complete Inspection'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets(
    'an in_progress inspection is interactive: answering the required item enables Complete',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final api = FakeApi(identityFor('field_inspector', const ['inspections.read', 'inspections.write']));
      await tester.pumpWidget(
        FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.inspections, database: db),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Q3 Routine Inspection'));
      await tester.pumpAndSettle();

      // Unanswered required item: interactive Pass/Fail, Complete disabled.
      expect(find.text('Pass'), findsOneWidget);
      expect(find.text('0 / 1 · 1 required remaining'), findsOneWidget);

      // The ListView virtualizes off-screen children, so a long scroll to
      // reach the Complete button can drop the (already-asserted) header
      // above out of the built range -- read persisted state back from the
      // database instead of fighting the scroll position for the rest of
      // this test.
      await tester.scrollUntilVisible(find.byKey(const Key('complete-inspection')), 200);
      final completeButton = tester.widget<AppButton>(find.byKey(const Key('complete-inspection')));
      expect(completeButton.onPressed, isNull);

      await tester.tap(find.byKey(const Key('item-vibration_normal-pass')));
      await tester.pumpAndSettle();

      final answeredRow =
          await (db.select(db.localInspections)..where((t) => t.id.equals('inspection-1'))).getSingle();
      final answered = LocalInspectionRecord(answeredRow);
      expect(answered.checklistResponses, hasLength(1));
      expect(checklistResponseValue(answered.checklistResponses.single), true);

      await tester.scrollUntilVisible(find.byKey(const Key('complete-inspection')), 200);
      final completeButtonAfter =
          tester.widget<AppButton>(find.byKey(const Key('complete-inspection')));
      expect(completeButtonAfter.onPressed, isNotNull);

      await tester.tap(find.byKey(const Key('complete-inspection')));
      await tester.pumpAndSettle();

      final completedRow =
          await (db.select(db.localInspections)..where((t) => t.id.equals('inspection-1'))).getSingle();
      expect(completedRow.status, 'completed');
      await disposeApp(tester);
    },
  );

  testWidgets(
    'opening a stale local draft auto-assigns the matching template and starts it, fully offline',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final api = FakeApi(identityFor('field_inspector', const ['inspections.read', 'inspections.write']), offline: true);
      final repository = LocalInspectionsRepository(db: db, api: api);

      await db.into(db.localChecklistTemplates).insert(
            LocalChecklistTemplatesCompanion.insert(
              id: 'pumps-template',
              category: 'Pumps',
              name: 'Pumps template',
              version: 1,
              itemsJson: drift.Value(
                '[{"id":"press_ok","label":"Pressure OK","item_type":"boolean","required":true}]',
              ),
              updatedAt: DateTime.utc(2026, 1, 1),
            ),
          );
      final inspectionId = await repository.createDraft(
        assetId: 'asset-9',
        inspectorId: 'demo-acme-field_inspector',
        inspectionType: 'ad_hoc',
        assetCategory: 'Pumps',
      );

      await tester.pumpWidget(
        FevApp(api: api, authGateway: FakeGateway(), initialRoute: AppRoutes.inspections, database: db),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Untitled'));
      await tester.pumpAndSettle();

      final row = await (db.select(db.localInspections)..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      expect(row.status, 'in_progress');
      expect(row.checklistTemplateId, 'pumps-template');
      expect(find.text('Pressure OK'), findsOneWidget);
      await disposeApp(tester);
    },
  );
}
