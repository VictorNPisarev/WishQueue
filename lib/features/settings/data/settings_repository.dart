// lib/features/settings/data/settings_repository.dart

import 'package:drift/drift.dart';

import '../../../core/db/database.dart';
import '../domain/theme_seed.dart';

import '../domain/app_locale.dart';

/// Ключи настроек в таблице `settings`.
///
/// Строковые константы, чтобы не опечататься при чтении/записи.
class SettingKeys {
  SettingKeys._();

  static const themeSeed = 'theme_seed';
  static const locale = 'locale';
}

/// Репозиторий настроек приложения.
///
/// Общие методы для key-value, плюс типизированные обёртки
/// для конкретных настроек.
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  /// Читает сырое значение по ключу.
  Future<String?> getValue(String key) async {
    final row = await (_db.select(
      _db.settings,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  /// Записывает значение (upsert — insert или update).
  Future<void> setValue(String key, String value) async {
    final now = DateTime.now().toUtc();
    await _db
        .into(_db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: key, value: value, updatedAt: now),
        );
  }

  /// Читает выбранный seed темы. Если не задано — [ThemeSeed.defaultSeed].
  Future<ThemeSeed> getThemeSeed() async {
    final raw = await getValue(SettingKeys.themeSeed);
    return ThemeSeed.fromKey(raw);
  }

  /// Записывает выбранный seed темы.
  Future<void> setThemeSeed(ThemeSeed seed) async {
    await setValue(SettingKeys.themeSeed, seed.key);
  }

  Future<AppLocale> getAppLocale() async {
    final raw = await getValue(SettingKeys.locale);
    return AppLocale.fromKey(raw);
  }

  Future<void> setAppLocale(AppLocale locale) async {
    await setValue(SettingKeys.locale, locale.key);
  }
}
