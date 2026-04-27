import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'bookmark.g.dart';

@collection
class Bookmark {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  String? url;
  String? title;
  String? favicon;
  DateTime createdAt = DateTime.now();
  int? folderId;

  Bookmark() {
    uuid = const Uuid().v4();
  }
}
