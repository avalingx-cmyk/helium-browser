import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/providers/tabs_provider.dart';
import 'widgets/tab_card.dart';

// CONST AUDIT: ✅ Can be const - ConsumerWidget with no dynamic state in constructor.
// Uses ref.watch for providers but constructor is stateless.
class TabSwitcherScreen extends ConsumerWidget {
  const TabSwitcherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsState = ref.watch(tabsProvider);
    final tabsNotifier = ref.read(tabsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs'),
        actions: [
          if (tabsState.tabs.isNotEmpty)
            TextButton.icon(
              onPressed: () {
                _showClearConfirmation(context, tabsNotifier);
              },
              icon: const Icon(Icons.delete_outline),
              label: const Text('Close All'),
            ),
        ],
      ),
      body: tabsState.tabs.isEmpty
          ? _buildEmptyState(context)
          : _buildTabGrid(context, tabsState, tabsNotifier),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          tabsNotifier.addTab();
          if (tabsState.error == null) {
            context.go('/');
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New Tab'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.tab_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No open tabs',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to open a new tab',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabGrid(BuildContext context, TabsState state, TabsNotifier notifier) {
    return Column(
      children: [
        if (state.error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: notifier.clearError,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
              ],
            ),
          ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: state.tabs.length,
            itemBuilder: (context, index) {
              final tab = state.tabs[index];
              final isActive = tab.uuid == state.activeTabUuid;
              
              return TabCard(
                tab: tab,
                isActive: isActive,
                onTap: () {
                  notifier.switchTab(tab.uuid);
                  context.go('/');
                },
                onClose: () => notifier.closeTab(tab.uuid),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showClearConfirmation(BuildContext context, TabsNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Close all tabs?'),
        content: const Text('This will close all open tabs.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.closeAllTabs();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Close All'),
          ),
        ],
      ),
    );
  }
}
