// lib/core/db/tables/incomes.dart
import 'package:drift/drift.dart';

/// Поступления: зарплата, аванс, подработка, подарок и т.п.
///
/// Суммы хранятся в минорных единицах валюты (копейки для RUB),
/// чтобы избежать проблем с плавающей точкой и перенестись
/// один-в-один в PostgreSQL bigint.
///
/// Значения [status] (контролируется в репозитории):
/// - 'planned'   — ожидается;
/// - 'received'  — фактически получено;
/// - 'cancelled' — отменено.
@DataClassName('Income')
class Incomes extends Table {
  TextColumn get id => text()();

  /// Отображаемое название: "Зарплата", "Аванс", ...
  TextColumn get title => text()();

  /// Сумма в минорных единицах (копейки).
  IntColumn get amountMinor => integer()();

  /// ISO-4217, напр. 'RUB'.
  TextColumn get currency => text().withDefault(const Constant('RUB'))();

  /// Когда ожидается/получено. Обязательно.
  DateTimeColumn get plannedDate => dateTime()();

  /// Фактическая дата получения (если уже получено).
  DateTimeColumn get receivedAt => dateTime().nullable()();

  /// 'planned' | 'received' | 'cancelled'.
  TextColumn get status => text().withDefault(const Constant('planned'))();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
