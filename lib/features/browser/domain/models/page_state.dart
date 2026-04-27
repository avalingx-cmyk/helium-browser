import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_state.freezed.dart';

@freezed
class PageState with _$PageState {
  const factory PageState({
    @Default('https://duckduckgo.com') String url,
    @Default('') String title,
    @Default(false) bool isLoading,
    @Default(0.0) double progress,
    @Default(false) bool canGoBack,
    @Default(false) bool canGoForward,
    @Default(false) bool hasError,
    String? errorMessage,
  }) = _PageState;

  const PageState._();
}
