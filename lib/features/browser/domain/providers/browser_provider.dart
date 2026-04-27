import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/page_state.dart';

final browserProvider = StateNotifierProvider<BrowserNotifier, PageState>((ref) {
  return BrowserNotifier();
});

class BrowserNotifier extends StateNotifier<PageState> {
  InAppWebViewController? _controller;

  BrowserNotifier() : super(const PageState());

  void setController(InAppWebViewController controller) {
    _controller = controller;
    canGoBackForward();
  }

  Future<void> loadUrl(String url) async {
    if (_controller == null) return;
    
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );
    
    await _controller!.loadUrl(
      urlRequest: URLRequest(url: WebUri(url)),
    );
  }

  Future<void> goBack() async {
    if (_controller == null) return;
    if (await _controller!.canGoBack()) {
      await _controller!.goBack();
    }
  }

  Future<void> goForward() async {
    if (_controller == null) return;
    if (await _controller!.canGoForward()) {
      await _controller!.goForward();
    }
  }

  Future<void> refresh() async {
    if (_controller == null) return;
    await _controller!.reload();
  }

  void updateLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void updateProgress(double progress) {
    state = state.copyWith(progress: progress);
  }

  void updatePageInfo(String url, String title) {
    state = state.copyWith(url: url, title: title);
  }

  void canGoBackForward() async {
    if (_controller == null) return;
    final canGoBack = await _controller!.canGoBack();
    final canGoForward = await _controller!.canGoForward();
    state = state.copyWith(
      canGoBack: canGoBack,
      canGoForward: canGoForward,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      hasError: true,
      errorMessage: message,
      isLoading: false,
    );
  }

  @override
  void dispose() {
    _controller = null;
    super.dispose();
  }
}
