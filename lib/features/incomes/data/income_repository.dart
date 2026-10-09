// lib/features/incomes/data/income_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/income_status.dart';

/// Репозиторий поступлений.
///
/// Все операции — над таблицей `incomes`. Работа с drift инкапсулирована.
class IncomeRepository {
  IncomeRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  /// Все неудалённые поступления.
  ///
  /// Сортировка: `plannedDate DESC` — сначала свежие/будущие.
  Stream<List<Income>> watchAll() {
    final query = _db.select(_db.incomes)
      ..where((t) => t.deletedAt.isNull())
      ..orderBy([(t) => OrderingTerm.desc(t.plannedDate)]);
    return query.watch();
  }

  /// Поступления с указанным статусом.
  ///
  /// Используется, например, для экрана «Ожидается».
  Stream<List<Income>> watchByStatus(IncomeStatus status) {
    final query = _db.select(_db.incomes)
      ..where((t) => t.deletedAt.isNull() & t.status.equals(status.dbValue))
      ..orderBy([(t) => OrderingTerm.desc(t.plannedDate)]);
    return query.watch();
  }

  /// Одно поступление по id. Бросает [NotFoundException].
  Future<Income> getById(String id) async {
    final row = await (_db.select(
      _db.incomes,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    if (row == null) {
      throw NotFoundException('Income $id not found');
    }
    return row;
  }

  /// Создаёт поступление.
  Future<Income> create({
    required String title,
    required int amountMinor,
    required DateTime plannedDate,
    String currency = 'RUB',
    String? notes,
  }) async {
    _validateTitle(title);
    _validateAmount(amountMinor);

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();

    final companion = IncomesCompanion.insert(
      id: id,
      title: title,
      amountMinor: amountMinor,
      currency: Value(currency),
      plannedDate: plannedDate.toUtc(),
      status: Value(IncomeStatus.planned.dbValue),
      notes: Value(notes),
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.incomes).insert(companion);
    return getById(id);
  }

  /// Обновляет поступление.
  ///
  /// Не позволяет менять `status` и `receivedAt` напрямую — для этого
  /// есть [markReceived] и [cancel].
  Future<Income> update({
    required String id,
    String? title,
    int? amountMinor,
    DateTime? plannedDate,
    String? currency,
    String? notes,
  }) async {
    if (title != null) _validateTitle(title);
    if (amountMinor != null) _validateAmount(amountMinor);

    final companion = IncomesCompanion(
      title: Value.absentIfNull(title),
      amountMinor: Value.absentIfNull(amountMinor),
      plannedDate: plannedDate == null
          ? const Value.absent()
          : Value(plannedDate.toUtc()),
      currency: Value.absentIfNull(currency),
      notes: Value.absentIfNull(notes),
      updatedAt: Value(DateTime.now().toUtc()),
    );

    final affected = await (_db.update(
      _db.incomes,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).write(companion);

    if (affected == 0) {
      throw NotFoundException('Income $id not found');
    }

    return getById(id);
  }

  /// Отмечает поступление как полученное.
  ///
  /// [receivedAt] — фактическая дата получения. Если не передана — «сейчас».
  Future<Income> markReceived(String id, {DateTime? receivedAt}) async {
    final now = DateTime.now().toUtc();
    final received = (receivedAt ?? now).toUtc();

    final affected =
        await (_db.update(_db.incomes)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  t.status.equals(IncomeStatus.planned.dbValue),
            ))
            .write(
              IncomesCompanion(
                status: Value(IncomeStatus.received.dbValue),
                receivedAt: Value(received),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw NotFoundException('Income $id not found or not in planned status');
    }

    return getById(id);
  }

  /// Отменяет поступление.
  Future<Income> cancel(String id) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(_db.incomes)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  t.status.equals(IncomeStatus.planned.dbValue),
            ))
            .write(
              IncomesCompanion(
                status: Value(IncomeStatus.cancelled.dbValue),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw NotFoundException('Income $id not found or not in planned status');
    }

    return getById(id);
  }

  /// Мягкое удаление.
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(
          _db.incomes,
        )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).write(
          IncomesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );

    if (affected == 0) {
      throw NotFoundException('Income $id not found');
    }
  }

  void _validateTitle(String value) {
    if (value.trim().isEmpty) {
      throw const ValidationException('Income title must not be empty');
    }
  }

  void _validateAmount(int minor) {
    if (minor <= 0) {
      throw const ValidationException('Income amount must be positive');
    }
  }
}
