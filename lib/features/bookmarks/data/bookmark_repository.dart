import 'package:isar/isar.dart';
import '../../../../core/database/isar_service.dart';
import '../domain/models/bookmark.dart';

class BookmarkRepository {
  static final BookmarkRepository _instance = BookmarkRepository._internal();
  static BookmarkRepository get instance => _instance;

  late Isar _isar;
  bool _initialized = false;

  BookmarkRepository._internal();

  Future<void> init() async {
    if (_initialized) return;
    await IsarService.instance.init();
    _isar = IsarService.instance.isar;
    _initialized = true;
  }

  Future<List<Bookmark>> getAllBookmarks() async {
    await init();
    return await _isar.bookmarks.where().sortByCreatedAtDesc().findAll();
  }

  Future<Bookmark?> getBookmark(String uuid) async {
    await init();
    return await _isar.bookmarks.filter().uuidEqualTo(uuid).findFirst();
  }

  Future<Bookmark> addBookmark({
    required String url,
    String? title,
    String? favicon,
    int? folderId,
  }) async {
    await init();

    final bookmark = Bookmark()
      ..url = url
      ..title = title ?? 'Untitled'
      ..favicon = favicon
      ..folderId = folderId;

    await _isar.writeTxn(() async {
      await _isar.bookmarks.put(bookmark);
    });

    return bookmark;
  }

  Future<void> removeBookmark(String uuid) async {
    await init();
    final bookmark = await getBookmark(uuid);
    if (bookmark != null) {
      await _isar.writeTxn(() async {
        await _isar.bookmarks.delete(bookmark.id);
      });
    }
  }

  Future<List<Bookmark>> search(String query) async {
    await init();
    return await _isar.bookmarks
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .urlContains(query, caseSensitive: false)
        .findAll();
  }

  Future<bool> isBookmarked(String url) async {
    await init();
    final result = await _isar.bookmarks.filter().urlEqualTo(url).findFirst();
    return result != null;
  }
}
