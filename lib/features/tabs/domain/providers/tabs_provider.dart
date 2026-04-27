import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tab_repository.dart';
import '../domain/models/browser_tab.dart';

const int maxTabs = 10;

final tabsProvider = StateNotifierProvider<TabsNotifier, TabsState>((ref) {
  return TabsNotifier();
});

class TabsState {
  final List<BrowserTab> tabs;
  final String? activeTabUuid;
  final bool isLoading;
  final String? error;

  const TabsState({
    this.tabs = const [],
    this.activeTabUuid,
    this.isLoading = false,
    this.error,
  });

  TabsState copyWith({
    List<BrowserTab>? tabs,
    String? activeTabUuid,
    bool? isLoading,
    String? error,
  }) {
    return TabsState(
      tabs: tabs ?? this.tabs,
      activeTabUuid: activeTabUuid ?? this.activeTabUuid,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  BrowserTab? get activeTab {
    if (activeTabUuid == null) return null;
    try {
      return tabs.firstWhere((t) => t.uuid == activeTabUuid);
    } catch (_) {
      return null;
    }
  }
}

class TabsNotifier extends StateNotifier<TabsState> {
  final TabRepository _repository = TabRepository.instance;

  TabsNotifier() : super(const TabsState()) {
    _loadTabs();
  }

  Future<void> _loadTabs() async {
    state = state.copyWith(isLoading: true);
    try {
      final tabs = await _repository.getAllTabs();
      state = state.copyWith(
        tabs: tabs,
        activeTabUuid: tabs.isNotEmpty ? tabs.first.uuid : null,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addTab({
    String? url,
    String? title,
    bool isPrivate = false,
  }) async {
    if (state.tabs.length >= maxTabs) {
      state = state.copyWith(error: 'Maximum $maxTabs tabs allowed. Close a tab to open a new one.');
      return;
    }

    try {
      final tab = await _repository.createTab(
        url: url ?? 'https://duckduckgo.com',
        title: title ?? 'New Tab',
        isPrivate: isPrivate,
      );
      
      state = state.copyWith(
        tabs: [...state.tabs, tab],
        activeTabUuid: tab.uuid,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> closeTab(String uuid) async {
    try {
      await _repository.deleteTab(uuid);
      
      final newTabs = state.tabs.where((t) => t.uuid != uuid).toList();
      String? newActiveUuid = state.activeTabUuid;
      
      if (state.activeTabUuid == uuid) {
        newActiveUuid = newTabs.isNotEmpty ? newTabs.first.uuid : null;
      }
      
      state = state.copyWith(
        tabs: newTabs,
        activeTabUuid: newActiveUuid,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void switchTab(String uuid) {
    _repository.updateTab(uuid);
    state = state.copyWith(activeTabUuid: uuid);
  }

  Future<void> updateTab(String uuid, {String? url, String? title, String? favicon}) async {
    try {
      await _repository.updateTab(uuid, url: url, title: title, favicon: favicon);
      
      final updatedTabs = state.tabs.map((t) {
        if (t.uuid == uuid) {
          return BrowserTab.fromValues(
            uuid: t.uuid,
            url: url ?? t.url,
            title: title ?? t.title,
            favicon: favicon ?? t.favicon,
            isPrivate: t.isPrivate,
            createdAt: t.createdAt,
            lastActiveAt: DateTime.now(),
          );
        }
        return t;
      }).toList();
      
      state = state.copyWith(tabs: updatedTabs);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> closeAllTabs() async {
    try {
      await _repository.deleteAllTabs();
      state = const TabsState();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
