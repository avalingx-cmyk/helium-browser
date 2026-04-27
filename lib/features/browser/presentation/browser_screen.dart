import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/providers/browser_provider.dart';
import '../domain/models/page_state.dart';
import 'widgets/webview_widget.dart';
import 'widgets/loading_indicator.dart';
import 'widgets/error_page.dart';

// CONST AUDIT: ❌ Cannot be const - ConsumerStatefulWidget with InAppWebViewController.
// Uses stateful controller reference and Riverpod providers.
class BrowserScreen extends ConsumerStatefulWidget {
  const BrowserScreen({super.key});

  @override
  ConsumerState<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends ConsumerState<BrowserScreen> {
  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    final pageState = ref.watch(browserProvider);
    final browserNotifier = ref.read(browserProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Loading indicator
            if (pageState.isLoading)
              LoadingIndicator(progress: pageState.progress),
            
            // WebView or Error page
            Expanded(
              child: pageState.hasError
                ? ErrorPage(
                    message: pageState.errorMessage ?? 'Failed to load page',
                    onRetry: () => browserNotifier.refresh(),
                  )
                : HeliumWebView(
                    initialUrl: pageState.url,
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                      browserNotifier.setController(controller);
                    },
                    onLoadStart: (controller, url) {
                      browserNotifier.updateLoading(true);
                    },
                    onLoadStop: (controller, url) async {
                      browserNotifier.updateLoading(false);
                      if (url != null) {
                        final title = await controller.getTitle();
                        browserNotifier.updatePageInfo(url.toString(), title ?? '');
                      }
                    },
                    onProgressChanged: (controller, progress) {
                      browserNotifier.updateProgress(progress / 100);
                    },
                    onLoadError: (controller, url, code, message) {
                      browserNotifier.setError(message);
                    },
                    onUpdateVisitedHistory: (controller, url, isReload) {
                      if (url != null) {
                        browserNotifier.canGoBackForward();
                      }
                    },
                  ),
            ),
            
            // Bottom toolbar
            _buildBottomToolbar(context, pageState, browserNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomToolbar(BuildContext context, PageState state, BrowserNotifier notifier) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: state.canGoBack ? () => notifier.goBack() : null,
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: state.canGoForward ? () => notifier.goForward() : null,
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => notifier.refresh(),
            iconSize: 20,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => notifier.loadUrl('https://duckduckgo.com'),
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.tab),
            onPressed: () {
              // TODO: Navigate to tab switcher
            },
            iconSize: 20,
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMenu(context);
            },
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Add bookmark'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Add bookmark
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to history
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
