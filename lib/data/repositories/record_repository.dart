import '../../models/record.dart';

abstract class RecordRepository {
  Future<List<Record>> getAll();
  Future<void> add(Record record);
  Future<void> delete(int id);
}
