// lib/features/wishlist/presentation/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/wish_item_repository_provider.dart';

/// Активные позиции: `planned` + `reserved`.
/// Сортировка: reserved сверху, затем по приоритету.
final activeWishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchActive();
});

/// Купленные позиции (только `bought`).
final boughtWishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchBought();
});
