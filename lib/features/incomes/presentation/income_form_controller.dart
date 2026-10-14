// lib/features/incomes/presentation/income_form_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../data/income_repository_provider.dart';
import 'income_form_state.dart';

/// Контроллер формы создания/редактирования поступления.
///
/// Параметр (`.family`): `null` — создание, иначе id существующего.
final incomeFormControllerProvider = AsyncNotifierProvider.autoDispose
    .family<IncomeFormController, IncomeFormState, String?>(
      IncomeFormController.new,
    );

class IncomeFormController
    extends AutoDisposeFamilyAsyncNotifier<IncomeFormState, String?> {
  @override
  Future<IncomeFormState> build(String? incomeId) async {
    if (incomeId == null) {
      return IncomeFormState.initial();
    }

    final repo = ref.read(incomeRepositoryProvider);
    final income = await repo.getById(incomeId);

    return IncomeFormState(
      title: income.title,
      amountMinor: income.amountMinor,
      plannedDate: income.plannedDate,
      notes: income.notes,
      workedMinutes: income.workedMinutes,
      status: income.status,
      receivedAt: income.receivedAt,
    );
  }

  void setTitle(String value) =>
      _update((s) => s.copyWith(title: value, validationTitleEmpty: false));

  void setAmountMinor(int? value) => _update(
    (s) => s.copyWith(amountMinor: value, validationAmountInvalid: false),
  );

  void setPlannedDate(DateTime value) =>
      _update((s) => s.copyWith(plannedDate: value));

  void setNotes(String? value) => _update((s) => s.copyWith(notes: value));

  void setWorkedMinutes(int? value) =>
      _update((s) => s.copyWith(workedMinutes: value));

  void setReceivedAt(DateTime? value) =>
      _update((s) => s.copyWith(receivedAt: value));

  Future<void> save(String? incomeId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final trimmedTitle = current.title.trim();

    if (trimmedTitle.isEmpty) {
      state = AsyncData(current.copyWith(validationTitleEmpty: true));
      return;
    }

    if (current.amountMinor == null || current.amountMinor! <= 0) {
      state = AsyncData(current.copyWith(validationAmountInvalid: true));
      return;
    }

    if (current.plannedDate == null) {
      return;
    }

    state = AsyncData(
      current.copyWith(
        isSaving: true,
        validationTitleEmpty: false,
        validationAmountInvalid: false,
      ),
    );

    try {
      final repo = ref.read(incomeRepositoryProvider);

      if (incomeId == null) {
        await repo.create(
          title: trimmedTitle,
          amountMinor: current.amountMinor!,
          plannedDate: current.plannedDate!,
          notes: _normalize(current.notes),
          workedMinutes: current.workedMinutes,
        );
      } else {
        await repo.update(
          id: incomeId,
          title: trimmedTitle,
          amountMinor: current.amountMinor,
          plannedDate: current.plannedDate,
          notes: _normalize(current.notes),
          workedMinutes: current.workedMinutes,
          receivedAt: current.receivedAt,
        );
      }

      state = AsyncData(current.copyWith(isSaving: false, isSaved: true));
    } on AppException catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _update(IncomeFormState Function(IncomeFormState) transform) {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(transform(current));
  }

  String? _normalize(String? s) {
    if (s == null) return null;
    final t = s.trim();
    return t.isEmpty ? null : t;
  }
}
