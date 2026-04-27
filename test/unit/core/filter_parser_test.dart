import 'package:flutter_test/flutter_test.dart';
import '../../../lib/core/utils/filter_parser.dart';
import '../../../lib/features/ad_blocking/domain/models/filter_rule.dart';

void main() {
  group('FilterParser', () {
    test('parses domain blocking rule ||example.com^', () {
      final rules = FilterParser.parseFilterList('||example.com^');
      expect(rules.length, 1);
      expect(rules[0].pattern, 'example.com^');
      expect(rules[0].isException, false);
    });

    test('parses exception rule @@||safe.example.com^', () {
      final rules = FilterParser.parseFilterList('@@||safe.example.com^');
      expect(rules.length, 1);
      expect(rules[0].pattern, '||safe.example.com^');
      expect(rules[0].isException, true);
    });

    test('parses cosmetic filter ##.ad-banner', () {
      final rules = FilterParser.parseFilterList('##.ad-banner');
      expect(rules.length, 1);
      expect(rules[0].cssSelector, '.ad-banner');
    });

    test('skips empty lines and comments', () {
      final rules = FilterParser.parseFilterList('''
! This is a comment
||example.com^

||another.com^
# Also a comment
''');
      expect(rules.length, 2);
    });

    test('matches URL against filter rule', () {
      final rule = const FilterRule(pattern: '||ads.example.com^');
      expect(
        FilterParser.matches('https://ads.example.com/banner.js', rule),
        true,
      );
      expect(
        FilterParser.matches('https://safe.example.com/page', rule),
        false,
      );
    });
  });
}
