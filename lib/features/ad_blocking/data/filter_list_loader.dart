import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/utils/filter_parser.dart';
import '../domain/models/filter_rule.dart';

class FilterListLoader {
  static List<FilterRule>? _easyListCache;
  static List<FilterRule>? _easyPrivacyCache;

  static Future<List<FilterRule>> loadEasyList() async {
    if (_easyListCache != null) return _easyListCache!;
    
    try {
      final content = await rootBundle.loadString('assets/filters/easylist.txt');
      _easyListCache = FilterParser.parseFilterList(content);
      return _easyListCache!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<FilterRule>> loadEasyPrivacy() async {
    if (_easyPrivacyCache != null) return _easyPrivacyCache!;
    
    try {
      final content = await rootBundle.loadString('assets/filters/easyprivacy.txt');
      _easyPrivacyCache = FilterParser.parseFilterList(content);
      return _easyPrivacyCache!;
    } catch (e) {
      return [];
    }
  }

  static Future<List<FilterRule>> loadAllFilters() async {
    final easyList = await loadEasyList();
    final easyPrivacy = await loadEasyPrivacy();
    return [...easyList, ...easyPrivacy];
  }

  static void clearCache() {
    _easyListCache = null;
    _easyPrivacyCache = null;
  }
}
