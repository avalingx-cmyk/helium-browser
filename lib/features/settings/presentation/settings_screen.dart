import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/url_utils.dart';

// CONST AUDIT: ✅ Can be const - ConsumerWidget with no dynamic state.
// Uses ref.watch but constructor is stateless.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Privacy'),
          ListTile(
            leading: const Icon(Icons.search),
            title: const Text('Default Search Engine'),
            subtitle: const Text('DuckDuckGo'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show search engine selector
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.incognito),
            title: const Text('Private Mode by Default'),
            subtitle: const Text('Open new tabs in private mode'),
            value: false,
            onChanged: (value) {
              // TODO: Toggle private mode default
            },
          ),
          
          _buildSectionHeader(context, 'Content'),
          SwitchListTile(
            secondary: const Icon(Icons.block),
            title: const Text('Ad Blocking'),
            subtitle: const Text('Block ads and trackers'),
            value: true,
            onChanged: (value) {
              // TODO: Toggle ad blocking
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.javascript),
            title: const Text('JavaScript'),
            value: true,
            onChanged: (value) {
              // TODO: Toggle JavaScript
            },
          ),
          
          _buildSectionHeader(context, 'Appearance'),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Theme'),
            subtitle: const Text('System default'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show theme selector
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Font Size'),
            subtitle: const Text('100%'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show font size slider
            },
          ),
          
          _buildSectionHeader(context, 'Advanced'),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Data'),
            subtitle: const Text('Delete history, bookmarks, and settings'),
            onTap: () {
              _showClearDataDialog(context);
            },
          ),
          
          _buildSectionHeader(context, 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('0.1.0'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('GitHub'),
            subtitle: const Text('View source code'),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // TODO: Open GitHub
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(
          'This will permanently delete all browsing history, bookmarks, and app settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
