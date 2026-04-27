class UrlUtils {
  static bool isValidUrl(String input) {
    final urlPattern = RegExp(
      r'^(http|https)://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(:[0-9]{1,5})?(/.*)?$',
      caseSensitive: false,
    );
    
    if (urlPattern.hasMatch(input)) return true;
    
    // Check for domain-like patterns (e.g., example.com)
    final domainPattern = RegExp(
      r'^[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(:[0-9]{1,5})?(/.*)?$',
    );
    
    return domainPattern.hasMatch(input);
  }

  static String normalizeUrl(String input) {
    if (input.startsWith('http://') || input.startsWith('https://')) {
      return input;
    }
    return 'https://$input';
  }

  static String buildSearchUrl(String query, {SearchEngine engine = SearchEngine.duckDuckGo}) {
    final encodedQuery = Uri.encodeComponent(query);
    
    switch (engine) {
      case SearchEngine.google:
        return 'https://www.google.com/search?q=$encodedQuery';
      case SearchEngine.duckDuckGo:
        return 'https://duckduckgo.com/?q=$encodedQuery';
      case SearchEngine.brave:
        return 'https://search.brave.com/search?q=$encodedQuery';
      case SearchEngine.bing:
        return 'https://www.bing.com/search?q=$encodedQuery';
    }
  }
}

enum SearchEngine {
  google,
  duckDuckGo,
  brave,
  bing,
}

extension SearchEngineExtension on SearchEngine {
  String get displayName {
    switch (this) {
      case SearchEngine.google:
        return 'Google';
      case SearchEngine.duckDuckGo:
        return 'DuckDuckGo';
      case SearchEngine.brave:
        return 'Brave Search';
      case SearchEngine.bing:
        return 'Bing';
    }
  }
}
