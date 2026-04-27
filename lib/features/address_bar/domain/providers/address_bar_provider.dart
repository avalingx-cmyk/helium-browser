import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/url_utils.dart';

final addressBarProvider = StateNotifierProvider<AddressBarNotifier, AddressBarState>((ref) {
  return AddressBarNotifier();
});

class AddressBarState {
  final String text;
  final bool isEditing;
  final List<String> suggestions;
  final bool showSuggestions;

  const AddressBarState({
    this.text = '',
    this.isEditing = false,
    this.suggestions = const [],
    this.showSuggestions = false,
  });

  AddressBarState copyWith({
    String? text,
    bool? isEditing,
    List<String>? suggestions,
    bool? showSuggestions,
  }) {
    return AddressBarState(
      text: text ?? this.text,
      isEditing: isEditing ?? this.isEditing,
      suggestions: suggestions ?? this.suggestions,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

class AddressBarNotifier extends StateNotifier<AddressBarState> {
  AddressBarNotifier() : super(const AddressBarState());

  void startEditing() {
    state = state.copyWith(isEditing: true, showSuggestions: true);
  }

  void stopEditing() {
    state = state.copyWith(isEditing: false, showSuggestions: false);
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
    _updateSuggestions(text);
  }

  void clearInput() {
    state = state.copyWith(text: '', suggestions: []);
  }

  String submitUrl(String input) {
    stopEditing();
    
    if (input.trim().isEmpty) {
      return '';
    }

    if (UrlUtils.isValidUrl(input)) {
      return UrlUtils.normalizeUrl(input);
    } else {
      return UrlUtils.buildSearchUrl(input);
    }
  }

  void _updateSuggestions(String query) {
    // TODO: Fetch from history provider
    state = state.copyWith(suggestions: []);
  }
}
