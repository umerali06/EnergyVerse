import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [LocalInspections, Outbox, LocalChecklistTemplates, MediaQueue],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // v2 (Phase 7.3): a local-only `assetCategory` column on
        // LocalInspections (for fully-offline checklist-template
        // auto-selection) and the new LocalChecklistTemplates cache table.
        // v3 (Phase 7.4): the separate MediaQueue table, plus a `media`
        // JSON-blob column on LocalInspections caching the server's synced
        // `inspection.media[]` for fully-offline gallery viewing.
        // v4 (Phase 7.5): an `annotations` JSON-blob column on
        // LocalInspections caching (and, for not-yet-synced shapes,
        // optimistically holding) the inspection's damage annotations.
        // v5 (Phase 7.6): a `durationMs` column on MediaQueue (voice notes
        // reuse the same media queue/worker, kind == 'audio') and a
        // `voiceNotes` JSON-blob column on LocalInspections caching the
        // server's synced `inspection.voiceNotes[]`.
        // v6 (Phase 7.7): a nullable `readings` JSON-blob column on
        // LocalInspections caching (and, for not-yet-synced edits,
        // optimistically holding) the inspection's manual status readings.
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(localInspections, localInspections.assetCategory);
            await m.createTable(localChecklistTemplates);
          }
          if (from < 3) {
            await m.createTable(mediaQueue);
            await m.addColumn(localInspections, localInspections.media);
          }
          if (from < 4) {
            await m.addColumn(localInspections, localInspections.annotations);
          }
          if (from < 5) {
            await m.addColumn(mediaQueue, mediaQueue.durationMs);
            await m.addColumn(localInspections, localInspections.voiceNotes);
          }
          if (from < 6) {
            await m.addColumn(localInspections, localInspections.readings);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final directory = await getApplicationDocumentsDirectory();
      final file = File(p.join(directory.path, 'fev_offline.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
