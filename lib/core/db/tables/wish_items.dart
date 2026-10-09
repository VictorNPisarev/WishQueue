// lib/core/db/tables/wish_items.dart
import 'package:drift/drift.dart';

import 'categories.dart';
import 'incomes.dart';

/// Позиция списка желаний.
///
/// Значения [status] (контролируется в репозитории):
/// - 'planned'   — в очереди, деньги не назначены;
/// - 'reserved'  — зарезервирована под конкретное поступление ([incomeId]);
/// - 'bought'    — куплена ([actualMinor] заполнена, [boughtAt] проставлена);
/// - 'cancelled' — отменена.
///
/// Значения [priority]:
/// - 'urgent' | 'high' | 'normal' | 'someday'.
@DataClassName('WishItem')
@TableIndex(name: 'idx_wish_items_status', columns: {#status, #deletedAt})
@TableIndex(name: 'idx_wish_items_income', columns: {#incomeId})
@TableIndex(name: 'idx_wish_items_category', columns: {#categoryId})
class WishItems extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get notes => text().nullable()();

  /// Ссылка на объявление/товар. Не FK, просто URL.
  TextColumn get url => text().nullable()();

  TextColumn get categoryId => text().nullable().references(
    Categories,
    #id,
    onDelete: KeyAction.setNull,
  )();

  /// 'urgent' | 'high' | 'normal' | 'someday'.
  TextColumn get priority => text().withDefault(const Constant('normal'))();

  /// Предполагаемая цена в минорных единицах.
  IntColumn get estimatedMinor => integer().nullable()();

  /// Фактическая цена в минорных единицах (когда куплено).
  IntColumn get actualMinor => integer().nullable()();

  TextColumn get currency => text().withDefault(const Constant('RUB'))();

  /// 'planned' | 'reserved' | 'bought' | 'cancelled'.
  TextColumn get status => text().withDefault(const Constant('planned'))();

  /// Под какое поступление зарезервирована позиция.
  TextColumn get incomeId =>
      text().nullable().references(Incomes, #id, onDelete: KeyAction.setNull)();

  /// Дата покупки (когда status = 'bought').
  DateTimeColumn get boughtAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
