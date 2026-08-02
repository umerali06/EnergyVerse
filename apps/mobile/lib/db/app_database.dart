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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        // v2 (Phase 7.3): a local-only `assetCategory` column on
        // LocalInspections (for fully-offline checklist-template
        // auto-selection) and the new LocalChecklistTemplates cache table.
        // v3 (Phase 7.4): the separate MediaQueue table, plus a `media`
        // JSON-blob column on LocalInspections caching the server's synced
        // `inspection.media[]` for fully-offline gallery viewing.
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(localInspections, localInspections.assetCategory);
            await m.createTable(localChecklistTemplates);
          }
          if (from < 3) {
            await m.createTable(mediaQueue);
            await m.addColumn(localInspections, localInspections.media);
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
