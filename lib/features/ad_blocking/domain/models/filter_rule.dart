import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter_rule.freezed.dart';

@freezed
class FilterRule with _$FilterRule {
  const factory FilterRule({
    required String pattern,
    @Default(false) bool isException,
    @Default(false) bool isDomainSpecific,
    @Default([]) List<String> domains,
    @Default([]) List<String> resourceTypes,
    String? cssSelector,
  }) = _FilterRule;

  const FilterRule._();
}
