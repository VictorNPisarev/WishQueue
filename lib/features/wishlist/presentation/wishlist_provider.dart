// lib/features/wishlist/presentation/wishlist_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/wish_item_repository_provider.dart';

/// Стрим всех неудалённых позиций.
///
/// UI подписывается через `ref.watch(wishlistProvider)`, автоматически
/// перерисовывается при любом изменении таблицы `wish_items` (drift
/// перезапускает запрос), при ошибке — отдаёт `AsyncError`.
final wishlistProvider = StreamProvider<List<WishItem>>((ref) {
  final repo = ref.watch(wishItemRepositoryProvider);
  return repo.watchAll();
});
