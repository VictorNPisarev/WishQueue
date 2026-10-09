// lib/features/categories/presentation/categories_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/category_repository_provider.dart';

/// Стрим всех неудалённых категорий, отсортированных по sortOrder.
final categoriesProvider = StreamProvider<List<Category>>((ref) {
  final repo = ref.watch(categoryRepositoryProvider);
  return repo.watchAll();
});
