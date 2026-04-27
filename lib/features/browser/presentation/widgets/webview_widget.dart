import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HeliumWebView extends StatelessWidget {
  final String initialUrl;
  final Function(InAppWebViewController controller)? onWebViewCreated;
  final Function(InAppWebViewController controller, WebUri? url)? onLoadStart;
  final Function(InAppWebViewController controller, WebUri? url)? onLoadStop;
  final Function(InAppWebViewController controller, int progress)? onProgressChanged;
  final Function(InAppWebViewController controller, WebUri? url, int code, String message)? onLoadError;
  final Function(InAppWebViewController controller, WebUri? url, bool? isReload)? onUpdateVisitedHistory;

  const HeliumWebView({
    super.key,
    required this.initialUrl,
    this.onWebViewCreated,
    this.onLoadStart,
    this.onLoadStop,
    this.onProgressChanged,
    this.onLoadError,
    this.onUpdateVisitedHistory,
  });

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
      initialUrlRequest: URLRequest(
        url: WebUri(initialUrl),
      ),
      initialSettings: InAppWebViewSettings(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        javaScriptEnabled: true,
        cacheEnabled: true,
        transparentBackground: true,
      ),
      onWebViewCreated: onWebViewCreated,
      onLoadStart: onLoadStart,
      onLoadStop: onLoadStop,
      onProgressChanged: onProgressChanged,
      onLoadError: onLoadError,
      onUpdateVisitedHistory: onUpdateVisitedHistory,
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final url = navigationAction.request.url;
        if (url != null && url.toString().startsWith('http')) {
          return NavigationActionPolicy.ALLOW;
        }
        return NavigationActionPolicy.CANCEL;
      },
    );
  }
}
