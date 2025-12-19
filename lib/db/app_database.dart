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

  // Novo: pensamento alternativo (pode ficar vazio)
  TextColumn get thoughtAlt => text().nullable()();

  TextColumn get emotion => text()();

  // Novo: comportamento (pode ficar vazio)
  TextColumn get behavior => text().nullable()();

  IntColumn get intensity => integer()();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Records])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      // Migração do schema antigo (1) para o novo (2)
      if (from == 1) {
        await migrator.addColumn(records, records.thoughtAlt);
        await migrator.addColumn(records, records.behavior);
      }
    },
  );

  Future<List<ThoughtRecord>> getAllRecords() {
    return (select(records)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();
  }

  Future<int> insertRecord({
    required String thought,
    String? thoughtAlt,
    required String emotion,
    String? behavior,
    required int intensity,
    required DateTime createdAt,
  }) {
    return into(records).insert(
      RecordsCompanion.insert(
        thought: thought,
        thoughtAlt: Value(thoughtAlt),
        emotion: emotion,
        behavior: Value(behavior),
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
