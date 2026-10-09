// lib/features/wishlist/data/wish_item_repository.dart

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/wish_item_priority.dart';
import '../domain/wish_item_status.dart';

/// Репозиторий позиций списка желаний.
class WishItemRepository {
  WishItemRepository(this._db);

  final AppDatabase _db;

  static const _uuid = Uuid();

  /// Все неудалённые позиции.
  ///
  /// Сортировка — в Dart: сначала по приоритету (urgent → someday),
  /// внутри приоритета по [createdAt] ascending.
  Stream<List<WishItem>> watchAll() {
    final query = _db.select(_db.wishItems)..where((t) => t.deletedAt.isNull());
    return query.watch().map(_sortItems);
  }

  /// Позиции с указанным статусом.
  Stream<List<WishItem>> watchByStatus(WishItemStatus status) {
    final query = _db.select(_db.wishItems)
      ..where((t) => t.deletedAt.isNull() & t.status.equals(status.dbValue));
    return query.watch().map(_sortItems);
  }

  /// Позиции, привязанные к конкретному поступлению.
  ///
  /// Используется на экране распределения. Статус не фильтруется:
  /// показываем и `reserved`, и `bought`.
  Stream<List<WishItem>> watchByIncome(String incomeId) {
    final query = _db.select(_db.wishItems)
      ..where((t) => t.deletedAt.isNull() & t.incomeId.equals(incomeId));
    return query.watch().map(_sortItems);
  }

