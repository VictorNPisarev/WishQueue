// lib/features/wishlist/domain/balance_info.dart

import '../../../core/db/database.dart';

/// Информация о текущем и запланированном поступлении для панели баланса.
class BalanceInfo {
  final CurrentIncomeInfo? current;
  final PlannedIncomeInfo? planned;

  const BalanceInfo({this.current, this.planned});

  /// Есть ли что показывать на панели.
  bool get isEmpty => current == null && planned == null;

  /// Пустой результат.
  static const empty = BalanceInfo();
}

/// Текущее поступление: получено, из него уже тратим.
///
/// [reservedMinor] заполняется, только если запланированного поступления
/// нет — в этом случае reserved висят на текущем.
class CurrentIncomeInfo {
  final Income income;
  final int spentMinor;
  final int spentCount;
  final int reservedMinor;
  final int reservedCount;

  const CurrentIncomeInfo({
    required this.income,
    required this.spentMinor,
    required this.spentCount,
    required this.reservedMinor,
    required this.reservedCount,
  });

  /// Сколько осталось: сумма поступления минус потрачено минус в резерве.
  int get remainingMinor => income.amountMinor - spentMinor - reservedMinor;

  String get currency => income.currency;
}

/// Запланированное поступление: ожидается, под него резервируем.
class PlannedIncomeInfo {
  final Income income;
  final int reservedMinor;
  final int reservedCount;

  const PlannedIncomeInfo({
    required this.income,
    required this.reservedMinor,
    required this.reservedCount,
  });

  /// Сколько остаётся свободным от запланированного.
  int get remainingMinor => income.amountMinor - reservedMinor;

  String get currency => income.currency;
}
