// lib/core/db/tables/categories.dart
import 'package:drift/drift.dart';

/// Категории позиций.
///
/// Инвариант (контролируется в репозитории, не на уровне схемы):
/// ровно одно из [nameKey] / [nameCustom] заполнено.
/// - системные категории (isSystem = true) имеют [nameKey] и переводятся
///   через .arb-файлы;
/// - пользовательские (isSystem = false) имеют [nameCustom] и не переводятся.
@DataClassName('Category')
class Categories extends Table
{
  /// UUID в виде TEXT. Генерируется в коде, не в БД.
  TextColumn get id => text()();

  /// Ключ локализации для системных категорий, напр. 'cat_auto'.
  TextColumn get nameKey => text().nullable()();

  /// Пользовательское название (для isSystem = false).
  TextColumn get nameCustom => text().nullable()();

  /// Код иконки (напр. 'directions_car'). Интерпретация — в UI.
  TextColumn get icon => text().nullable()();

  /// Цвет в hex (напр. '#FF5722'). Интерпретация — в UI.
  TextColumn get color => text().nullable()();

  /// Порядок сортировки в списках. Меньше — выше.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// true для встроенных категорий (Авто, Дом, ...).
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
