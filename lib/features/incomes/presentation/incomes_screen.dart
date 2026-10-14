// lib/features/incomes/presentation/incomes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../data/income_repository_provider.dart';
import '../domain/income_status.dart';
import 'incomes_provider.dart';
import 'widgets/income_tile.dart';

/// Экран списка поступлений.
class IncomesScreen extends ConsumerWidget {
  const IncomesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final incomesAsync = ref.watch(incomesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.incomesTitle)),
      body: incomesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(error: e),
        data: (incomes) => incomes.isEmpty
            ? _EmptyView(message: l10n.incomesEmpty)
            : _IncomesList(incomes: incomes),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/incomes/new'),
        tooltip: l10n.addIncomeTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _IncomesList extends ConsumerWidget {
  const _IncomesList({required this.incomes});

  final List<Income> incomes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: incomes.length,
      itemBuilder: (context, index) {
        final income = incomes[index];
        return _SwipeableIncomeTile(income: income);
      },
    );
  }
}

class _SwipeableIncomeTile extends ConsumerWidget {
  const _SwipeableIncomeTile({required this.income});

  final Income income;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = IncomeStatus.fromDb(income.status);

    // Свайп только для planned: влево → отметить полученным.
    final direction = status == IncomeStatus.planned
        ? DismissDirection.endToStart
        : DismissDirection.none;

    return Dismissible(
      key: ValueKey(income.id),
      direction: direction,
      background: _buildBackground(
        color: Colors.green,
        icon: Icons.check_circle,
        text: l10n.actionMarkReceived,
        alignment: Alignment.centerRight,
      ),
      secondaryBackground: _buildBackground(
        color: Colors.green,
        icon: Icons.check_circle,
        text: l10n.actionMarkReceived,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (dir) async {
        await _markReceived(context, ref, income);
        return false;
      },
      child: IncomeTile(
        income: income,
        onTap: () => context.push('/incomes/${income.id}'),
        onLongPress: () => _showMenu(context, ref, income),
      ),
    );
  }

  Widget _buildBackground({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(icon, color: Colors.white),
        ],
      ),
    );
  }

  Future<void> _markReceived(
    BuildContext context,
    WidgetRef ref,
    Income income,
  ) async {
    try {
      await ref.read(incomeRepositoryProvider).markReceived(income.id);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showMenu(BuildContext context, WidgetRef ref, Income income) {
    final l10n = AppLocalizations.of(context);
    final status = IncomeStatus.fromDb(income.status);

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                income.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),

            if (status == IncomeStatus.planned) ...[
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(l10n.actionMarkReceived),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _markReceived(context, ref, income);
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel_outlined),
                title: Text(l10n.actionCancel),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _cancel(context, ref, income);
                },
              ),
            ],

            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                l10n.actionDelete,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _delete(context, ref, income, l10n);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancel(
    BuildContext context,
    WidgetRef ref,
    Income income,
  ) async {
    try {
      await ref.read(incomeRepositoryProvider).cancel(income.id);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Income income,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteIncomeTitle),
        content: Text(l10n.deleteIncomeMessage(income.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    try {
      await ref.read(incomeRepositoryProvider).softDelete(income.id);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              l10n.incomesLoadError,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
