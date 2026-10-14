// lib/features/settings/domain/app_locale.dart

import 'dart:ui';

/// Язык приложения, выбираемый пользователем.
///
/// [system] — следовать за системной локалью.
/// Остальные — принудительно заданная локаль.
///
/// [nativeName] — название языка на нём самом (стандарт i18n).
/// Не локализуется через .arb: пользователь ищет знакомое написание.
/// Исключение — [system], его название локализуется в UI.
enum AppLocale {
  system('system', null, 'System'),
  en('en', Locale('en'), 'English'),
  ru('ru', Locale('ru'), 'Русский'),
  esMx('es_MX', Locale('es', 'MX'), 'Español (México)'),
  zhHans(
    'zh_Hans',
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    '中文（简体）',
  );

  const AppLocale(this.key, this.locale, this.nativeName);

  /// Ключ для хранения в БД.
  final String key;

  /// Локаль для MaterialApp. `null` — следовать за системой.
  final Locale? locale;

  /// Название языка на нём самом.
  final String nativeName;

  static const AppLocale defaultLocale = AppLocale.system;

  static AppLocale fromKey(String? key) {
    if (key == null) return defaultLocale;
    for (final l in AppLocale.values) {
      if (l.key == key) return l;
    }
    return defaultLocale;
  }
}
