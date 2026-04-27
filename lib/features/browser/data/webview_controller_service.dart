import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewControllerService {
  static final WebViewControllerService _instance = WebViewControllerService._internal();
  static WebViewControllerService get instance => _instance;

  InAppWebViewController? _controller;

  WebViewControllerService._internal();

  InAppWebViewController? get controller => _controller;

  void setController(InAppWebViewController controller) {
    _controller = controller;
  }

  void dispose() {
    _controller = null;
  }
}
