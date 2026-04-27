import '../../features/ad_blocking/domain/models/filter_rule.dart';

class FilterParser {
  static List<FilterRule> parseFilterList(String content) {
    final rules = <FilterRule>[];
    final lines = content.split('\n');

    for (final line in lines) {
      final trimmed = line.trim();
      
      // Skip empty lines and comments
      if (trimmed.isEmpty || trimmed.startsWith('!') || trimmed.startsWith('[')) {
        continue;
      }

      try {
        final rule = _parseLine(trimmed);
        if (rule != null) {
          rules.add(rule);
        }
      } catch (_) {
        // Skip malformed rules
      }
    }

    return rules;
  }

  static FilterRule? _parseLine(String line) {
    // Exception rules (whitelist)
    if (line.startsWith('@@')) {
      final pattern = line.substring(2);
      return FilterRule(
        pattern: pattern,
        isException: true,
      );
    }

    // Cosmetic filters (CSS)
    if (line.contains('##') || line.contains('#@#')) {
      final parts = line.split(RegExp(r'#@?#'));
      if (parts.length >= 2) {
        final domains = parts[0].isEmpty ? <String>[] : parts[0].split(',');
        return FilterRule(
          pattern: '',
          isDomainSpecific: parts[0].isNotEmpty,
          domains: domains,
          cssSelector: parts[1],
        );
      }
    }

    // Domain-specific rules
    if (line.contains('||')) {
      final pattern = line.replaceFirst('||', '');
      return FilterRule(
        pattern: pattern,
        isDomainSpecific: true,
      );
    }

    // Generic blocking rules
    if (line.startsWith('|') || line.contains('*') || line.contains('^')) {
      return FilterRule(
        pattern: line,
      );
    }

    return null;
  }

  static bool matches(String url, FilterRule rule) {
    if (rule.isException) return false;

    var pattern = rule.pattern;
    
    // Convert Adblock pattern to regex
    pattern = pattern
        .replaceAll('||', '^(?:https?://)?(?:[^/]+\\.)?')
        .replaceAll('^', '^')
        .replaceAll('|', '^')
        .replaceAll('*', '.*')
        .replaceAll(r'\^', r'[/:?&]');

    try {
      final regex = RegExp(pattern, caseSensitive: false);
      return regex.hasMatch(url);
    } catch (_) {
      return false;
    }
  }
}
