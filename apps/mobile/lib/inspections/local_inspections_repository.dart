import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart' as drift;
import 'package:fev_api_client/fev_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:one_of/any_of.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../api/api_service.dart';
import '../db/app_database.dart';

/// Mirrors the five sync states a locally-cached inspection can be in.
/// `wireValue` is exactly what's persisted in `LocalInspections.syncState`.
enum LocalSyncState {
  localOnly('local_only'),
  pendingSync('pending_sync'),
  synced('synced'),
  conflict('conflict'),
  error('error');

  const LocalSyncState(this.wireValue);

  final String wireValue;

  static LocalSyncState fromWire(String value) => values.firstWhere(
        (state) => state.wireValue == value,
        orElse: () => LocalSyncState.error,
      );
}

/// The outbox's mutation kinds. `attachMedia`/`editMedia`/`detachMedia`
/// (Phase 7.4) are small metadata-reference mutations only -- the media
/// BYTES never flow through this outbox; they upload directly to Firebase
/// Storage via the separate `MediaQueue` table and `MediaUploadWorker`,
/// entirely independent of `SyncEngine`.
enum OutboxMutationType {
  create('create'),
  update('update'),
  start('start'),
  complete('complete'),
  cancel('cancel'),
  assignTemplate('assign_template'),
  attachMedia('attach_media'),
  editMedia('edit_media'),
  detachMedia('detach_media'),
  attachVoiceNote('attach_voice_note'),
  editVoiceNote('edit_voice_note'),
  detachVoiceNote('detach_voice_note'),
  createAnnotation('create_annotation'),
  updateAnnotation('update_annotation'),
  deleteAnnotation('delete_annotation'),
  createMeasurement('create_measurement'),
  updateMeasurement('update_measurement'),
  deleteMeasurement('delete_measurement');

  const OutboxMutationType(this.wireValue);

  final String wireValue;

  static OutboxMutationType fromWire(String value) =>
      values.firstWhere((type) => type.wireValue == value);
}

/// Thrown by [LocalInspectionsRepository.completeInspection] when required
/// checklist items are unanswered -- mirrors the server's `checklist_incomplete`
/// check (`InspectionService.complete_inspection`) so a doomed completion
/// never reaches the outbox at all.
class ChecklistIncompleteError implements Exception {
  const ChecklistIncompleteError(this.missingItemIds);

  final List<String> missingItemIds;

  @override
  String toString() => 'ChecklistIncompleteError($missingItemIds)';
}

/// Converts a wire-form enum value (snake_case, e.g. `in_progress`) to the
/// Dart identifier `built_value` generates for it (`inProgress`) -- every
/// generated `*Enum.valueOf()` looks up by that identifier, not the wire
/// value. Every inline enum the OpenAPI generator emits shares this mapping
/// (single-word values are identity), so one generic converter covers
/// `status` and `inspection_type` across all three separately-generated
/// enum classes (`CreateInspectionRequestInspectionTypeEnum`,
/// `UpdateInspectionRequestInspectionTypeEnum`, `InspectionDetailInspectionTypeEnum`).
String wireToDartEnumName(String wireValue) {
  final parts = wireValue.split('_');
  if (parts.length == 1) return wireValue;
  final rest = parts.skip(1).map(
        (part) =>
            part.isEmpty ? part : part[0].toUpperCase() + part.substring(1),
      );
  return parts.first + rest.join();
}

/// The inverse of [wireToDartEnumName] -- every local write path
/// (`createDraft`, `startInspection`, etc.) stores `status`/`inspectionType`
/// as their wire value, so a row upserted from a server [InspectionDetail]
/// (whose enum's `.name` getter is the *Dart* identifier, e.g. `inProgress`)
/// must go through this before being stored, or a locally-written row and a
/// server-synced row for the same status would disagree on their string
/// (`in_progress` vs `inProgress`) -- and `in_progress`/`ad_hoc` are exactly
/// the two values this repository's own status checks compare against.
String dartEnumNameToWire(String dartName) => dartName.replaceAllMapped(
      RegExp('([A-Z])'),
      (match) => '_${match.group(1)!.toLowerCase()}',
    );

