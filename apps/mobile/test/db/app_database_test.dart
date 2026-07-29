import 'package:drift/native.dart';
import 'package:fev_mobile/db/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('in-memory AppDatabase can insert and read back a row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final now = DateTime.utc(2026, 1, 1);
    await db.into(db.localInspections).insert(
          LocalInspectionsCompanion.insert(
            id: 'insp-1',
            assetId: 'asset-1',
            inspectorId: 'user-1',
            status: 'draft',
            inspectionType: 'adHoc',
            clientCreatedAt: now,
            createdAt: now,
            updatedAt: now,
          ),
        );

    final rows = await db.select(db.localInspections).get();
    expect(rows, hasLength(1));
    expect(rows.single.id, 'insp-1');
    expect(rows.single.syncState, 'local_only');
  });
}
