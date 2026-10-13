// lib/features/settings/domain/app_locale.dart

import 'dart:ui';

/// Язык приложения, выбираемый пользователем.
///
/// [system] — следовать за системной локалью.
/// Остальные — принудительно заданная локаль.
enum AppLocale {
  system('system', null),
  en('en', Locale('en')),
  ru('ru', Locale('ru')),
  esMx('es_MX', Locale('es', 'MX')),
  zhHans('zh_Hans', Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'));

  const AppLocale(this.key, this.locale);

  /// Ключ для хранения в БД.
  final String key;

  /// Локаль для MaterialApp. `null` — следовать за системой.
  final Locale? locale;

  static const AppLocale defaultLocale = AppLocale.system;

  static AppLocale fromKey(String? key) {
    if (key == null) return defaultLocale;
    for (final l in AppLocale.values) {
      if (l.key == key) return l;
    }
    return defaultLocale;
  }
}
