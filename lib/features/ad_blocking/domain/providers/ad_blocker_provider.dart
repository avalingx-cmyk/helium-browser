import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/filter_list_loader.dart';
import '../models/filter_rule.dart';
import '../../../../core/utils/filter_parser.dart';

final adBlockerProvider = StateNotifierProvider<AdBlockerNotifier, AdBlockerState>((ref) {
  return AdBlockerNotifier();
});

class AdBlockerState {
  final bool isEnabled;
  final int blockedCount;
  final bool isLoading;
  final List<FilterRule> rules;

  const AdBlockerState({
    this.isEnabled = true,
    this.blockedCount = 0,
    this.isLoading = false,
    this.rules = const [],
  });

  AdBlockerState copyWith({
    bool? isEnabled,
    int? blockedCount,
    bool? isLoading,
    List<FilterRule>? rules,
  }) {
    return AdBlockerState(
      isEnabled: isEnabled ?? this.isEnabled,
      blockedCount: blockedCount ?? this.blockedCount,
      isLoading: isLoading ?? this.isLoading,
      rules: rules ?? this.rules,
    );
  }
}

class AdBlockerNotifier extends StateNotifier<AdBlockerState> {
  AdBlockerNotifier() : super(const AdBlockerState()) {
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final rules = await FilterListLoader.loadAllFilters();
      state = state.copyWith(rules: rules, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void toggleBlocking() {
    state = state.copyWith(isEnabled: !state.isEnabled);
  }

  void incrementBlockedCount() {
    state = state.copyWith(blockedCount: state.blockedCount + 1);
  }

  int getBlockedCount() => state.blockedCount;

  bool shouldBlock(String url) {
    if (!state.isEnabled) return false;
    
    for (final rule in state.rules) {
      if (FilterParser.matches(url, rule)) {
        return true;
      }
    }
    return false;
  }
}
