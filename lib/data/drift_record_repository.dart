import 'package:drift/drift.dart';

import '../../models/record.dart';
import '../../db/app_database.dart';
import 'record_repository.dart';


class DriftRecordRepository implements RecordRepository {
  final AppDatabase _db;

  DriftRecordRepository(this._db);

  @override
  Future<List<Record>> getAll() async {
    final rows = await _db.select(_db.records).get();

    return rows.map((r) {
      return Record(
        thought: r.thought,
        emotion: r.emotion,
        intensity: r.intensity,
        createdAt: r.createdAt,
      );
    }).toList();
  }

  @override
  Future<void> add(Record record) async {
    await _db.insertRecord(
      thought: record.thought,
      emotion: record.emotion,
      intensity: record.intensity,
      createdAt: record.createdAt,
    );
  }

  @override
  Future<void> delete(int id) async {
    await (_db.delete(_db.records)
      ..where((tbl) => tbl.id.equals(id)))
        .go();
  }
}
