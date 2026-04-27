import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'browser_tab.g.dart';

@collection
class BrowserTab {
  Id id = Isar.autoIncrement;
  
  @Index(unique: true)
  late String uuid;
  
  String? url;
  String? title;
  String? favicon;
  bool isPrivate = false;
  DateTime createdAt = DateTime.now();
  DateTime lastActiveAt = DateTime.now();
  
  BrowserTab() {
    uuid = const Uuid().v4();
  }
  
  BrowserTab.fromValues({
    required this.uuid,
    this.url,
    this.title,
    this.favicon,
    this.isPrivate = false,
    required this.createdAt,
    required this.lastActiveAt,
  });
}
