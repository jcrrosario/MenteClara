import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DataClassName('ThoughtRecord')
class Records extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get thought => text()();
  TextColumn get emotion => text()();
  IntColumn get intensity => integer()();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Records])

class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ThoughtRecord>> getAllRecords() {
    return (select(records)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<int> insertRecord({
    required String thought,
    required String emotion,
    required int intensity,
    required DateTime createdAt,
  }) {
    return into(records).insert(
      RecordsCompanion.insert(
        thought: thought,
        emotion: emotion,
        intensity: intensity,
        createdAt: createdAt,
      ),
    );
  }

  Future<int> deleteRecordById(int id) {
    return (delete(records)..where((t) => t.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'mente_clara.sqlite'));
    return NativeDatabase(file);
  });
}
