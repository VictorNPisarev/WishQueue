// lib/features/incomes/presentation/widgets/income_tile.dart

import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../../../core/utils/money.dart';
import '../../domain/income_status.dart';

/// Элемент списка поступлений.
class IncomeTile extends StatelessWidget {
  const IncomeTile({
    super.key,
    required this.income,
    required this.onTap,
    this.onLongPress,
  });

  final Income income;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final status = IncomeStatus.fromDb(income.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _StatusIcon(status: status),
              const SizedBox(width: 12),
              Expanded(child: _MiddleColumn(income: income)),
              const SizedBox(width: 8),
              _Trailing(income: income),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});

  final IncomeStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      IncomeStatus.planned => (Icons.schedule, Colors.orange),
      IncomeStatus.received => (Icons.check_circle, Colors.green),
      IncomeStatus.cancelled => (Icons.cancel, Colors.grey),
    };
    return Icon(icon, color: color, size: 28);
  }
}

class _MiddleColumn extends StatelessWidget {
  const _MiddleColumn({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context) {
    final notes = income.notes?.trim();
    final dateStr = MaterialLocalizations.of(
      context,
    ).formatCompactDate(income.plannedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          income.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            dateStr,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        if (notes != null && notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              notes,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context) {
    final amount = Money(income.amountMinor, income.currency);
    final locale = Localizations.localeOf(context).toString();

    String? costPerHourText;
    if (income.workedMinutes != null && income.workedMinutes! > 0) {
      final perHourMinor = (income.amountMinor * 60 / income.workedMinutes!)
          .round();
      final costPerHour = Money(perHourMinor, income.currency);
      costPerHourText = costPerHour.format(locale: locale);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          amount.format(locale: locale),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        if (costPerHourText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              costPerHourText,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
