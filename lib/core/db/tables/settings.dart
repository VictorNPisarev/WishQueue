// lib/core/db/tables/settings.dart

import 'package:drift/drift.dart';

/// Key-value хранилище настроек приложения.
///
/// Значения всегда хранятся как TEXT. Типизация (enum, int, bool)
/// — на уровне репозитория, здесь только «сырое» хранилище.
@DataClassName('Setting')
class Settings extends Table {
  /// Ключ настройки (например, 'theme_seed').
  TextColumn get key => text()();

  /// Значение в виде строки.
  TextColumn get value => text()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}
