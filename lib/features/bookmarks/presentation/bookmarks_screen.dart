import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookmark_repository.dart';
import '../domain/models/bookmark.dart';

// CONST AUDIT: ✅ Can be const - ConsumerWidget with FutureProvider.
// Constructor is stateless, rebuilds only on provider updates.
final bookmarksProvider = FutureProvider<List<Bookmark>>((ref) async {
  return await BookmarkRepository.instance.getAllBookmarks();
});

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarksAsync = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Search bookmarks
            },
          ),
        ],
      ),
      body: bookmarksAsync.when(
        data: (bookmarks) => bookmarks.isEmpty
            ? _buildEmptyState(context)
            : _buildBookmarksList(context, bookmarks),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No bookmarks yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Your saved pages will appear here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksList(BuildContext context, List<Bookmark> bookmarks) {
    return ListView.builder(
      itemCount: bookmarks.length,
      itemBuilder: (context, index) {
        final bookmark = bookmarks[index];
        return ListTile(
          leading: bookmark.favicon != null
              ? Image.network(
                  bookmark.favicon!,
                  width: 24,
                  height: 24,
                  errorBuilder: (_, __, ___) => const Icon(Icons.public),
                )
              : const Icon(Icons.public),
          title: Text(
            bookmark.title ?? 'Untitled',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            bookmark.url ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          onTap: () {
            // TODO: Navigate to bookmark
          },
          onLongPress: () {
            _showDeleteDialog(context, bookmark);
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Bookmark bookmark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete bookmark?'),
        content: Text('Remove "${bookmark.title ?? 'this bookmark'}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await BookmarkRepository.instance.removeBookmark(bookmark.uuid);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
