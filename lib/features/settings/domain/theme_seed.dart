// lib/features/settings/domain/theme_seed.dart

import 'package:flutter/material.dart';

/// Предустановленные цвета темы (seed для [ColorScheme.fromSeed]).
///
/// Хранится в БД как [key]. При загрузке маппится обратно в [color].
/// Отображаемое название локализуется в UI через ключ `themeSeed_<key>`,
/// здесь его нет — enum знает только про БД и Material.
enum ThemeSeed {
  blueGrey('blueGrey', Colors.blueGrey),
  teal('teal', Colors.teal),
  indigo('indigo', Colors.indigo),
  brown('brown', Colors.brown),
  green('green', Colors.green),
  deepPurple('deepPurple', Colors.deepPurple);

  const ThemeSeed(this.key, this.color);

  /// Ключ для хранения в БД.
  final String key;

  /// Цвет-основа для [ColorScheme.fromSeed].
  final Color color;

  /// Дефолт, если в БД пусто или неизвестное значение.
  static const ThemeSeed defaultSeed = ThemeSeed.blueGrey;

  /// Парсит [key] из БД. Неизвестное значение → [defaultSeed].
  static ThemeSeed fromKey(String? key) {
    if (key == null) return defaultSeed;
    for (final s in ThemeSeed.values) {
      if (s.key == key) return s;
    }
    return defaultSeed;
  }
}