  /// Одна позиция по id. Бросает [NotFoundException].
  Future<WishItem> getById(String id) async {
    final row = await (_db.select(
      _db.wishItems,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).getSingleOrNull();
    if (row == null) {
      throw NotFoundException('WishItem $id not found');
    }
    return row;
  }

  /// Создаёт позицию.
  Future<WishItem> create({
    required String title,
    int? estimatedMinor,
    String currency = 'RUB',
    WishItemPriority priority = WishItemPriority.normal,
    String? categoryId,
    String? notes,
    String? url,
  }) async {
    _validateTitle(title);
    _validateEstimatedMinor(estimatedMinor);

    final now = DateTime.now().toUtc();
    final id = _uuid.v4();

    final companion = WishItemsCompanion.insert(
      id: id,
      title: title,
      categoryId: Value(categoryId),
      priority: Value(priority.dbValue),
      estimatedMinor: Value(estimatedMinor),
      currency: Value(currency),
      status: Value(WishItemStatus.planned.dbValue),
      notes: Value(notes),
      url: Value(url),
      createdAt: now,
      updatedAt: now,
    );

    await _db.into(_db.wishItems).insert(companion);
    return getById(id);
  }

  /// Обновляет «редактируемые» поля позиции.
  ///
  /// Не трогает: `status`, `incomeId`, `actualMinor`, `boughtAt` —
  /// для них есть отдельные методы ([reserve], [markBought], ...).
  Future<WishItem> update({
    required String id,
    String? title,
    int? estimatedMinor,
    String? currency,
    WishItemPriority? priority,
    String? categoryId,
    String? notes,
    String? url,
  }) async {
    if (title != null) _validateTitle(title);
    if (estimatedMinor != null) _validateEstimatedMinor(estimatedMinor);

    final companion = WishItemsCompanion(
      title: Value.absentIfNull(title),
      estimatedMinor: Value.absentIfNull(estimatedMinor),
      currency: Value.absentIfNull(currency),
      priority: priority == null
          ? const Value.absent()
          : Value(priority.dbValue),
      categoryId: Value.absentIfNull(categoryId),
      notes: Value.absentIfNull(notes),
      url: Value.absentIfNull(url),
      updatedAt: Value(DateTime.now().toUtc()),
    );

    final affected = await (_db.update(
      _db.wishItems,
    )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).write(companion);

    if (affected == 0) {
      throw NotFoundException('WishItem $id not found');
    }

    return getById(id);
  }

  /// Резервирует позицию под поступление.
  ///
  /// Разрешено из статусов `planned` и `reserved` (в последнем случае —
  /// перезаписываем `incomeId`, пользователь перераспределил).
  /// Не разрешено из `bought` и `cancelled`.
  Future<WishItem> reserve(String id, String incomeId) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(_db.wishItems)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  (t.status.equals(WishItemStatus.planned.dbValue) |
                      t.status.equals(WishItemStatus.reserved.dbValue)),
            ))
            .write(
              WishItemsCompanion(
                incomeId: Value(incomeId),
                status: Value(WishItemStatus.reserved.dbValue),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw ValidationException(
        'WishItem $id cannot be reserved from its current status',
      );
    }

    return getById(id);
  }

  /// Снимает резерв. Работает только из статуса `reserved`.
  Future<WishItem> unreserve(String id) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(_db.wishItems)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  t.status.equals(WishItemStatus.reserved.dbValue),
            ))
            .write(
              WishItemsCompanion(
                incomeId: const Value(null),
                status: Value(WishItemStatus.planned.dbValue),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw ValidationException(
        'WishItem $id is not reserved, cannot unreserve',
      );
    }

    return getById(id);
  }

  /// Отмечает позицию как купленную.
  ///
  /// Разрешено из статусов `planned` и `reserved`. Не разрешено из
  /// `bought` и `cancelled`.
  Future<WishItem> markBought(
    String id, {
    int? actualMinor,
    DateTime? boughtAt,
  }) async {
    if (actualMinor != null && actualMinor < 0) {
      throw const ValidationException('Actual amount must not be negative');
    }

    final now = DateTime.now().toUtc();
    final bought = (boughtAt ?? now).toUtc();

    final affected =
        await (_db.update(_db.wishItems)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  (t.status.equals(WishItemStatus.planned.dbValue) |
                      t.status.equals(WishItemStatus.reserved.dbValue)),
            ))
            .write(
              WishItemsCompanion(
                status: Value(WishItemStatus.bought.dbValue),
                actualMinor: Value.absentIfNull(actualMinor),
                boughtAt: Value(bought),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw ValidationException(
        'WishItem $id cannot be marked as bought from its current status',
      );
    }

    return getById(id);
  }

  /// Отменяет позицию. Работает из `planned` и `reserved`.
  Future<WishItem> cancel(String id) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(_db.wishItems)..where(
              (t) =>
                  t.id.equals(id) &
                  t.deletedAt.isNull() &
                  (t.status.equals(WishItemStatus.planned.dbValue) |
                      t.status.equals(WishItemStatus.reserved.dbValue)),
            ))
            .write(
              WishItemsCompanion(
                status: Value(WishItemStatus.cancelled.dbValue),
                incomeId: const Value(null),
                updatedAt: Value(now),
              ),
            );

    if (affected == 0) {
      throw ValidationException(
        'WishItem $id cannot be cancelled from its current status',
      );
    }

    return getById(id);
  }

  /// Мягкое удаление. Работает из любого статуса.
  Future<void> softDelete(String id) async {
    final now = DateTime.now().toUtc();

    final affected =
        await (_db.update(
          _db.wishItems,
        )..where((t) => t.id.equals(id) & t.deletedAt.isNull())).write(
          WishItemsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );

    if (affected == 0) {
      throw NotFoundException('WishItem $id not found');
    }
  }

  // --- helpers ---

  List<WishItem> _sortItems(List<WishItem> items) {
    final sorted = [...items];
    sorted.sort((a, b) {
      final pa = WishItemPriority.fromDb(a.priority).index;
      final pb = WishItemPriority.fromDb(b.priority).index;
      final byPriority = pa.compareTo(pb);
      if (byPriority != 0) return byPriority;
      return a.createdAt.compareTo(b.createdAt);
    });
    return sorted;
  }

  void _validateTitle(String value) {
    if (value.trim().isEmpty) {
      throw const ValidationException('WishItem title must not be empty');
    }
  }

  void _validateEstimatedMinor(int? minor) {
    if (minor != null && minor < 0) {
      throw const ValidationException('Estimated amount must not be negative');
    }
  }
}
