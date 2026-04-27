import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/features/tabs/domain/providers/tabs_provider.dart';
import '../../../lib/features/tabs/domain/models/browser_tab.dart';

void main() {
  group('TabsNotifier', () {
    late TabsNotifier notifier;

    setUp(() {
      notifier = TabsNotifier();
    });

    test('initial state has empty tabs', () {
      expect(notifier.state.tabs.isEmpty, true);
    });

    test('addTab creates a new tab', () async {
      await notifier.addTab(url: 'https://example.com', title: 'Example');
      expect(notifier.state.tabs.length, 1);
      expect(notifier.state.tabs[0].url, 'https://example.com');
    });

    test('closeTab removes the tab', () async {
      await notifier.addTab(url: 'https://example.com');
      final uuid = notifier.state.tabs[0].uuid;
      await notifier.closeTab(uuid);
      expect(notifier.state.tabs.isEmpty, true);
    });

    test('switchTab updates active tab', () async {
      await notifier.addTab(url: 'https://example.com');
      await notifier.addTab(url: 'https://another.com');
      final secondTab = notifier.state.tabs[1];
      notifier.switchTab(secondTab.uuid);
      expect(notifier.state.activeTabUuid, secondTab.uuid);
    });
  });
}
