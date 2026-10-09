// lib/features/incomes/data/income_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database_provider.dart';
import 'income_repository.dart';

/// Singleton [IncomeRepository] на всё приложение.
final incomeRepositoryProvider = Provider<IncomeRepository>((ref) {
  return IncomeRepository(ref.watch(appDatabaseProvider));
});
