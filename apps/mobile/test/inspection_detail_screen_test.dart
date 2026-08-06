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

CurrentUser identityFor(String roleKey, List<String> permissions) =>
    CurrentUser(
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
  List<InspectionMediaResponse> media = const [],
  List<AnnotationResponse> annotations = const [],
  List<VoiceNoteResponse> voiceNotes = const [],
  ReadingsResponse? readings,
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
      )
      ..media.addAll(media)
      ..annotations.addAll(annotations)
      ..voiceNotes.addAll(voiceNotes)
      ..readings = readings?.toBuilder(),
  );
}

ReadingsResponse _readingsFixture() {
  return ReadingsResponse(
    (b) => b
      ..condition = ReadingsResponseConditionEnum.critical
      ..temperatureC = 95.5
      ..pressureBar = 6.2
      ..noiseLevelDb = 92.0
      ..vibrationObservation = 'Excessive vibration near bearing'
      ..leakObserved = true
      ..operationalStatus = ReadingsResponseOperationalStatusEnum.degraded
      ..comments = 'Bearing failing'
      ..recommendations = 'Replace bearing immediately'
      ..priorityLevel = ReadingsResponsePriorityLevelEnum.critical
      ..recordedAt = DateTime.utc(2026, 1, 2)
      ..recordedBy = 'demo-acme-field_inspector',
  );
}

InspectionMediaResponse _mediaFixture({String id = 'media-1'}) {
  return InspectionMediaResponse(
    (b) => b
      ..id = id
      ..localId = 'local-1'
      ..url = 'https://storage.example.invalid/$id.jpg'
      ..kind = InspectionMediaResponseKindEnum.photo
      ..filename = 'photo.jpg'
      ..contentType = 'image/jpeg'
      ..size = 1000
      ..capturedAt = DateTime.utc(2026, 1, 1)
      ..uploadedBy = 'demo-acme-field_inspector'
      ..uploadedAt = DateTime.utc(2026, 1, 1),
  );
}

VoiceNoteResponse _voiceNoteFixture({String id = 'voice-1'}) {
  return VoiceNoteResponse(
    (b) => b
      ..id = id
      ..localId = 'voice-local-1'
      ..url = 'https://storage.example.invalid/$id.m4a'
      ..filename = 'note.m4a'
      ..contentType = 'audio/mp4'
      ..size = 5000
      ..durationMs = 42000
      ..uploadedBy = 'demo-acme-field_inspector'
      ..uploadedAt = DateTime.utc(2026, 1, 1),
  );
}

AnnotationResponse _annotationFixture({String mediaLocalId = 'local-1'}) {
  return AnnotationResponse(
    (b) => b
      ..id = 'annotation-1'
      ..mediaLocalId = mediaLocalId
      ..shape = AnnotationResponseShapeEnum.rectangle
      ..points.addAll([
        AnnotationPointResponse((p) => p
          ..x = 0.1
          ..y = 0.1),
        AnnotationPointResponse((p) => p
          ..x = 0.4
          ..y = 0.4),
      ])
      ..color = '#C1123F'
      ..damageType = AnnotationResponseDamageTypeEnum.corrosion
      ..note = 'Visible corrosion'
      ..createdBy = 'demo-acme-field_inspector'
      ..createdAt = DateTime.utc(2026, 1, 1),
  );
}

class FakeApi implements ApiContract {
  FakeApi(
    this.identity, {
    this.status = InspectionDetailStatusEnum.inProgress,
    this.offline = false,
    this.media = const [],
    this.annotations = const [],
    this.voiceNotes = const [],
    this.readings,
  });

