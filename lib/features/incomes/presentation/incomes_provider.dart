// lib/features/incomes/presentation/incomes_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../data/income_repository_provider.dart';

/// Стрим всех неудалённых поступлений.
///
/// Сортировка — `plannedDate DESC` (свежие/будущие сверху), задаётся
/// в репозитории.
final incomesProvider = StreamProvider<List<Income>>((ref) {
  final repo = ref.watch(incomeRepositoryProvider);
  return repo.watchAll();
});
