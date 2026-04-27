import 'package:isar/isar.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/url_utils.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default(SearchEngine.duckDuckGo) SearchEngine searchEngine,
    @Default(true) bool adBlockingEnabled,
    @Default(true) bool javascriptEnabled,
    @Default(UserAgent.auto) UserAgent userAgent,
    @Default(DarkMode.system) DarkMode darkMode,
    @Default(100) int fontSize,
    @Default(false) bool privateModeDefault,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

enum UserAgent { auto, desktop, mobile }
enum DarkMode { system, light, dark }