  final CurrentUser identity;
  final InspectionDetailStatusEnum status;
  final List<InspectionMediaResponse> media;
  final List<AnnotationResponse> annotations;
  final List<VoiceNoteResponse> voiceNotes;
  final ReadingsResponse? readings;

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
  Future<InspectionListPage> getInspections({
    String? assetId,
    String? facilityId,
    String? status,
    String? inspectorId,
    String? cursor,
    int limit = 25,
  }) async {
    if (offline) {
      throw const ApiException(code: 'network_error', message: 'offline');
    }
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
    if (offline) {
      throw const ApiException(code: 'network_error', message: 'offline');
    }
    return _inspectionDetailFixture(
        status: status,
        media: media,
        annotations: annotations,
        voiceNotes: voiceNotes,
        readings: readings);
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
  Future<InspectionDetail> startInspection(String inspectionId) =>
      throw UnimplementedError();

  @override
  Future<InspectionDetail> completeInspection(String inspectionId) =>
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
  testWidgets('a completed inspection renders its checklist read-only',
      (tester) async {
    final api = FakeApi(
      identityFor('field_inspector', const ['inspections.read']),
      status: InspectionDetailStatusEnum.completed,
      readings: _readingsFixture(),
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
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

    // Readings (Phase 7.7) render read-only, further down the ListView.
    await tester.scrollUntilVisible(find.text('READINGS'), 200);
    // Condition shown prominently via the StatusPill, with each value's unit visible.
    expect(find.text('CRITICAL'), findsWidgets);
    expect(find.text('95.5 °C'), findsOneWidget);
    expect(find.text('6.2 bar'), findsOneWidget);
    expect(find.text('92.0 dB'), findsOneWidget);
    expect(find.text('Bearing failing'), findsOneWidget);
    // Read-only means no editable readings inputs either.
    expect(find.byKey(const Key('readings-condition')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets(
    'an in_progress inspection is interactive: answering the required item enables Complete',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final api = FakeApi(identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']));
      await tester.pumpWidget(
        FevApp(
            api: api,
            authGateway: FakeGateway(),
            initialRoute: AppRoutes.inspections,
            database: db),
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
      // this test. The page's own outer ListView is passed explicitly as
      // `scrollable` since the 7.7 readings section's several `AppTextField`s
      // each contribute their own internal (horizontally-scrolling)
      // `Scrollable`, so the default `find.byType(Scrollable)` this helper
      // would otherwise use is no longer unique on this screen.
      final pageScrollable = find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first;
      await tester.scrollUntilVisible(
          find.byKey(const Key('complete-inspection')), 200,
          scrollable: pageScrollable);
      final completeButton = tester
          .widget<AppButton>(find.byKey(const Key('complete-inspection')));
      expect(completeButton.onPressed, isNull);

      // The MEDIA section between the checklist and Complete button means
      // the two are no longer guaranteed within the same viewport -- scroll
      // back to the Pass/Fail row specifically before tapping it.
      // `scrollUntilVisible` steps incrementally so the lazily-built ListView
      // re-mounts the target at all (a single `ensureVisible` jump can't,
      // since a far-off-screen item isn't built yet -- "No element"); the
      // follow-up `ensureVisible` then guarantees it's fully unobstructed
      // (not just barely intersecting the viewport edge) before tapping.
      await tester.scrollUntilVisible(
          find.byKey(const Key('item-vibration_normal-pass')), -200,
          scrollable: pageScrollable);
      await tester
          .ensureVisible(find.byKey(const Key('item-vibration_normal-pass')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('item-vibration_normal-pass')));
      await tester.pumpAndSettle();

      final answeredRow = await (db.select(db.localInspections)
            ..where((t) => t.id.equals('inspection-1')))
          .getSingle();
      final answered = LocalInspectionRecord(answeredRow);
      expect(answered.checklistResponses, hasLength(1));
      expect(checklistResponseValue(answered.checklistResponses.single), true);

      await tester.scrollUntilVisible(
          find.byKey(const Key('complete-inspection')), 200,
          scrollable: pageScrollable);
      final completeButtonAfter = tester
          .widget<AppButton>(find.byKey(const Key('complete-inspection')));
      expect(completeButtonAfter.onPressed, isNotNull);

      await tester.ensureVisible(find.byKey(const Key('complete-inspection')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('complete-inspection')));
      await tester.pumpAndSettle();

      final completedRow = await (db.select(db.localInspections)
            ..where((t) => t.id.equals('inspection-1')))
          .getSingle();
      expect(completedRow.status, 'completed');
      await disposeApp(tester);
    },
  );

  testWidgets(
    'readings (Phase 7.7): units are shown, nothing autosaves until a condition '
    'is chosen, and a later field builds on the saved condition',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final api = FakeApi(identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']));
      await tester.pumpWidget(
        FevApp(
            api: api,
            authGateway: FakeGateway(),
            initialRoute: AppRoutes.inspections,
            database: db),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Q3 Routine Inspection'));
      await tester.pumpAndSettle();

      final pageScrollable = find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first;
      await tester.scrollUntilVisible(
          find.byKey(const Key('readings-condition')), 200,
          scrollable: pageScrollable);
      await tester.ensureVisible(find.byKey(const Key('readings-condition')));
      await tester.pumpAndSettle();

      // Units are visible on the field labels themselves (fixed documented
      // units, D-0xx: Celsius/bar/decibels -- no unit picker).
      expect(find.text('Temperature (°C)'), findsOneWidget);
      expect(find.text('Pressure (bar)'), findsOneWidget);
      expect(find.text('Noise level (dB)'), findsOneWidget);

      // Nothing is persisted yet -- condition, the only required field,
      // hasn't been chosen.
      var row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals('inspection-1')))
          .getSingle();
      expect(row.readings, isNull);

      await tester.tap(find.byKey(const Key('readings-condition')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Critical').last);
      await tester.pumpAndSettle();

      row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals('inspection-1')))
          .getSingle();
      expect(LocalInspectionRecord(row).readings?.condition,
          ReadingsResponseConditionEnum.critical);

      // The temperature field sits right after condition in the same card --
      // still reachable without a far re-scroll that could tear down the
      // section's state and lose the not-yet-flushed edit below.
      await tester.ensureVisible(find.byKey(const Key('readings-temperature')));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('readings-temperature')), '80');
      await tester.pump(const Duration(milliseconds: 600));

      row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals('inspection-1')))
          .getSingle();
      final record = LocalInspectionRecord(row);
      // The whole readings object is resent on every save, so the earlier
      // condition survives alongside the newly typed temperature.
      expect(record.readings?.condition, ReadingsResponseConditionEnum.critical);
      expect(record.readings?.temperatureC, 80);
      await disposeApp(tester);
    },
  );

  testWidgets(
    'opening a stale local draft auto-assigns the matching template and starts it, fully offline',
    (tester) async {
      final db = AppDatabase(NativeDatabase.memory());
      final api = FakeApi(
          identityFor('field_inspector',
              const ['inspections.read', 'inspections.write']),
          offline: true);
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
        FevApp(
            api: api,
            authGateway: FakeGateway(),
            initialRoute: AppRoutes.inspections,
            database: db),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('Untitled'));
      await tester.pumpAndSettle();

      final row = await (db.select(db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      expect(row.status, 'in_progress');
      expect(row.checklistTemplateId, 'pumps-template');
      expect(find.text('Pressure OK'), findsOneWidget);
      await disposeApp(tester);
    },
  );

  testWidgets(
      'shows an honest empty state when the inspection has no media yet',
      (tester) async {
    final api = FakeApi(identityFor(
        'field_inspector', const ['inspections.read', 'inspections.write']));
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('MEDIA'), 200);
    expect(find.text('MEDIA'), findsOneWidget);
    expect(find.text('No media yet'), findsOneWidget);
    expect(find.byKey(const Key('media-upload-progress')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('renders a synced media item and the upload-progress count',
      (tester) async {
    final api = FakeApi(
      identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']),
      media: [_mediaFixture()],
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
        find.byKey(const Key('media-upload-progress')), 200);
    expect(find.byKey(const Key('media-upload-progress')), findsOneWidget);
    expect(find.text('1 of 1 uploaded'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets(
      'renders a locally-queued item with its upload-state badge, counted as pending',
      (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    final api = FakeApi(identityFor(
        'field_inspector', const ['inspections.read', 'inspections.write']));
    await db.into(db.mediaQueue).insert(
          MediaQueueCompanion.insert(
            localId: 'local-queued-1',
            inspectionId: 'inspection-1',
            kind: 'photo',
            localFilePath: '/tmp/photo.jpg',
            storagePath:
                'companies/acme-energy/inspections/inspection-1/media/local-queued-1_photo.jpg',
            filename: 'photo.jpg',
            contentType: 'image/jpeg',
            sizeBytes: 500,
            capturedAt: DateTime.utc(2026, 1, 1),
            createdAt: DateTime.utc(2026, 1, 1),
          ),
        );

    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: db),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('Queued'), 200);
    expect(find.text('Queued'), findsOneWidget);
    expect(find.text('0 of 1 uploaded'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets(
      'shows an honest empty state when the inspection has no voice notes yet',
      (tester) async {
    final api = FakeApi(identityFor(
        'field_inspector', const ['inspections.read', 'inspections.write']));
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('VOICE NOTES'), 200);
    expect(find.text('VOICE NOTES'), findsOneWidget);
    expect(find.text('No voice notes yet'), findsOneWidget);
    expect(find.byKey(const Key('voice-upload-progress')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('renders a synced voice note item and the upload-progress count',
      (tester) async {
    final api = FakeApi(
      identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']),
      voiceNotes: [_voiceNoteFixture()],
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
        find.byKey(const Key('voice-upload-progress')), 200);
    expect(find.byKey(const Key('voice-upload-progress')), findsOneWidget);
    expect(find.text('1 of 1 uploaded'), findsOneWidget);
    expect(find.text('00:42'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets(
      'renders a locally-queued voice note with its upload-state badge, counted as pending',
      (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    final api = FakeApi(identityFor(
        'field_inspector', const ['inspections.read', 'inspections.write']));
    await db.into(db.mediaQueue).insert(
          MediaQueueCompanion.insert(
            localId: 'local-queued-voice-1',
            inspectionId: 'inspection-1',
            kind: 'audio',
            localFilePath: '/tmp/note.m4a',
            storagePath:
                'companies/acme-energy/inspections/inspection-1/voice/local-queued-voice-1_note.m4a',
            filename: 'note.m4a',
            contentType: 'audio/mp4',
            sizeBytes: 500,
            capturedAt: DateTime.utc(2026, 1, 1),
            durationMs: const drift.Value(15000),
            createdAt: DateTime.utc(2026, 1, 1),
          ),
        );

    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: db),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('VOICE NOTES'), 200);
    expect(find.text('Queued'), findsOneWidget);
    expect(find.text('0 of 1 uploaded'), findsOneWidget);
    expect(find.text('00:15'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets(
      'does not show the annotation-overlay toggle when there are no annotations',
      (
    tester,
  ) async {
    final api = FakeApi(
      identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']),
      media: [_mediaFixture()],
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(find.text('MEDIA'), 200);
    expect(find.byKey(const Key('toggle-annotation-overlay')), findsNothing);
    await disposeApp(tester);
  });

  testWidgets(
      'shows the annotation-overlay toggle and hides the overlay when tapped', (
    tester,
  ) async {
    final api = FakeApi(
      identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']),
      media: [_mediaFixture()],
      annotations: [_annotationFixture()],
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
        find.byKey(const Key('toggle-annotation-overlay')), 200);
    expect(find.byTooltip('Hide annotations'), findsOneWidget);

    await tester.tap(find.byKey(const Key('toggle-annotation-overlay')));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Show annotations'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('tapping a photo tile opens the annotation canvas',
      (tester) async {
    final api = FakeApi(
      identityFor(
          'field_inspector', const ['inspections.read', 'inspections.write']),
      media: [_mediaFixture()],
      annotations: [_annotationFixture()],
    );
    await tester.pumpWidget(
      FevApp(
          api: api,
          authGateway: FakeGateway(),
          initialRoute: AppRoutes.inspections,
          database: AppDatabase(NativeDatabase.memory())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Q3 Routine Inspection'));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
        find.byKey(const Key('media-tile-media-1')), 200);
    await tester.tap(find.byKey(const Key('media-tile-media-1')));
    // The canvas's own image never finishes resolving in a widget test (no
    // real network access), so it settles into a permanent loading state --
    // pump a bounded number of frames instead of `pumpAndSettle`.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Annotate photo'), findsOneWidget);
    await disposeApp(tester);
  });
}
