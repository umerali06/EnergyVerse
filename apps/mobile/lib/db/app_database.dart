import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    LocalInspections,
    Outbox,
    LocalChecklistTemplates,
    MediaQueue,
    LocalWorkOrders,
    WorkOrderOutbox,
    LocalPermits,
    PermitOutbox,
    LocalSafetyReports,
    SafetyOutbox,
    SafetyEvidenceQueue,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
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
          if (from < 7) {
            await m.addColumn(localInspections, localInspections.signature);
            await m.addColumn(
                localInspections, localInspections.pendingSignatureStrokes);
          }
          if (from < 8) {
            await m.addColumn(
                localInspections, localInspections.arMeasurements);
          }
          if (from < 9) {
            await m.addColumn(localInspections, localInspections.aiAnalysis);
          }
          if (from < 10) {
            await m.createTable(localWorkOrders);
            await m.createTable(workOrderOutbox);
          }
          if (from < 11) {
            await m.createTable(localSafetyReports);
            await m.createTable(safetyOutbox);
          }
          if (from < 12) {
            await m.addColumn(safetyOutbox, safetyOutbox.targetId);
            await m.createTable(safetyEvidenceQueue);
          }
          if (from < 13) {
            await m.createTable(localPermits);
            await m.createTable(permitOutbox);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'fev_offline',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}