List<ChecklistTemplateItem> _decodeChecklistItems(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          ChecklistTemplateItem.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

List<ChecklistResponse> _decodeChecklistResponses(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          ChecklistResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

List<InspectionMediaResponse> _decodeInspectionMedia(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          InspectionMediaResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeInspectionMedia(List<InspectionMediaResponse> media) =>
    jsonEncode(
      media
          .map((item) => standardSerializers.serializeWith(
              InspectionMediaResponse.serializer, item))
          .toList(),
    );

List<AnnotationResponse> _decodeAnnotations(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          AnnotationResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeAnnotations(List<AnnotationResponse> annotations) => jsonEncode(
      annotations
          .map((item) => standardSerializers.serializeWith(
              AnnotationResponse.serializer, item))
          .toList(),
    );

List<ArMeasurementResponse> _decodeArMeasurements(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          ArMeasurementResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeArMeasurements(List<ArMeasurementResponse> measurements) =>
    jsonEncode(
      measurements
          .map((item) => standardSerializers.serializeWith(
              ArMeasurementResponse.serializer, item))
          .toList(),
    );

List<AiAnalysisResponse> _decodeAiAnalysis(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          AiAnalysisResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeAiAnalysis(List<AiAnalysisResponse> analyses) => jsonEncode(
      analyses
          .map((item) => standardSerializers.serializeWith(
              AiAnalysisResponse.serializer, item))
          .toList(),
    );

List<VoiceNoteResponse> _decodeVoiceNotes(String json) {
  final list = jsonDecode(json) as List<dynamic>;
  return list
      .map(
        (item) => standardSerializers.deserializeWith(
          VoiceNoteResponse.serializer,
          item as Map<String, dynamic>,
        )!,
      )
      .toList();
}

String _encodeVoiceNotes(List<VoiceNoteResponse> voiceNotes) => jsonEncode(
      voiceNotes
          .map((item) => standardSerializers.serializeWith(
              VoiceNoteResponse.serializer, item))
          .toList(),
    );

/// Readings (Phase 7.7) are a single nullable object, not an array -- cached
/// locally in the server's `ReadingsResponse` shape (the superset of
/// `ReadingsInput` that also carries `recordedAt`/`recordedBy`) whether the
/// value came from a synced server response or an optimistic local edit
/// (see [_readingsInputToLocalResponse]).
ReadingsResponse? _decodeReadings(String? json) {
  if (json == null) return null;
  return standardSerializers.deserializeWith(
    ReadingsResponse.serializer,
    jsonDecode(json) as Map<String, dynamic>,
  );
}

String? _encodeReadings(ReadingsResponse? readings) {
  if (readings == null) return null;
  return jsonEncode(
    standardSerializers.serializeWith(ReadingsResponse.serializer, readings),
  );
}

/// A freshly submitted [ReadingsInput] cached locally before its outbox
/// mutation has synced -- `recordedAt`/`recordedBy` are left unset, same
/// rationale as `ChecklistResponse.answeredAt`/`answeredBy`: the server
/// always stamps them, so there's nothing honest to show until synced.
ReadingsResponse _readingsInputToLocalResponse(ReadingsInput input) {
  return ReadingsResponse((b) => b
    ..condition = ReadingsResponseConditionEnum.valueOf(input.condition.name)
    ..temperatureC = input.temperatureC
    ..pressureBar = input.pressureBar
    ..noiseLevelDb = input.noiseLevelDb
    ..vibrationObservation = input.vibrationObservation
    ..leakObserved = input.leakObserved
    ..operationalStatus = input.operationalStatus == null
        ? null
        : ReadingsResponseOperationalStatusEnum.valueOf(
            input.operationalStatus!.name)
    ..comments = input.comments
    ..recommendations = input.recommendations
    ..priorityLevel = input.priorityLevel == null
        ? null
        : ReadingsResponsePriorityLevelEnum.valueOf(input.priorityLevel!.name));
}

/// The inverse conversion, needed every time [LocalInspectionsRepository.
/// updateInspection] resends the whole cached readings object (whether or
/// not this particular call touched it) so an unrelated field edit never
/// silently drops it -- mirrors how `title`/`notes` are always resent too.
ReadingsInput _readingsResponseToInput(ReadingsResponse response) {
  return ReadingsInput((b) => b
    ..condition = ReadingsInputConditionEnum.valueOf(response.condition.name)
    ..temperatureC = response.temperatureC
    ..pressureBar = response.pressureBar
    ..noiseLevelDb = response.noiseLevelDb
    ..vibrationObservation = response.vibrationObservation
    ..leakObserved = response.leakObserved
    ..operationalStatus = response.operationalStatus == null
        ? null
        : ReadingsInputOperationalStatusEnum.valueOf(
            response.operationalStatus!.name)
    ..comments = response.comments
    ..recommendations = response.recommendations
    ..priorityLevel = response.priorityLevel == null
        ? null
        : ReadingsInputPriorityLevelEnum.valueOf(response.priorityLevel!.name));
}

/// The server-confirmed digital signature (Phase 7.8) -- a single nullable
/// object, same posture as [_decodeReadings]/[_encodeReadings]. Unlike
/// readings, this is only ever written from a synced server response (see
/// [LocalInspectionsRepository._upsertFromServer]): signer identity/
/// timestamp are server-derived, so there's no honest optimistic value to
/// echo here before sync confirms it -- see [_decodeSignatureStrokes] for
/// what's shown in the meantime.
SignatureResponse? _decodeSignature(String? json) {
  if (json == null) return null;
  return standardSerializers.deserializeWith(
    SignatureResponse.serializer,
    jsonDecode(json) as Map<String, dynamic>,
  );
}

String? _encodeSignature(SignatureResponse? signature) {
  if (signature == null) return null;
  return jsonEncode(
    standardSerializers.serializeWith(SignatureResponse.serializer, signature),
  );
}

/// The just-drawn strokes, cached locally the moment the inspector signs
/// (see [LocalInspectionsRepository.completeInspection]) so the drawing
/// itself is visible immediately -- before the `complete` outbox mutation
/// syncs and before [_decodeSignature] has anything to show.
List<SignatureStrokeInput>? _decodeSignatureStrokes(String? json) {
  if (json == null) return null;
  final decoded = jsonDecode(json) as List<dynamic>;
  return decoded
      .map((stroke) => standardSerializers.deserializeWith(
            SignatureStrokeInput.serializer,
            stroke as Map<String, dynamic>,
          )!)
      .toList();
}

String _encodeSignatureStrokes(List<SignatureStrokeInput> strokes) =>
    jsonEncode(
      strokes
          .map((stroke) => standardSerializers.serializeWith(
              SignatureStrokeInput.serializer, stroke))
          .toList(),
    );

String _encodeChecklistItems(List<ChecklistTemplateItem> items) => jsonEncode(
      items
          .map((item) => standardSerializers.serializeWith(
              ChecklistTemplateItem.serializer, item))
          .toList(),
    );

/// `_$ValueSerializer.deserialize` (fev_api_client's hand-written custom
/// serializer for the `value` field) always deserializes against a fixed
/// 3-parameter `AnyOf<String, num, bool>` target type, so a decoded
/// response's `AnyOfDynamic` ends up as `types: [String, num, bool]` with
/// its one set entry keyed by that type's position (e.g. `bool` -> key 2) --
/// not the single-type/key-0 shape [buildChecklistResponse] constructs. Its
/// paired `serialize` then rebuilds `specifiedType` from the *deduplicated*
/// set of used types (length 1), which no longer lines up with a key of 2,
/// and throws a `RangeError`. This normalizes any response back to the
/// canonical single-type/key-0 shape right before encoding, so it doesn't
/// matter whether the response was just built, decoded from local storage,
/// or deserialized from a server response -- re-encoding it always works.
ChecklistResponse _normalizeResponseValue(ChecklistResponse response) {
  final raw = checklistResponseValue(response);
  if (raw == null) return response;
  final valueType = raw is bool ? bool : (raw is num ? num : String);
  return response.rebuild(
    (b) => b.value.replace(
      Value(
          (v) => v.anyOf = AnyOfDynamic(types: [valueType], values: {0: raw})),
    ),
  );
}

String _encodeChecklistResponses(List<ChecklistResponse> responses) =>
    jsonEncode(
      responses
          .map(
            (r) => standardSerializers.serializeWith(
              ChecklistResponse.serializer,
              _normalizeResponseValue(r),
            ),
          )
          .toList(),
    );

/// Upserts [incoming] over [existing] by `itemId` -- an item present in
/// [incoming] replaces its matching entry in [existing] (or is appended if
/// new); every other existing item is preserved untouched. This is what lets
/// [LocalInspectionsRepository.updateInspection] be called with just the one
/// item the inspector just answered, instead of always resending every
/// answer so far -- calling it with `null` is a no-op (returns [existing]
/// as-is).
List<ChecklistResponse> _mergeChecklistResponses(
  List<ChecklistResponse> existing,
  List<ChecklistResponse>? incoming,
) {
  if (incoming == null || incoming.isEmpty) return existing;
  final merged = {for (final response in existing) response.itemId: response};
  for (final response in incoming) {
    merged[response.itemId] = response;
  }
  return merged.values.toList();
}

/// The `id`s of every required item in [items] that has no answered response
/// in [responses] -- shared by [LocalInspectionsRepository.completeInspection]
/// (the authoritative offline guard) and the fill screen's "Complete" button
/// (the UI-level gating), so the two never drift out of sync.
List<String> missingRequiredItemIds(
  List<ChecklistTemplateItem> items,
  List<ChecklistResponse> responses,
) {
  return [
    for (final item in items)
      if (item.required_ &&
          !responses.any(
              (r) => r.itemId == item.id && isChecklistResponseAnswered(r)))
        item.id,
  ];
}

/// Unwraps a [ChecklistResponse.value]'s built_value `AnyOf` down to the
/// plain Dart value it carries (`bool`/`num`/`String`), or `null` if unset.
Object? checklistResponseValue(ChecklistResponse response) {
  final value = response.value;
  if (value == null) return null;
  return value.anyOf.values.values.firstWhere(
    (candidate) => candidate != null,
    orElse: () => null,
  );
}

/// Builds the [ChecklistResponse] for [itemId] answering with [rawValue],
/// typed to match [itemType] (`boolean` -> `bool`, `numeric` -> `num`,
/// `text`/`select` -> `String`) -- the built_value `AnyOf` wrapper's type
/// list must match what the server/other clients expect to deserialize.
/// `answered_at`/`answered_by` are left unset here; the server always
/// stamps them itself (`InspectionService._validate_responses`).
ChecklistResponse buildChecklistResponse({
  required String itemId,
  required ChecklistTemplateItemItemTypeEnum itemType,
  required Object rawValue,
  String? note,
}) {
  final valueType = itemType == ChecklistTemplateItemItemTypeEnum.boolean
      ? bool
      : itemType == ChecklistTemplateItemItemTypeEnum.numeric
          ? num
          : String;
  return ChecklistResponse(
    (b) => b
      ..itemId = itemId
      ..note = note
      ..value.replace(
        Value(
          (v) =>
              v.anyOf = AnyOfDynamic(types: [valueType], values: {0: rawValue}),
        ),
      ),
  );
}

bool isChecklistResponseAnswered(ChecklistResponse response) {
  final raw = checklistResponseValue(response);
  if (raw == null) return false;
  if (raw is String && raw.isEmpty) return false;
  return true;
}

/// A local inspection row plus its decoded checklist arrays -- the shape
/// every mobile screen renders, whether the data came from the network or
/// is still `local_only`/`pending_sync`. `status`/`inspectionType` are wire
/// values (e.g. `in_progress`, `ad_hoc`); use [wireToDartEnumName] to feed
/// them into `inspectionStatusFor`/`inspectionStatusLabel`.
class LocalInspectionRecord {
  LocalInspectionRecord(this.row)
      : checklistItemsSnapshot =
            _decodeChecklistItems(row.checklistItemsSnapshot),
        checklistResponses = _decodeChecklistResponses(row.checklistResponses),
        media = _decodeInspectionMedia(row.media),
        annotations = _decodeAnnotations(row.annotations),
        arMeasurements = _decodeArMeasurements(row.arMeasurements),
        aiAnalysis = _decodeAiAnalysis(row.aiAnalysis),
        voiceNotes = _decodeVoiceNotes(row.voiceNotes),
        readings = _decodeReadings(row.readings),
        signature = _decodeSignature(row.signature),
        pendingSignatureStrokes =
            _decodeSignatureStrokes(row.pendingSignatureStrokes);

  final LocalInspection row;
  final List<ChecklistTemplateItem> checklistItemsSnapshot;
  final List<ChecklistResponse> checklistResponses;

  /// The server-synced media references (Phase 7.4) -- cached offline, but
  /// only as current as the last successful refresh/mutation. Not-yet-synced
  /// captures live separately in `MediaQueue`/`LocalMediaRepository`.
  final List<InspectionMediaResponse> media;

  /// Damage annotations (Phase 7.5) -- unlike [media], this list is written
  /// optimistically at draw/edit/delete time (see [createAnnotation] et
  /// al.), so it already reflects not-yet-synced local edits, not just the
  /// last server response.
  final List<AnnotationResponse> annotations;

  /// AR/manual dimension measurements (Phase 7.9) -- same optimistic
  /// posture as [annotations]: written locally at capture/edit/delete time
  /// (see [LocalInspectionsRepository.createMeasurement] et al.), so this
  /// already reflects not-yet-synced local edits.
  final List<ArMeasurementResponse> arMeasurements;

  /// AI photo analysis runs (Phase 7.10) -- synced-only, same posture as
  /// [voiceNotes]/[signature]: never written optimistically, since there's
  /// nothing honest to echo before the AI call actually completes. The
  /// regions each run detected live in [annotations] as ordinary
  /// `source: "ai"` entries, not here.
  final List<AiAnalysisResponse> aiAnalysis;

  /// The server-synced voice-note references (Phase 7.6) -- same caching
  /// posture as [media]: refreshed only from a synced server response, since
  /// a voice note's bytes go through [MediaQueue]/`LocalMediaRepository`
  /// like a photo/video, not an optimistic local write.
  final List<VoiceNoteResponse> voiceNotes;

  /// Manual status readings (Phase 7.7) -- `null` means the readings step
  /// hasn't been filled in yet. Written optimistically at save time (see
  /// [LocalInspectionsRepository.updateInspection]), same posture as
  /// [annotations].
  final ReadingsResponse? readings;

  /// The server-confirmed digital signature (Phase 7.8) -- `null` until the
  /// inspector has signed and that signature has synced. See
  /// [pendingSignatureStrokes] for what to show in the meantime.
  final SignatureResponse? signature;

  /// The strokes drawn on-device for a signature that hasn't synced yet
  /// (survives an app restart). `null` once [signature] is populated, or if
  /// no signature has been drawn at all.
  final List<SignatureStrokeInput>? pendingSignatureStrokes;

  String get id => row.id;
  String get assetId => row.assetId;
  String? get facilityId => row.facilityId;
  String? get areaId => row.areaId;
  String get inspectorId => row.inspectorId;
  String get status => row.status;
  String get inspectionType => row.inspectionType;
  String? get title => row.title;
  String? get notes => row.notes;
  String? get checklistTemplateId => row.checklistTemplateId;
  int? get checklistTemplateVersion => row.checklistTemplateVersion;
  String? get assetCategory => row.assetCategory;
  DateTime? get startedAt => row.startedAt;
  DateTime? get completedAt => row.completedAt;
  double? get gpsLat => row.gpsLat;
  double? get gpsLng => row.gpsLng;
  DateTime get createdAt => row.createdAt;
  DateTime get updatedAt => row.updatedAt;
  int get revision => row.revision;
  LocalSyncState get syncState => LocalSyncState.fromWire(row.syncState);
  String? get errorMessage => row.errorMessage;
  DateTime? get lastAttemptAt => row.lastAttemptAt;

  InspectionDetail? get conflictServerSnapshot {
    final raw = row.conflictServerSnapshot;
    if (raw == null) return null;
    return standardSerializers.deserializeWith(
      InspectionDetail.serializer,
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }
}

/// A queued outbox mutation, for the pending-queue screen.
class OutboxItemRecord {
  OutboxItemRecord(this.row);

  final OutboxData row;

  String get id => row.id;
  String get inspectionId => row.inspectionId;
  OutboxMutationType get mutationType =>
      OutboxMutationType.fromWire(row.mutationType);
  int get attempts => row.attempts;
  String? get lastError => row.lastError;
  DateTime? get lastAttemptAt => row.lastAttemptAt;
  DateTime? get nextAttemptAt => row.nextAttemptAt;
}

/// Any outbox row with `nextAttemptAt` at/after this instant is considered
/// permanently paused (a non-retryable error) rather than backed off --
/// there's no separate "paused" column, so this sentinel repurposes the
/// existing backoff column instead of adding one just for this.
final DateTime pausedSentinel = DateTime.utc(9999);

/// Offline-first facade over the local Drift cache + outbox for inspections
/// (Phase 7.2). Read paths serve from the local cache and refresh from the
/// network best-effort; write paths always land locally first and enqueue a
/// matching outbox mutation for [SyncEngine] to replay. `_api` is used only
/// for the best-effort network refresh here -- actual mutation replay is
/// [SyncEngine]'s job, which calls the `apply*`/`mark*` methods below.
/// Extends [ChangeNotifier] purely so [SyncEngine] can recompute a plain,
/// one-shot outbox count after every write without holding its own
/// long-lived `watchOutbox()` subscription -- [ChangeNotifier]'s listener
/// list is plain callbacks, not a Stream, so it never touches Drift's
/// cancel-defers-to-a-Timer stream-query machinery (which is exactly what
/// made `flutter_test`'s pending-timer teardown check trip on almost every
/// widget test once the app shell always had a live outbox subscription).
/// `watchInspections`/`watchOutbox` below are still real Drift streams for
/// screens that render reactively; only this cross-cutting "did anything
/// change" signal avoids them.
class LocalInspectionsRepository extends ChangeNotifier {
  LocalInspectionsRepository(
      {required AppDatabase db, required ApiContract api, Uuid? uuid})
      : _db = db,
        _api = api,
        _uuid = uuid ?? const Uuid();

  final AppDatabase _db;
  final ApiContract _api;
  final Uuid _uuid;

  // ---------------------------------------------------------------- reads

  Stream<List<LocalInspectionRecord>> watchInspections(
      {String? assetId, String? status}) {
    final query = _db.select(_db.localInspections)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => drift.OrderingTerm.desc(t.updatedAt)]);
    if (assetId != null) query.where((t) => t.assetId.equals(assetId));
    if (status != null) query.where((t) => t.status.equals(status));
    return query
        .watch()
        .map((rows) => rows.map(LocalInspectionRecord.new).toList());
  }

  /// A plain one-shot read (not `.watch()`) -- for callers that just need
  /// the current row once, e.g. re-reading annotations right after a local
  /// write, without holding a Drift stream subscription open (see this
  /// class's own doc comment on why that trips `flutter_test`'s
  /// pending-timer check).
  Future<LocalInspectionRecord?> getInspection(String id) async {
    final row = await (_db.select(_db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : LocalInspectionRecord(row);
  }

  Stream<LocalInspectionRecord?> watchInspection(String id) {
    return (_db.select(_db.localInspections)..where((t) => t.id.equals(id)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : LocalInspectionRecord(row));
  }

  /// Best-effort: upserts server results as `synced`, skipping any row
  /// that's `pending_sync`/`conflict`/`error` locally so a background list
  /// refresh never clobbers an in-flight local edit. Swallows network
  /// errors -- callers keep whatever the local cache already has.
  Future<void> refreshFromNetwork({String? assetId, String? status}) async {
    try {
      final page = await _api.getInspections(
          assetId: assetId, status: status, limit: 100);
      for (final item in page.items) {
        await _upsertSyncedIfIdle(
          id: item.id,
          fetchDetail: () => _api.getInspection(item.id),
        );
      }
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  Future<void> refreshDetailFromNetwork(String id) async {
    try {
      await _upsertSyncedIfIdle(
          id: id, fetchDetail: () => _api.getInspection(id));
    } catch (_) {
      // Best-effort refresh; the local cache stays as-is.
    }
  }

  /// Runs Claude vision analysis on one already-synced photo (Phase 7.10) --
  /// a direct, immediate, ONLINE-ONLY call, never queued through the outbox
  /// like every other mutation in this repository: there is no sensible
  /// offline echo for an AI response that doesn't exist yet. Throws
  /// [ApiException] on failure (unsupported media kind, upstream AI
  /// failure, etc.) for the caller to surface; on success, upserts the
  /// returned detail so the reactive `watchInspection` stream picks up the
  /// new annotations/analysis immediately.
  Future<void> analyzeMedia(
      {required String inspectionId, required String mediaId}) async {
    final detail = await _api.analyzeInspectionMedia(inspectionId, mediaId);
    await _upsertFromServer(detail, syncState: LocalSyncState.synced);
  }

  /// Marks an AI analysis run as reviewed -- same direct, online-only
  /// posture as [analyzeMedia]. "Override" is just editing/deleting the
  /// underlying AI-sourced annotations via [updateAnnotation]/
  /// [deleteAnnotation]; no separate action exists for that.
  Future<void> reviewAiAnalysis(
      {required String inspectionId, required String analysisId}) async {
    final detail =
        await _api.reviewInspectionAiAnalysis(inspectionId, analysisId);
    await _upsertFromServer(detail, syncState: LocalSyncState.synced);
  }

  Future<void> _upsertSyncedIfIdle({
    required String id,
    required Future<InspectionDetail> Function() fetchDetail,
  }) async {
    final current = await (_db.select(_db.localInspections)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (current != null &&
        current.syncState != LocalSyncState.synced.wireValue &&
        current.syncState != LocalSyncState.localOnly.wireValue) {
      return;
    }
    final detail = await fetchDetail();
    await _upsertFromServer(detail, syncState: LocalSyncState.synced);
  }

  Future<void> _upsertFromServer(
    InspectionDetail detail, {
    required LocalSyncState syncState,
  }) async {
    await _db.into(_db.localInspections).insertOnConflictUpdate(
          LocalInspectionsCompanion.insert(
            id: detail.id,
            assetId: detail.assetId,
            facilityId: drift.Value(detail.facilityId),
            areaId: drift.Value(detail.areaId),
            inspectorId: detail.inspectorId,
            status: dartEnumNameToWire(detail.status.name),
            inspectionType: dartEnumNameToWire(detail.inspectionType.name),
            title: drift.Value(detail.title),
            notes: drift.Value(detail.notes),
            checklistTemplateId: drift.Value(detail.checklistTemplateId),
            checklistTemplateVersion:
                drift.Value(detail.checklistTemplateVersion),
            checklistItemsSnapshot: drift.Value(
              _encodeChecklistItems(
                  detail.checklistItemsSnapshot?.toList() ?? const []),
            ),
            checklistResponses: drift.Value(
              _encodeChecklistResponses(
                  detail.checklistResponses?.toList() ?? const []),
            ),
            media: drift.Value(
                _encodeInspectionMedia(detail.media?.toList() ?? const [])),
            annotations: drift.Value(
                _encodeAnnotations(detail.annotations?.toList() ?? const [])),
            arMeasurements: drift.Value(_encodeArMeasurements(
                detail.arMeasurements?.toList() ?? const [])),
            aiAnalysis: drift.Value(
                _encodeAiAnalysis(detail.aiAnalysis?.toList() ?? const [])),
            voiceNotes: drift.Value(
                _encodeVoiceNotes(detail.voiceNotes?.toList() ?? const [])),
            readings: drift.Value(_encodeReadings(detail.readings)),
            signature: drift.Value(_encodeSignature(detail.signature)),
            pendingSignatureStrokes: const drift.Value(null),
            startedAt: drift.Value(detail.startedAt),
            completedAt: drift.Value(detail.completedAt),
            gpsLat: drift.Value(detail.gpsLat?.toDouble()),
            gpsLng: drift.Value(detail.gpsLng?.toDouble()),
            clientCreatedAt: detail.clientCreatedAt,
            deviceId: drift.Value(detail.deviceId),
            origin: drift.Value(detail.origin),
            revision: drift.Value(detail.revision),
            createdAt: detail.createdAt,
            updatedAt: detail.updatedAt,
            syncState: drift.Value(syncState.wireValue),
            baseRevision: drift.Value(detail.revision),
            errorMessage: const drift.Value(null),
            conflictServerSnapshot: const drift.Value(null),
          ),
        );
  }

  // --------------------------------------------------------------- writes

  Future<String> createDraft({
    required String assetId,
    required String inspectorId,
    required String inspectionType,
    String? title,
    String? notes,
    double? gpsLat,
    double? gpsLng,
    String? assetCategory,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      await _db.into(_db.localInspections).insert(
            LocalInspectionsCompanion.insert(
              id: id,
              assetId: assetId,
              inspectorId: inspectorId,
              status: 'draft',
              inspectionType: inspectionType,
              title: drift.Value(title),
              notes: drift.Value(notes),
              gpsLat: drift.Value(gpsLat),
              gpsLng: drift.Value(gpsLng),
              assetCategory: drift.Value(assetCategory),
              clientCreatedAt: now,
              createdAt: now,
              updatedAt: now,
              syncState: const drift.Value('local_only'),
            ),
          );
      final request = CreateInspectionRequest(
        (b) => b
          ..id = id
          ..assetId = assetId
          ..inspectionType = CreateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(inspectionType),
          )
          ..title = title
          ..notes = notes
          ..gpsLat = gpsLat
          ..gpsLng = gpsLng
          ..clientCreatedAt = now,
      );
      await _enqueue(
        inspectionId: id,
        type: OutboxMutationType.create,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              CreateInspectionRequest.serializer, request),
        ),
      );
    });
    return id;
  }

  /// Merges the given fields over the current local row, marks it
  /// `pending_sync`, and coalesces into the existing not-yet-attempted
  /// `update` outbox row for this inspection (if any) rather than stacking
  /// a duplicate -- a row that already has `attempts > 0` is left alone
  /// (already in flight) and a fresh row is appended instead.
  Future<void> updateInspection(
    String id, {
    String? title,
    String? notes,
    String? inspectionType,
    double? gpsLat,
    double? gpsLng,
    List<ChecklistResponse>? checklistResponses,
    ReadingsInput? readings,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final mergedTitle = title ?? current.title;
      final mergedNotes = notes ?? current.notes;
      final mergedType = inspectionType ?? current.inspectionType;
      final mergedLat = gpsLat ?? current.gpsLat;
      final mergedLng = gpsLng ?? current.gpsLng;
      final mergedResponses = _mergeChecklistResponses(
        _decodeChecklistResponses(current.checklistResponses),
        checklistResponses,
      ).map(_normalizeResponseValue).toList();
      final mergedReadings = readings != null
          ? _readingsInputToLocalResponse(readings)
          : _decodeReadings(current.readings);

      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          title: drift.Value(mergedTitle),
          notes: drift.Value(mergedNotes),
          inspectionType: drift.Value(mergedType),
          gpsLat: drift.Value(mergedLat),
          gpsLng: drift.Value(mergedLng),
          checklistResponses:
              drift.Value(_encodeChecklistResponses(mergedResponses)),
          readings: drift.Value(_encodeReadings(mergedReadings)),
          updatedAt: drift.Value(DateTime.now().toUtc()),
          syncState: const drift.Value('pending_sync'),
        ),
      );

      final request = UpdateInspectionRequest(
        (b) => b
          ..title = mergedTitle
          ..notes = mergedNotes
          ..inspectionType = UpdateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(mergedType),
          )
          ..gpsLat = mergedLat
          ..gpsLng = mergedLng
          ..checklistResponses.replace(mergedResponses)
          ..readings = mergedReadings == null
              ? null
              : _readingsResponseToInput(mergedReadings).toBuilder()
          ..expectedRevision = current.baseRevision,
      );
      final payload = jsonEncode(
        standardSerializers.serializeWith(
            UpdateInspectionRequest.serializer, request),
      );

      final coalesceTarget = await (_db.select(_db.outbox)
            ..where(
              (t) =>
                  t.inspectionId.equals(id) &
                  t.mutationType.equals(OutboxMutationType.update.wireValue) &
                  t.attempts.equals(0),
            ))
          .getSingleOrNull();
      if (coalesceTarget != null) {
        await (_db.update(_db.outbox)
              ..where((t) => t.id.equals(coalesceTarget.id)))
            .write(OutboxCompanion(payload: drift.Value(payload)));
      } else {
        await _enqueue(
            inspectionId: id,
            type: OutboxMutationType.update,
            payload: payload);
      }
    });
  }

  Future<void> startInspection(String id) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          status: const drift.Value('in_progress'),
          startedAt: drift.Value(current.startedAt ?? now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(
          inspectionId: id, type: OutboxMutationType.start, payload: '{}');
    });
  }

  /// Signature capture is the final step of completion (Phase 7.8) -- there
  /// is no separate sign-then-complete method. [strokes] is bound to
  /// [LocalInspection.baseRevision] (falling back to [LocalInspection.
  /// revision] for a `local_only` draft that has never reached the server)
  /// exactly like [updateInspection]'s `expectedRevision`: if the server has
  /// since moved past that revision, the sync engine's existing
  /// `revision_conflict` handling (`SyncEngine._handleConflictOrInvalidTransition`)
  /// rejects it and surfaces the standard conflict sheet -- the offline
  /// pre-completion race the phase brief calls "edited after signing".
  Future<void> completeInspection(
    String id, {
    required List<SignatureStrokeInput> strokes,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final items = _decodeChecklistItems(current.checklistItemsSnapshot);
      final responses = _decodeChecklistResponses(current.checklistResponses);
      final missing = missingRequiredItemIds(items, responses);
      if (missing.isNotEmpty) throw ChecklistIncompleteError(missing);

      final now = DateTime.now().toUtc();
      final expectedRevision = current.baseRevision ?? current.revision;
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          status: const drift.Value('completed'),
          completedAt: drift.Value(now),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
          pendingSignatureStrokes:
              drift.Value(_encodeSignatureStrokes(strokes)),
        ),
      );
      final request = CompleteInspectionRequest(
        (b) => b
          ..expectedRevision = expectedRevision
          ..strokes.replace(strokes),
      );
      await _enqueue(
        inspectionId: id,
        type: OutboxMutationType.complete,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              CompleteInspectionRequest.serializer, request),
        ),
      );
    });
  }

  Future<void> cancelInspection(String id) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          status: const drift.Value('cancelled'),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      await _enqueue(
          inspectionId: id, type: OutboxMutationType.cancel, payload: '{}');
    });
  }

  Future<void> assignChecklistTemplate(
    String id, {
    required String templateId,
    required int version,
    required List<ChecklistTemplateItem> items,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final now = DateTime.now().toUtc();
      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          checklistTemplateId: drift.Value(templateId),
          checklistTemplateVersion: drift.Value(version),
          checklistItemsSnapshot: drift.Value(_encodeChecklistItems(items)),
          updatedAt: drift.Value(now),
          syncState: const drift.Value('pending_sync'),
        ),
      );
      final request = AssignChecklistTemplateRequest(
        (b) => b
          ..checklistTemplateId = templateId
          ..expectedRevision = current.baseRevision,
      );
      final payload = jsonEncode(
        standardSerializers.serializeWith(
            AssignChecklistTemplateRequest.serializer, request),
      );
      await _enqueue(
          inspectionId: id,
          type: OutboxMutationType.assignTemplate,
          payload: payload);
    });
  }

  // ------------------------------------------------------------- media (7.4)

  /// Enqueues the small metadata-reference mutation onto the *existing*
  /// inspection outbox once [MediaUploadWorker] has already uploaded the
  /// bytes directly to Storage -- this is the "small reference, not the
  /// bytes" sync path the media queue design depends on.
  Future<void> enqueueAttachMedia({
    required String inspectionId,
    required AttachInspectionMediaRequest request,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.attachMedia,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              AttachInspectionMediaRequest.serializer, request),
        ),
      );

  Future<void> enqueueEditMedia({
    required String inspectionId,
    required String mediaId,
    required UpdateInspectionMediaRequest request,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.editMedia,
        payload: jsonEncode({
          'media_id': mediaId,
          'request': standardSerializers.serializeWith(
              UpdateInspectionMediaRequest.serializer, request),
        }),
      );

  Future<void> enqueueDetachMedia({
    required String inspectionId,
    required String mediaId,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.detachMedia,
        payload: jsonEncode({'media_id': mediaId}),
      );

  // ------------------------------------------------------- voice notes (7.6)

  /// Mirrors [enqueueAttachMedia] -- registers the small metadata reference
  /// once [MediaUploadWorker] has already uploaded the recording's bytes
  /// directly to Storage.
  Future<void> enqueueAttachVoiceNote({
    required String inspectionId,
    required AttachVoiceNoteRequest request,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.attachVoiceNote,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              AttachVoiceNoteRequest.serializer, request),
        ),
      );

  Future<void> enqueueEditVoiceNote({
    required String inspectionId,
    required String voiceNoteId,
    required UpdateVoiceNoteRequest request,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.editVoiceNote,
        payload: jsonEncode({
          'voice_note_id': voiceNoteId,
          'request': standardSerializers.serializeWith(
              UpdateVoiceNoteRequest.serializer, request),
        }),
      );

  Future<void> enqueueDetachVoiceNote({
    required String inspectionId,
    required String voiceNoteId,
  }) =>
      _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.detachVoiceNote,
        payload: jsonEncode({'voice_note_id': voiceNoteId}),
      );

  // -------------------------------------------------------- annotations (7.5)

  /// Draws a new annotation on the photo identified by [mediaLocalId] and
  /// persists it immediately -- an optimistic write to the local
  /// `annotations` blob, same offline-first posture as every other local
  /// write in this repository. Unlike media, an annotation is small vector
  /// data with no separate upload queue standing between "drawn" and
  /// "visible offline", so it goes straight into the same record + outbox
  /// [enqueueAttachMedia] etc. use, never [MediaQueue].
  Future<String> createAnnotation({
    required String inspectionId,
    required String mediaLocalId,
    required String shape,
    required List<AnnotationPointResponse> points,
    required String color,
    required String createdBy,
    String? damageType,
    String? note,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final annotation = AnnotationResponse(
        (b) => b
          ..id = id
          ..mediaLocalId = mediaLocalId
          ..shape =
              AnnotationResponseShapeEnum.valueOf(wireToDartEnumName(shape))
          ..points.replace(points)
          ..color = color
          ..damageType = damageType == null
              ? null
              : AnnotationResponseDamageTypeEnum.valueOf(
                  wireToDartEnumName(damageType))
          ..note = note
          ..source_ = AnnotationResponseSource_Enum.manual
          ..createdBy = createdBy
          ..createdAt = now,
      );
      final updatedAnnotations = [
        ..._decodeAnnotations(current.annotations),
        annotation
      ];
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            annotations: drift.Value(_encodeAnnotations(updatedAnnotations))),
      );

      final request = CreateAnnotationRequest(
        (b) => b
          ..id = id
          ..mediaLocalId = mediaLocalId
          ..shape = CreateAnnotationRequestShapeEnum.valueOf(
              wireToDartEnumName(shape))
          ..points.replace(points.map((p) => AnnotationPointInput((pb) => pb
            ..x = p.x
            ..y = p.y)))
          ..color = color
          ..damageType = damageType == null
              ? null
              : CreateAnnotationRequestDamageTypeEnum.valueOf(
                  wireToDartEnumName(damageType))
          ..note = note,
      );
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.createAnnotation,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              CreateAnnotationRequest.serializer, request),
        ),
      );
    });
    return id;
  }

  /// Edits an existing annotation's shape/color/damage type/note -- `null`
  /// arguments leave that field unchanged, same convention as
  /// [updateInspection]'s `title`/`notes`. A no-op if [annotationId] isn't
  /// found locally (e.g. it was already deleted).
  Future<void> updateAnnotation({
    required String inspectionId,
    required String annotationId,
    List<AnnotationPointResponse>? points,
    String? color,
    String? damageType,
    String? note,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final existingAnnotations = _decodeAnnotations(current.annotations);
      final index = existingAnnotations.indexWhere((a) => a.id == annotationId);
      if (index == -1) return;

      final updatedAnnotation = existingAnnotations[index].rebuild((b) {
        if (points != null) b.points.replace(points);
        if (color != null) b.color = color;
        if (damageType != null) {
          b.damageType = AnnotationResponseDamageTypeEnum.valueOf(
              wireToDartEnumName(damageType));
        }
        if (note != null) b.note = note;
      });
      final updatedAnnotations = [...existingAnnotations];
      updatedAnnotations[index] = updatedAnnotation;
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            annotations: drift.Value(_encodeAnnotations(updatedAnnotations))),
      );

      final request = UpdateAnnotationRequest((b) {
        if (points != null) {
          b.points.replace(points.map((p) => AnnotationPointInput((pb) => pb
            ..x = p.x
            ..y = p.y)));
        }
        if (color != null) b.color = color;
        if (damageType != null) {
          b.damageType = UpdateAnnotationRequestDamageTypeEnum.valueOf(
              wireToDartEnumName(damageType));
        }
        if (note != null) b.note = note;
      });
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.updateAnnotation,
        payload: jsonEncode({
          'annotation_id': annotationId,
          'request': standardSerializers.serializeWith(
              UpdateAnnotationRequest.serializer, request),
        }),
      );
    });
  }

  /// Removes an annotation -- idempotent-on-missing locally, same posture as
  /// [enqueueDetachMedia].
  Future<void> deleteAnnotation({
    required String inspectionId,
    required String annotationId,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final remaining = _decodeAnnotations(current.annotations)
          .where((a) => a.id != annotationId)
          .toList();
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            annotations: drift.Value(_encodeAnnotations(remaining))),
      );
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.deleteAnnotation,
        payload: jsonEncode({'annotation_id': annotationId}),
      );
    });
  }

  // ------------------------------------------------ AR/manual measurements (7.9)

  /// Records a new dimension measurement -- either AR-captured (`method:
  /// 'ar'`, always carrying [mediaLocalId] + exactly two [points] marking
  /// the screenshot it was measured on) or manually entered (`method:
  /// 'manual'`, [mediaLocalId]/[points] optional). Persists immediately to
  /// the local `ar_measurements` blob, same optimistic offline-first posture
  /// as [createAnnotation] -- small metadata with no separate upload queue
  /// standing between "measured" and "visible offline" (D-063).
  Future<String> createMeasurement({
    required String inspectionId,
    required String method,
    required double distanceMeters,
    required String createdBy,
    String? label,
    String? mediaLocalId,
    List<AnnotationPointResponse> points = const [],
    String? note,
    String? checklistItemId,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now().toUtc();
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final measurement = ArMeasurementResponse(
        (b) => b
          ..id = id
          ..method = ArMeasurementResponseMethodEnum.valueOf(method)
          ..distanceMeters = distanceMeters
          ..label = label
          ..mediaLocalId = mediaLocalId
          ..points.replace(points)
          ..note = note
          ..checklistItemId = checklistItemId
          ..createdBy = createdBy
          ..createdAt = now,
      );
      final updatedMeasurements = [
        ..._decodeArMeasurements(current.arMeasurements),
        measurement
      ];
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            arMeasurements:
                drift.Value(_encodeArMeasurements(updatedMeasurements))),
      );

      final request = CreateArMeasurementRequest(
        (b) => b
          ..id = id
          ..method = CreateArMeasurementRequestMethodEnum.valueOf(method)
          ..distanceMeters = distanceMeters
          ..label = label
          ..mediaLocalId = mediaLocalId
          ..points.replace(points.map((p) => AnnotationPointInput((pb) => pb
            ..x = p.x
            ..y = p.y)))
          ..note = note
          ..checklistItemId = checklistItemId,
      );
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.createMeasurement,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              CreateArMeasurementRequest.serializer, request),
        ),
      );
    });
    return id;
  }

  /// Edits an existing measurement's label/note/checklist link -- `null`
  /// arguments leave that field unchanged. The captured method/distance/
  /// screenshot/points are immutable once created (delete and recreate to
  /// fix a wrong value). A no-op if [measurementId] isn't found locally.
  Future<void> updateMeasurement({
    required String inspectionId,
    required String measurementId,
    String? label,
    String? note,
    String? checklistItemId,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final existingMeasurements =
          _decodeArMeasurements(current.arMeasurements);
      final index =
          existingMeasurements.indexWhere((m) => m.id == measurementId);
      if (index == -1) return;

      final updatedMeasurement = existingMeasurements[index].rebuild((b) {
        if (label != null) b.label = label;
        if (note != null) b.note = note;
        if (checklistItemId != null) b.checklistItemId = checklistItemId;
      });
      final updatedMeasurements = [...existingMeasurements];
      updatedMeasurements[index] = updatedMeasurement;
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            arMeasurements:
                drift.Value(_encodeArMeasurements(updatedMeasurements))),
      );

      final request = UpdateArMeasurementRequest((b) {
        if (label != null) b.label = label;
        if (note != null) b.note = note;
        if (checklistItemId != null) b.checklistItemId = checklistItemId;
      });
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.updateMeasurement,
        payload: jsonEncode({
          'measurement_id': measurementId,
          'request': standardSerializers.serializeWith(
              UpdateArMeasurementRequest.serializer, request),
        }),
      );
    });
  }

  /// Removes a measurement -- idempotent-on-missing locally, same posture as
  /// [deleteAnnotation].
  Future<void> deleteMeasurement({
    required String inspectionId,
    required String measurementId,
  }) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .getSingle();
      final remaining = _decodeArMeasurements(current.arMeasurements)
          .where((m) => m.id != measurementId)
          .toList();
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
            arMeasurements: drift.Value(_encodeArMeasurements(remaining))),
      );
      await _enqueue(
        inspectionId: inspectionId,
        type: OutboxMutationType.deleteMeasurement,
        payload: jsonEncode({'measurement_id': measurementId}),
      );
    });
  }

  // ------------------------------------------------------ checklist templates

  /// Best-effort background refresh of the company's checklist templates
  /// (Phase 7.3), so template auto-selection at inspection-start time can
  /// run entirely from the local cache -- no network round trip in that
  /// critical path, matching the offline-first shape of everything else in
  /// this repository. Call after sign-in resolves; swallows every failure
  /// (a stale or empty cache just means auto-selection finds no match).
  Future<void> refreshChecklistTemplatesFromNetwork() async {
    try {
      final page = await _api.getChecklistTemplates(limit: 100);
      for (final summary in page.items) {
        final detail = await _api.getChecklistTemplate(summary.id);
        await _db.into(_db.localChecklistTemplates).insertOnConflictUpdate(
              LocalChecklistTemplatesCompanion.insert(
                id: detail.id,
                category: detail.category,
                name: detail.name,
                version: detail.version,
                itemsJson: drift.Value(
                  _encodeChecklistItems(detail.items?.toList() ?? const []),
                ),
                updatedAt: detail.updatedAt,
              ),
            );
      }
    } catch (_) {
      // Best-effort refresh; auto-selection just works with whatever's cached.
    }
  }

  /// Picks the checklist template to auto-assign for [assetCategory]: the
  /// most-recently-updated active template matching that category, falling
  /// back to the most-recently-updated `Generic` template, or `null` if
  /// neither exists locally yet. Entirely local/synchronous -- no network
  /// dependency, so this works under airplane mode as long as
  /// [refreshChecklistTemplatesFromNetwork] ran at least once while online.
  Future<LocalChecklistTemplate?> selectChecklistTemplateForCategory(
    String assetCategory,
  ) async {
    final byCategory = await _bestTemplateForCategory(assetCategory);
    if (byCategory != null) return byCategory;
    if (assetCategory == 'Generic') return null;
    return _bestTemplateForCategory('Generic');
  }

  Future<LocalChecklistTemplate?> _bestTemplateForCategory(
      String category) async {
    final query = _db.select(_db.localChecklistTemplates)
      ..where((t) => t.category.equals(category))
      ..orderBy([(t) => drift.OrderingTerm.desc(t.updatedAt)])
      ..limit(1);
    return query.getSingleOrNull();
  }

  /// Decodes a cached [LocalChecklistTemplate]'s items for
  /// [assignChecklistTemplate] -- callers only ever get a template row from
  /// [selectChecklistTemplateForCategory], never construct one themselves.
  List<ChecklistTemplateItem> decodeTemplateItems(
          LocalChecklistTemplate template) =>
      _decodeChecklistItems(template.itemsJson);

  /// `keepLocal`: requeues the local edit as a fresh `update` against the
  /// conflict snapshot's revision. `!keepLocal`: overwrites the local row
  /// from [LocalInspectionRecord.conflictServerSnapshot] and drops every
  /// queued mutation for this inspection -- the user explicitly chose to
  /// discard the local edit, so replaying it would be exactly the silent
  /// data loss this flow exists to prevent.
  Future<void> resolveConflict(String id, {required bool keepLocal}) async {
    await _db.transaction(() async {
      final current = await (_db.select(_db.localInspections)
            ..where((t) => t.id.equals(id)))
          .getSingle();
      final snapshotJson = current.conflictServerSnapshot;
      if (snapshotJson == null) return;
      final snapshot = standardSerializers.deserializeWith(
        InspectionDetail.serializer,
        jsonDecode(snapshotJson) as Map<String, dynamic>,
      )!;

      if (!keepLocal) {
        await (_db.delete(_db.outbox)..where((t) => t.inspectionId.equals(id)))
            .go();
        await _upsertFromServer(snapshot, syncState: LocalSyncState.synced);
        notifyListeners();
        return;
      }

      await (_db.update(_db.localInspections)..where((t) => t.id.equals(id)))
          .write(
        LocalInspectionsCompanion(
          revision: drift.Value(snapshot.revision),
          baseRevision: drift.Value(snapshot.revision),
          syncState: const drift.Value('pending_sync'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: const drift.Value(null),
        ),
      );
      final request = UpdateInspectionRequest(
        (b) => b
          ..title = current.title
          ..notes = current.notes
          ..inspectionType = UpdateInspectionRequestInspectionTypeEnum.valueOf(
            wireToDartEnumName(current.inspectionType),
          )
          ..gpsLat = current.gpsLat
          ..gpsLng = current.gpsLng
          ..checklistResponses.replace(
            _decodeChecklistResponses(current.checklistResponses)
                .map(_normalizeResponseValue),
          )
          ..expectedRevision = snapshot.revision,
      );
      await _enqueue(
        inspectionId: id,
        type: OutboxMutationType.update,
        payload: jsonEncode(
          standardSerializers.serializeWith(
              UpdateInspectionRequest.serializer, request),
        ),
      );
    });
  }

  // -------------------------------------------------------------- outbox

  Stream<List<OutboxItemRecord>> watchOutbox() {
    return (_db.select(_db.outbox)
          ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]))
        .watch()
        .map((rows) => rows.map(OutboxItemRecord.new).toList());
  }

  /// A plain one-shot count (not a watch stream) -- for [SyncEngine]'s
  /// [ChangeNotifier]-driven recount, which must never hold its own live
  /// Drift query subscription open (see the constructor's comment).
  Future<int> outboxCount() async {
    final rows = await _db.select(_db.outbox).get();
    return rows.length;
  }

  /// Clears backoff (and any paused-by-permanent-error state) so the next
  /// drain pass picks this row up immediately, bypassing whatever wait it
  /// was under.
  Future<void> retryOutboxItem(String outboxId) async {
    await (_db.update(_db.outbox)..where((t) => t.id.equals(outboxId))).write(
      const OutboxCompanion(nextAttemptAt: drift.Value(null)),
    );
    notifyListeners();
  }

  Future<void> discardOutboxItem(String outboxId) async {
    await _db.transaction(() async {
      final item = await (_db.select(_db.outbox)
            ..where((t) => t.id.equals(outboxId)))
          .getSingleOrNull();
      if (item == null) return;
      await (_db.delete(_db.outbox)..where((t) => t.id.equals(outboxId))).go();
      final remaining = await (_db.select(_db.outbox)
            ..where((t) => t.inspectionId.equals(item.inspectionId)))
          .get();
      if (remaining.isEmpty) {
        await (_db.update(_db.localInspections)
              ..where((t) => t.id.equals(item.inspectionId)))
            .write(
          const LocalInspectionsCompanion(
            syncState: drift.Value('error'),
            errorMessage: drift.Value(
              'A pending change was discarded and never reached the server.',
            ),
          ),
        );
      }
    });
    notifyListeners();
  }

  Future<void> _enqueue({
    required String inspectionId,
    required OutboxMutationType type,
    required String payload,
  }) async {
    await _db.into(_db.outbox).insert(
          OutboxCompanion.insert(
            id: _uuid.v4(),
            inspectionId: inspectionId,
            mutationType: type.wireValue,
            payload: payload,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    notifyListeners();
  }

  // ------------------------------------------------------ sync-engine API

  /// Outbox rows due for replay, oldest-first. "Due" excludes both an
  /// active backoff window and the [pausedSentinel] a permanent error sets.
  /// `bypassBackoff: true` (manual "Sync now") skips the backoff wait but
  /// still respects [pausedSentinel] -- a permanently-failed row still
  /// needs an explicit per-item retry, not a bulk "sync now".
  Future<List<OutboxItemRecord>> queueForDrain({
    required DateTime now,
    bool bypassBackoff = false,
  }) async {
    final query = _db.select(_db.outbox)
      ..orderBy([(t) => drift.OrderingTerm.asc(t.sequence)]);
    if (bypassBackoff) {
      query.where((t) =>
          t.nextAttemptAt.isNull() |
          t.nextAttemptAt.isSmallerThanValue(pausedSentinel));
    } else {
      query.where((t) =>
          t.nextAttemptAt.isNull() |
          t.nextAttemptAt.isSmallerOrEqualValue(now));
    }
    final rows = await query.get();
    return rows.map(OutboxItemRecord.new).toList();
  }

  /// A mutation round-tripped successfully. Deletes the outbox row; if no
  /// other outbox rows remain queued for this inspection, the local row
  /// becomes `synced` with the server's authoritative fields -- otherwise
  /// it stays `pending_sync` (more mutations are still queued) but still
  /// picks up the server's now-current revision/fields.
  Future<void> applyMutationSuccess({
    required OutboxItemRecord item,
    required InspectionDetail server,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.outbox)..where((t) => t.id.equals(item.id))).go();
      final remaining = await (_db.select(_db.outbox)
            ..where((t) => t.inspectionId.equals(item.inspectionId)))
          .get();
      await _upsertFromServer(
        server,
        syncState: remaining.isEmpty
            ? LocalSyncState.synced
            : LocalSyncState.pendingSync,
      );
    });
    notifyListeners();
  }

  Future<void> markTransientFailure(
    OutboxItemRecord item, {
    required String message,
    required DateTime nextAttemptAt,
  }) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.outbox)..where((t) => t.id.equals(item.id))).write(
        OutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(nextAttemptAt),
        ),
      );
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(item.inspectionId)))
          .write(
        LocalInspectionsCompanion(
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  /// A non-retryable failure (validation error, 404, etc.). The outbox row
  /// stays (for manual retry/discard) but is paused via [pausedSentinel] so
  /// the drain loop doesn't immediately retry a mutation that can't
  /// possibly succeed as-is.
  Future<void> markPermanentError(OutboxItemRecord item,
      {required String message}) async {
    await _db.transaction(() async {
      final now = DateTime.now().toUtc();
      await (_db.update(_db.outbox)..where((t) => t.id.equals(item.id))).write(
        OutboxCompanion(
          attempts: drift.Value(item.attempts + 1),
          lastAttemptAt: drift.Value(now),
          lastError: drift.Value(message),
          nextAttemptAt: drift.Value(pausedSentinel),
        ),
      );
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(item.inspectionId)))
          .write(
        LocalInspectionsCompanion(
          syncState: const drift.Value('error'),
          lastAttemptAt: drift.Value(now),
          errorMessage: drift.Value(message),
        ),
      );
    });
    notifyListeners();
  }

  /// The mutation raced a change already applied elsewhere (stale
  /// `expected_revision`/status). Every other queued mutation for this
  /// inspection is dropped too -- they were all computed against the same
  /// now-stale base and would only conflict again -- and the local row
  /// surfaces the conflict for the user to resolve via [resolveConflict].
  Future<void> markConflict({
    required String inspectionId,
    required InspectionDetail serverSnapshot,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(_db.outbox)
            ..where((t) => t.inspectionId.equals(inspectionId)))
          .go();
      await (_db.update(_db.localInspections)
            ..where((t) => t.id.equals(inspectionId)))
          .write(
        LocalInspectionsCompanion(
          // A conflict means every optimistic local write for this
          // inspection is suspect -- including a `complete`'s optimistic
          // status flip, which never actually landed server-side if this
          // conflict came from a stale-revision signature (Phase 7.8). Sync
          // status/timestamps from the fresh snapshot now rather than leave
          // a false "completed" showing: the inspector then sees the real
          // (e.g. `in_progress`) status and re-signs via the normal
          // Complete button, which is the whole re-sign flow.
          status: drift.Value(dartEnumNameToWire(serverSnapshot.status.name)),
          startedAt: drift.Value(serverSnapshot.startedAt),
          completedAt: drift.Value(serverSnapshot.completedAt),
          pendingSignatureStrokes: const drift.Value(null),
          syncState: const drift.Value('conflict'),
          errorMessage: const drift.Value(null),
          conflictServerSnapshot: drift.Value(
            jsonEncode(standardSerializers.serializeWith(
                InspectionDetail.serializer, serverSnapshot)),
          ),
        ),
      );
    });
    notifyListeners();
  }

  /// A replayed mutation's target already matches what the mutation was
  /// trying to set -- i.e. it actually succeeded before the app died
  /// mid-request, and this is a retry of that same attempt. Treated as
  /// success, not a conflict.
  Future<void> applyAlreadyApplied({
    required OutboxItemRecord item,
    required InspectionDetail server,
  }) =>
      applyMutationSuccess(item: item, server: server);

  // ------------------------------------------------------------- session

  static const _ownerUidKey = 'fev_offline_data_owner_uid';

  Future<void> wipeAllLocalData() async {
    await _db.transaction(() async {
      await _db.delete(_db.outbox).go();
      await _db.delete(_db.localInspections).go();
      // Phase 7.4: the media queue is tenant-scoped local data too, and must
      // not survive a shared-device owner switch any more than the outbox does.
      await _db.delete(_db.mediaQueue).go();
    });
    notifyListeners();
  }

  /// Compares [uid] to whichever uid last owned this device's local cache
  /// (persisted in `shared_preferences`, independent of Firebase's own
  /// session storage). A different uid wipes local inspections+outbox --
  /// the shared-device tenant boundary (D-004) -- while a same-user
  /// re-sign-in, an app restart, or a token refresh is always a no-op.
  /// Call this after every successful auth resolution, not just sign-out,
  /// since sign-out alone doesn't know who's signing in next.
  Future<void> reconcileSessionOwner(String uid) async {
    final preferences = await SharedPreferences.getInstance();
    final lastOwner = preferences.getString(_ownerUidKey);
    if (lastOwner != null && lastOwner != uid) {
      await wipeAllLocalData();
    }
    await preferences.setString(_ownerUidKey, uid);
  }
}
