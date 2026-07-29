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
  TextColumn get checklistItemsSnapshot =>
      text().withDefault(const Constant('[]'))();
  TextColumn get checklistResponses =>
      text().withDefault(const Constant('[]'))();
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

  /// `create | update | start | complete | cancel | assign_template`.
  /// `upload_media` is reserved for 7.4+, not implemented here.
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
