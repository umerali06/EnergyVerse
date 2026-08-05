import 'package:drift/drift.dart';

/// Local cache of inspection records (Phase 7.2). Mirrors the server's
/// `InspectionDetail` fields closely enough to render every read path
/// offline, plus a handful of LOCAL-ONLY columns (`syncState`,
/// `baseRevision`, `errorMessage`, `lastAttemptAt`, `conflictServerSnapshot`)
/// that have no server equivalent and exist purely to drive the sync engine
/// and its UI. `checklistItemsSnapshot`/`checklistResponses` are stored as
/// JSON blobs rather than normalized child tables: the server itself never
/// queries them relationally (see `apps/api/app/db/repositories/
/// inspections.py`), they're small, and a JSON blob lets a local edit
/// replace the whole array with one row UPDATE instead of a multi-table
/// transaction.
class LocalInspections extends Table {
  TextColumn get id => text()();
  TextColumn get assetId => text()();
  TextColumn get facilityId => text().nullable()();
  TextColumn get areaId => text().nullable()();
  TextColumn get inspectorId => text()();
  TextColumn get status => text()();
  TextColumn get inspectionType => text()();
  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get checklistTemplateId => text().nullable()();
  IntColumn get checklistTemplateVersion => integer().nullable()();

  /// The asset's category at draft-creation time (LOCAL ONLY -- never sent to
  /// the server, which already knows it via `asset_id`). Lets Phase 7.3's
  /// checklist-template auto-selection run entirely offline when the detail
  /// screen loads, without a network fetch of the asset itself.
  TextColumn get assetCategory => text().nullable()();
  TextColumn get checklistItemsSnapshot =>
      text().withDefault(const Constant('[]'))();
  TextColumn get checklistResponses =>
      text().withDefault(const Constant('[]'))();

  /// The server's `InspectionDetail.media[]` (Phase 7.4), same JSON-blob
  /// convention -- cached locally so the gallery (GPS/timestamp/tags/
  /// checklist-item link) renders fully offline; only the signed `url`
  /// itself needs connectivity to actually load an image/video.
  TextColumn get media => text().withDefault(const Constant('[]'))();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  RealColumn get gpsLat => real().nullable()();
  RealColumn get gpsLng => real().nullable()();
  DateTimeColumn get clientCreatedAt => dateTime()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get origin => text().nullable()();

  /// Server's last-known revision. 0 for a `local_only` draft that has
  /// never reached the server (the server always starts a real record at 1).
  IntColumn get revision => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// `local_only | pending_sync | synced | conflict | error` — LOCAL ONLY.
  TextColumn get syncState =>
      text().withDefault(const Constant('local_only'))();

  /// The revision this local copy was last confirmed to match on the
  /// server; used as `expected_revision` on the next mutation. Distinct
  /// from [revision] because a `local_only` draft has no server revision
  /// at all yet (null), while [revision] defaults to 0.
  IntColumn get baseRevision => integer().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  /// Full server `InspectionDetail` JSON fetched at conflict time, so
  /// "discard mine, use server's" has something to restore from without a
  /// second round trip.
  TextColumn get conflictServerSnapshot => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A local, best-effort cache of the company's checklist templates (Phase
/// 7.3) -- refreshed opportunistically (after sign-in) so a field inspector
/// who was online at some point today can still have a matching template
/// auto-selected and snapshotted entirely offline. `itemsJson` mirrors
/// `LocalInspections.checklistItemsSnapshot`'s JSON-blob convention: the
/// full item list is small and never queried relationally.
class LocalChecklistTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get category => text()();
  TextColumn get name => text()();
  IntColumn get version => integer()();
  TextColumn get itemsJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// The pending-mutation queue. `sequence` (not [id]) is the SQLite
/// rowid/autoincrement column and therefore the FIFO drain order — the
/// locked design replays mutations strictly one at a time, globally across
/// all inspections, in the order they were queued.
class Outbox extends Table {
  IntColumn get sequence => integer().autoIncrement()();

  /// A fresh UUID per outbox row (not the inspection id — one inspection
  /// can have several queued mutations over time).
  TextColumn get id => text().unique()();
  TextColumn get inspectionId => text()();

  /// `create | update | start | complete | cancel | assign_template |
  /// attach_media | edit_media | detach_media`. The last three are Phase
  /// 7.4's small metadata-reference mutations only -- the media BYTES never
  /// flow through this outbox; they upload directly to Firebase Storage via
  /// the separate [MediaQueue] table and `MediaUploadWorker`, independent of
  /// `SyncEngine`, so heavy media traffic can never stall lightweight
  /// inspection-record sync. (A prior `upload_media` reservation comment
  /// here anticipated a single combined queue; this supersedes that design.)
  TextColumn get mutationType => text()();

  /// The built_value request object, serialized to JSON via the generated
  /// `standardSerializers` from `package:fev_api_client`.
  TextColumn get payload => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  /// Backoff scheduling: the drain loop skips a row until
  /// `nextAttemptAt IS NULL OR nextAttemptAt <= now`, rather than
  /// hot-looping on a still-backing-off row while other rows could drain.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
}

/// The pending MEDIA-upload queue (Phase 7.4) -- deliberately SEPARATE from
/// [Outbox]: media bytes are heavy (a video can be hundreds of MB) and must
/// never share a drain loop with the lightweight inspection-record
/// mutations above. [MediaUploadWorker] drains this table independently of
/// `SyncEngine`; once a file finishes uploading directly to Firebase
/// Storage, only its small metadata reference is enqueued onto [Outbox] (an
/// `attach_media`/`edit_media`/`detach_media` row) to sync into
/// `inspection.media[]`.
class MediaQueue extends Table {
  /// Client-generated UUID; also the Storage object path's uuid segment
  /// (`companies/{cid}/inspections/{iid}/media/{localId}_{filename}`) and
  /// the idempotency key the backend's attach endpoint dedupes on.
  TextColumn get localId => text()();
  TextColumn get inspectionId => text()();
  TextColumn get checklistItemId => text().nullable()();
  TextColumn get kind => text()(); // 'photo' | 'video'
  TextColumn get localFilePath => text()();

  /// Computed at capture time via a Dart port of the backend's
  /// `InspectionMediaStorage.object_path()` formula -- deterministic, no
  /// server round trip needed before an upload can start.
  TextColumn get storagePath => text()();
  TextColumn get filename => text()();
  TextColumn get contentType => text()();
  IntColumn get sizeBytes => integer()();
  RealColumn get gpsLat => real().nullable()();
  RealColumn get gpsLng => real().nullable()();
  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get beforeAfterTag => text().nullable()(); // 'before' | 'after' | null

  /// `queued | uploading | uploaded | referenced | failed`.
  TextColumn get uploadState =>
      text().withDefault(const Constant('queued'))();

  /// UI progress only, via `UploadTask.snapshotEvents` -- NOT resumed across
  /// an app restart (D-0xx: resumability is Firebase Storage's own
  /// within-session resumable protocol, not custom byte-offset persistence).
  IntColumn get uploadedBytes => integer().withDefault(const Constant(0))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();

  /// Same backoff-window convention as [Outbox.nextAttemptAt].
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {localId};
}
