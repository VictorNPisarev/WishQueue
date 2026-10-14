// lib/features/wishlist/presentation/balance_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/db/database.dart';
import '../../incomes/domain/income_status.dart';
import '../../incomes/presentation/incomes_provider.dart';
import '../domain/balance_info.dart';
import '../domain/wish_item_status.dart';
import 'wishlist_provider.dart';

/// Панель баланса: текущее и запланированное поступление с расчётами.
///
/// Если запланированного поступления нет — reserved-позиции вычитаются
/// из текущего. Если есть — reserved уходят в запланированное, а из
/// текущего вычитается только купленное после его получения.
final balanceProvider = Provider<BalanceInfo?>((ref) {
  final incomesAsync = ref.watch(incomesProvider);
  final activeAsync = ref.watch(activeWishlistProvider);
  final boughtAsync = ref.watch(boughtWishlistProvider);

  final incomes = incomesAsync.valueOrNull;
  final active = activeAsync.valueOrNull;
  final bought = boughtAsync.valueOrNull;
  if (incomes == null || active == null || bought == null) return null;

  final currentIncome = _latestReceived(incomes);
  final plannedIncome = _nearestPlanned(incomes);

  if (currentIncome == null && plannedIncome == null) {
    return BalanceInfo.empty;
  }

  // Все reserved-позиции.
  final reservedItems = active.where(
    (i) => i.status == WishItemStatus.reserved.dbValue,
  );
  final reservedTotalMinor = reservedItems.fold<int>(
    0,
    (sum, i) => sum + (i.estimatedMinor ?? 0),
  );

  CurrentIncomeInfo? current;
  if (currentIncome != null) {
    final threshold = currentIncome.receivedAt ?? currentIncome.plannedDate;
    final spentItems = bought.where(
      (i) => i.boughtAt != null && !i.boughtAt!.isBefore(threshold),
    );
    final spentMinor = spentItems.fold<int>(
      0,
      (sum, i) => sum + (i.actualMinor ?? i.estimatedMinor ?? 0),
    );

    // Если запланированного нет — reserved висят на текущем.
    final reservedForCurrent = plannedIncome == null ? reservedTotalMinor : 0;
    final reservedCountForCurrent = plannedIncome == null
        ? reservedItems.length
        : 0;

    current = CurrentIncomeInfo(
      income: currentIncome,
      spentMinor: spentMinor,
      spentCount: spentItems.length,
      reservedMinor: reservedForCurrent,
      reservedCount: reservedCountForCurrent,
    );
  }

  PlannedIncomeInfo? planned;
  if (plannedIncome != null) {
    planned = PlannedIncomeInfo(
      income: plannedIncome,
      reservedMinor: reservedTotalMinor,
      reservedCount: reservedItems.length,
    );
  }

  return BalanceInfo(current: current, planned: planned);
});

/// Последнее полученное поступление (по receivedAt).
Income? _latestReceived(List<Income> incomes) {
  Income? result;
  for (final i in incomes) {
    if (i.status != IncomeStatus.received.dbValue) continue;
    if (result == null) {
      result = i;
      continue;
    }
    final a = i.receivedAt ?? i.plannedDate;
    final b = result.receivedAt ?? result.plannedDate;
    if (a.isAfter(b)) result = i;
  }
  return result;
}

/// Ближайшее запланированное поступление (по plannedDate).
Income? _nearestPlanned(List<Income> incomes) {
  Income? result;
  for (final i in incomes) {
    if (i.status != IncomeStatus.planned.dbValue) continue;
    if (result == null) {
      result = i;
      continue;
    }
    if (i.plannedDate.isBefore(result.plannedDate)) result = i;
  }
  return result;
}
