// lib/features/wishlist/domain/wish_item_priority.dart

import '../../../core/errors/app_exception.dart';

/// Приоритет позиции.
///
/// Порядок объявления — от самого срочного к «когда-нибудь».
/// Это позволяет сортировать по `index` при необходимости.
enum WishItemPriority {
  urgent,
  high,
  normal,
  someday;

  String get dbValue => name;

  static WishItemPriority fromDb(String value) {
    for (final p in WishItemPriority.values) {
      if (p.dbValue == value) return p;
    }
    throw DatabaseException('Unknown WishItemPriority: $value');
  }
}
