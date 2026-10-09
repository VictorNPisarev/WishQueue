// lib/features/wishlist/domain/wish_item_status.dart

import '../../../core/errors/app_exception.dart';

/// Статусы позиции списка желаний.
enum WishItemStatus {
  /// В очереди, деньги не назначены.
  planned,

  /// Зарезервирована под конкретное поступление ([WishItem.incomeId]).
  reserved,

  /// Куплена ([WishItem.actualMinor] и [WishItem.boughtAt] заполнены).
  bought,

  /// Отменена.
  cancelled;

  String get dbValue => name;

  static WishItemStatus fromDb(String value) {
    for (final s in WishItemStatus.values) {
      if (s.dbValue == value) return s;
    }
    throw DatabaseException('Unknown WishItemStatus: $value');
  }
}
