import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../domain/models/history_entry.dart';

class HistoryRepository {
  static final HistoryRepository _instance = HistoryRepository._internal();
  static HistoryRepository get instance => _instance;

  late Isar _isar;
  bool _initialized = false;

  HistoryRepository._internal();

  Future<void> init() async {
    if (_initialized) return;
    await IsarService.instance.init();
    _isar = IsarService.instance.isar;
    _initialized = true;
  }

  Future<void> record(String url, {String? title, bool isPrivate = false}) async {
    if (isPrivate) return;
    
    await init();
    
    final existing = await _isar.historyEntrys.filter().urlEqualTo(url).findFirst();
    
    if (existing != null) {
      existing.visitCount++;
      existing.visitedAt = DateTime.now();
      await _isar.writeTxn(() async {
        await _isar.historyEntrys.put(existing);
      });
    } else {
      final entry = HistoryEntry()
        ..url = url
        ..title = title ?? url;
      
      await _isar.writeTxn(() async {
        await _isar.historyEntrys.put(entry);
      });
    }
  }

  Future<List<HistoryEntry>> getRecent({int limit = 50}) async {
    await init();
    return await _isar.historyEntrys.where().sortByVisitedAtDesc().limit(limit).findAll();
  }

  Future<List<HistoryEntry>> search(String query) async {
    await init();
    return await _isar.historyEntrys
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .urlContains(query, caseSensitive: false)
        .sortByVisitedAtDesc()
        .findAll();
  }

  Future<void> clearAll() async {
    await init();
    await _isar.writeTxn(() async {
      await _isar.historyEntrys.clear();
    });
  }

  Future<void> deleteEntry(String uuid) async {
    await init();
    final entry = await _isar.historyEntrys.filter().uuidEqualTo(uuid).findFirst();
    if (entry != null) {
      await _isar.writeTxn(() async {
        await _isar.historyEntrys.delete(entry.id);
      });
    }
  }
}
