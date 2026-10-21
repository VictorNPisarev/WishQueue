// lib/features/wishlist/presentation/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/wish_item_repository_provider.dart';
import '../domain/wish_item_status.dart';

/// Позиции, которые решено купить под ближайшее поступление (`reserved`).
///
/// Сортировка: по приоритету (urgent → someday), внутри — по дате создания.
final reservedWishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchByStatus(WishItemStatus.reserved);
});

/// Позиции «в очереди» (`planned`) — хотелки, ещё не решено купить.
final plannedWishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchByStatus(WishItemStatus.planned);
});

/// Купленные позиции (`bought`).
final boughtWishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchByStatus(WishItemStatus.bought);
});
