import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'history_entry.g.dart';

@collection
class HistoryEntry {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  String? url;
  String? title;
  DateTime visitedAt = DateTime.now();
  int visitCount = 1;

  HistoryEntry() {
    uuid = const Uuid().v4();
  }
}
