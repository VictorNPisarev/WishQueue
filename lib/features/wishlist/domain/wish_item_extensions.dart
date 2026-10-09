// lib/features/wishlist/domain/wish_item_extensions.dart

import '../../../core/db/database.dart';
import '../../../core/utils/money.dart';

/// Удобные геттеры для [WishItem], возвращающие [Money].
///
/// [WishItem] — drift-модель, цена в ней хранится как int (минорные единицы)
/// плюс отдельно валюта. Эти геттеры собирают всё в [Money] для UI.
extension WishItemMoney on WishItem {
  Money? get estimatedPrice =>
      estimatedMinor == null ? null : Money(estimatedMinor!, currency);

  Money? get actualPrice =>
      actualMinor == null ? null : Money(actualMinor!, currency);

  /// Что показывать в списке: фактическую цену, если куплено,
  /// иначе предполагаемую.
  Money? get displayPrice => actualPrice ?? estimatedPrice;
}
