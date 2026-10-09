// lib/features/wishlist/data/wish_item_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'wish_item_repository.dart';

/// Singleton [WishItemRepository] на всё приложение.
final wishItemRepositoryProvider = Provider<WishItemRepository>((ref) {
  return WishItemRepository(ref.watch(appDatabaseProvider));
});
