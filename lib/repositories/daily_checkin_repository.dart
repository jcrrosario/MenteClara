import '../models/daily_checkin_entity.dart';

abstract class DailyCheckinRepository {
  Future<void> add(DailyCheckinEntity checkin);
  Future<List<DailyCheckinEntity>> getAll();
}
