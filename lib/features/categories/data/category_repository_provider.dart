// lib/features/categories/data/category_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'category_repository.dart';

/// Singleton [CategoryRepository] на всё приложение.
final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepository(ref.watch(appDatabaseProvider));
});
