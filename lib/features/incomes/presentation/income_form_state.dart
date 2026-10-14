// lib/features/incomes/presentation/income_form_state.dart

import '../domain/income_status.dart';

/// Состояние формы создания/редактирования поступления.
class IncomeFormState {
  final String title;
  final int? amountMinor;
  final DateTime? plannedDate;
  final String? notes;
  final int? workedMinutes;

  /// Текущий статус записи (не редактируется в форме, но нужен UI,
  /// чтобы решать, показывать ли поле «Дата получения»).
  final String status;

  /// Фактическая дата получения. Редактируется только при [status] == received.
  final DateTime? receivedAt;

  final bool isSaving;
  final bool isSaved;
  final bool validationTitleEmpty;
  final bool validationAmountInvalid;

  const IncomeFormState({
    required this.title,
    required this.amountMinor,
    required this.plannedDate,
    required this.notes,
    required this.workedMinutes,
    required this.status,
    required this.receivedAt,
    this.isSaving = false,
    this.isSaved = false,
    this.validationTitleEmpty = false,
    this.validationAmountInvalid = false,
  });

  factory IncomeFormState.initial() => IncomeFormState(
    title: '',
    amountMinor: null,
    plannedDate: DateTime.now(),
    notes: null,
    workedMinutes: null,
    status: IncomeStatus.planned.dbValue,
    receivedAt: null,
  );

  IncomeFormState copyWith({
    String? title,
    int? amountMinor,
    DateTime? plannedDate,
    String? notes,
    int? workedMinutes,
    String? status,
    DateTime? receivedAt,
    bool? isSaving,
    bool? isSaved,
    bool? validationTitleEmpty,
    bool? validationAmountInvalid,
  }) {
    return IncomeFormState(
      title: title ?? this.title,
      amountMinor: amountMinor ?? this.amountMinor,
      plannedDate: plannedDate ?? this.plannedDate,
      notes: notes ?? this.notes,
      workedMinutes: workedMinutes ?? this.workedMinutes,
      status: status ?? this.status,
      receivedAt: receivedAt ?? this.receivedAt,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      validationTitleEmpty: validationTitleEmpty ?? this.validationTitleEmpty,
      validationAmountInvalid:
          validationAmountInvalid ?? this.validationAmountInvalid,
    );
  }
}
