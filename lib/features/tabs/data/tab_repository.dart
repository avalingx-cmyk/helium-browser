import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../models/browser_tab.dart';

class TabRepository {
  static final TabRepository _instance = TabRepository._internal();
  static TabRepository get instance => _instance;
  
  late Isar _isar;
  bool _initialized = false;
  
  TabRepository._internal();
  
  Future<void> init() async {
    if (_initialized) return;
    await IsarService.instance.init();
    _isar = IsarService.instance.isar;
    _initialized = true;
  }
  
  Future<List<BrowserTab>> getAllTabs() async {
    await init();
    return await _isar.browserTabs.where().sortByLastActiveAtDesc().findAll();
  }
  
  Future<BrowserTab?> getTab(String uuid) async {
    await init();
    return await _isar.browserTabs.filter().uuidEqualTo(uuid).findFirst();
  }
  
  Future<BrowserTab> createTab({
    String? url,
    String? title,
    String? favicon,
    bool isPrivate = false,
  }) async {
    await init();
    
    final tab = BrowserTab()
      ..url = url
      ..title = title ?? 'New Tab'
      ..favicon = favicon
      ..isPrivate = isPrivate
      ..createdAt = DateTime.now()
      ..lastActiveAt = DateTime.now();
    
    await _isar.writeTxn(() async {
      await _isar.browserTabs.put(tab);
    });
    
    return tab;
  }
  
  Future<void> updateTab(String uuid, {
    String? url,
    String? title,
    String? favicon,
  }) async {
    await init();
    
    final tab = await getTab(uuid);
    if (tab != null) {
      if (url != null) tab.url = url;
      if (title != null) tab.title = title;
      if (favicon != null) tab.favicon = favicon;
      tab.lastActiveAt = DateTime.now();
      
      await _isar.writeTxn(() async {
        await _isar.browserTabs.put(tab);
      });
    }
  }
  
  Future<void> deleteTab(String uuid) async {
    await init();
    
    final tab = await getTab(uuid);
    if (tab != null) {
      await _isar.writeTxn(() async {
        await _isar.browserTabs.delete(tab.id);
      });
    }
  }
  
  Future<void> deleteAllTabs() async {
    await init();
    await _isar.writeTxn(() async {
      await _isar.browserTabs.clear();
    });
  }
  
  Future<int> getTabCount() async {
    await init();
    return await _isar.browserTabs.count();
  }
}
