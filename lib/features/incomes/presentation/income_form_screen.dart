// lib/features/incomes/presentation/income_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/utils/money.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/income_status.dart';
import 'income_form_controller.dart';
import 'income_form_state.dart';

/// Экран создания/редактирования поступления.
///
/// [incomeId] == null — создание. Иначе — редактирование.
class IncomeFormScreen extends ConsumerStatefulWidget {
  const IncomeFormScreen({super.key, this.incomeId});

  final String? incomeId;

  @override
  ConsumerState<IncomeFormScreen> createState() => _IncomeFormScreenState();
}

class _IncomeFormScreenState extends ConsumerState<IncomeFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
  late final TextEditingController _workedController;
  late final TextEditingController _notesController;

  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _amountController = TextEditingController();
    _workedController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _workedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = incomeFormControllerProvider(widget.incomeId);

    ref.listen(provider, (prev, next) {
      final state = next.valueOrNull;
      if (state == null || _didPrefill) return;
      _didPrefill = true;
      _titleController.text = state.title;
      _notesController.text = state.notes ?? '';
      if (state.amountMinor != null) {
        _amountController.text = (state.amountMinor! / 100).toStringAsFixed(2);
      }
      if (state.workedMinutes != null) {
        _workedController.text = (state.workedMinutes! / 60).toStringAsFixed(2);
      }
    });

    ref.listen(provider, (prev, next) {
      final state = next.valueOrNull;
      if (state?.isSaved == true) {
        context.pop();
        return;
      }
      if (next is AsyncError) {
        final err = next.error;
        final msg = err is AppException ? err.message : l10n.saveFailed;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    });

    final stateAsync = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.incomeId == null ? l10n.newIncomeTitle : l10n.editIncomeTitle,
        ),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.loadError}: $e')),
        data: (state) => _buildForm(state, provider, l10n),
      ),
    );
  }

  Widget _buildForm(
    IncomeFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      IncomeFormController,
      IncomeFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    final isReceived = state.status == IncomeStatus.received.dbValue;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: l10n.fieldTitle,
            errorText: state.validationTitleEmpty
                ? l10n.validationTitleEmpty
                : null,
          ),
          onChanged: (v) => ref.read(provider.notifier).setTitle(v),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.fieldAmount,
            hintText: l10n.fieldAmountHint,
            errorText: state.validationAmountInvalid
                ? l10n.validationAmountInvalid
                : null,
          ),
          onChanged: (v) {
            final parsed = Money.parse(v, 'RUB');
            ref
                .read(provider.notifier)
                .setAmountMinor(
                  parsed.minorUnits == 0 ? null : parsed.minorUnits,
                );
          },
        ),
        const SizedBox(height: 16),

        _buildDateField(context, state, provider, l10n),

        // Поле «Дата получения» — только для received.
        if (isReceived) ...[
          const SizedBox(height: 16),
          _buildReceivedAtField(context, state, provider, l10n),
        ],

        const SizedBox(height: 16),

        TextFormField(
          controller: _workedController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.fieldWorkedHours,
            hintText: l10n.fieldWorkedHoursHint,
          ),
          onChanged: (v) {
            final hours = double.tryParse(v.replaceAll(',', '.'));
            final minutes = hours == null ? null : (hours * 60).round();
            ref.read(provider.notifier).setWorkedMinutes(minutes);
          },
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(labelText: l10n.fieldNotes),
          onChanged: (v) => ref.read(provider.notifier).setNotes(v),
        ),
        const SizedBox(height: 24),

        FilledButton(
          onPressed: state.isSaving
              ? null
              : () => ref.read(provider.notifier).save(widget.incomeId),
          child: state.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    IncomeFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      IncomeFormController,
      IncomeFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    final date = state.plannedDate ?? DateTime.now();
    final formatted = MaterialLocalizations.of(context).formatCompactDate(date);

    return InkWell(
      onTap: () => _pickDate(context, provider, date),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldDate,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(formatted, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildReceivedAtField(
    BuildContext context,
    IncomeFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      IncomeFormController,
      IncomeFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    final date = state.receivedAt ?? DateTime.now();
    final formatted = MaterialLocalizations.of(context).formatCompactDate(date);

    return InkWell(
      onTap: () => _pickReceivedAt(context, provider, date),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldReceivedAt,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(formatted, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    AutoDisposeFamilyAsyncNotifierProvider<
      IncomeFormController,
      IncomeFormState,
      String?
    >
    provider,
    DateTime initial,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    ref.read(provider.notifier).setPlannedDate(picked);
  }

  Future<void> _pickReceivedAt(
    BuildContext context,
    AutoDisposeFamilyAsyncNotifierProvider<
      IncomeFormController,
      IncomeFormState,
      String?
    >
    provider,
    DateTime initial,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    ref.read(provider.notifier).setReceivedAt(picked);
  }
}
