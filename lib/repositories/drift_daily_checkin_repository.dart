import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'daily_checkin_repository.dart';

class DriftDailyCheckinRepository implements DailyCheckinRepository {
  final AppDatabase _db = AppDatabase();

  @override
  Future<void> add(DailyCheckinEntity checkin) async {
    await _db.insertDailyCheckin(
      DailyCheckinsCompanion.insert(
        mood: checkin.mood,
        feelings: checkin.feelings.join(','), // ✅ agora é List<String>
        note: Value(checkin.note),
        createdAt: checkin.createdAt,
      ),
    );
  }

  @override
  Future<List<DailyCheckinEntity>> getAll() async {
    final rows = await _db.getAllDailyCheckins();

    return rows.map((row) {
      return DailyCheckinEntity(
        id: row.id,
        mood: row.mood,
        feelings: row.feelings.split(','), // ✅ volta para List<String>
        note: row.note,
        createdAt: row.createdAt,
      );
    }).toList();
  }
}
