// lib/features/wishlist/presentation/widgets/balance_panel.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/money.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/balance_info.dart';
import '../balance_provider.dart';
import '../balance_panel_provider.dart';

/// Панель баланса: текущее и запланированное поступление.
///
/// Показывается на вкладке «Активные» над списком.
/// Если данных нет — не отображается.
class BalancePanel extends ConsumerWidget {
  const BalancePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(balanceProvider);
    if (balance == null || balance.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (balance.current != null) _CurrentCard(info: balance.current!),
          if (balance.current != null && balance.planned != null)
            const SizedBox(height: 8),
          if (balance.planned != null) _PlannedCard(info: balance.planned!),
        ],
      ),
    );
  }
}

// --- Текущее поступление ---

class _CurrentCard extends ConsumerWidget {
  const _CurrentCard({required this.info});

  final CurrentIncomeInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final collapsed = ref.watch(currentCardCollapsedProvider);

    final amount = Money(info.income.amountMinor, info.currency);
    final remaining = Money(info.remainingMinor, info.currency);
    final dateStr = MaterialLocalizations.of(
      context,
    ).formatCompactDate(info.income.receivedAt ?? info.income.plannedDate);

    final details = <_DetailRow>[];
    if (info.spentCount > 0) {
      final spent = Money(info.spentMinor, info.currency);
      details.add(
        _DetailRow(
          label: l10n.balanceSpent,
          value:
              '${spent.format(locale: locale)} '
              '(${l10n.balancePositionCount(info.spentCount)})',
        ),
      );
    }
    if (info.reservedCount > 0) {
      final reserved = Money(info.reservedMinor, info.currency);
      details.add(
        _DetailRow(
          label: l10n.balanceReserved,
          value:
              '${reserved.format(locale: locale)} '
              '(${l10n.balancePositionCount(info.reservedCount)})',
        ),
      );
    }

    return _BalanceCard(
      icon: Icons.account_balance_wallet,
      iconColor: Colors.blue,
      label: l10n.balanceCurrent,
      title: '${info.income.title} · $dateStr',
      amount: amount.format(locale: locale),
      details: details,
      remainingLabel: l10n.balanceRemaining,
      remainingValue: remaining.format(locale: locale),
      remainingColor: info.remainingMinor >= 0 ? Colors.green : Colors.red,
      collapsed: collapsed,
      onToggle: () {
        ref.read(currentCardCollapsedProvider.notifier).state = !collapsed;
      },
    );
  }
}

// --- Запланированное поступление ---

class _PlannedCard extends ConsumerWidget {
  const _PlannedCard({required this.info});

  final PlannedIncomeInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final collapsed = ref.watch(plannedCardCollapsedProvider);

    final amount = Money(info.income.amountMinor, info.currency);
    final reserved = Money(info.reservedMinor, info.currency);
    final remaining = Money(info.remainingMinor, info.currency);
    final dateStr = MaterialLocalizations.of(
      context,
    ).formatCompactDate(info.income.plannedDate);

    final details = <_DetailRow>[];
    if (info.reservedCount > 0) {
      details.add(
        _DetailRow(
          label: l10n.balanceReserved,
          value:
              '${reserved.format(locale: locale)} '
              '(${l10n.balancePositionCount(info.reservedCount)})',
        ),
      );
    }

    return _BalanceCard(
      icon: Icons.schedule,
      iconColor: Colors.orange,
      label: l10n.balancePlanned,
      title: '${info.income.title} · $dateStr',
      amount: amount.format(locale: locale),
      details: details,
      remainingLabel: l10n.balanceRemaining,
      remainingValue: remaining.format(locale: locale),
      remainingColor: info.remainingMinor >= 0 ? Colors.green : Colors.red,
      collapsed: collapsed,
      onToggle: () {
        ref.read(plannedCardCollapsedProvider.notifier).state = !collapsed;
      },
    );
  }
}

// --- Общая вёрстка карточки ---

class _DetailRow {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.title,
    required this.amount,
    required this.details,
    required this.remainingLabel,
    required this.remainingValue,
    required this.remainingColor,
    required this.collapsed,
    required this.onToggle,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String title;
  final String amount;
  final List<_DetailRow> details;
  final String remainingLabel;
  final String remainingValue;
  final Color remainingColor;
  final bool collapsed;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя строка — всегда видна.
              Row(
                children: [
                  Icon(icon, color: iconColor, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // В свёрнутом виде справа — свободно; в развёрнутом — сумма.
                  if (collapsed)
                    Text(
                      remainingValue,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: remainingColor,
                      ),
                    )
                  else
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    collapsed
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Colors.grey,
                  ),
                ],
              ),

              // Развёрнутая часть.
              if (!collapsed) ...[
                const Divider(height: 16),
                ...details.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Text(
                          '${d.label}: ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            d.value,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (details.isNotEmpty) const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$remainingLabel: ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      remainingValue,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: remainingColor,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
