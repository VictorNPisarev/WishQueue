// lib/features/wishlist/presentation/wish_item_form_state.dart

import '../domain/wish_item_priority.dart';

/// Состояние формы создания/редактирования позиции.
class WishItemFormState {
  final String title;
  final int? estimatedMinor;
  final WishItemPriority priority;
  final String? categoryId;
  final String? notes;
  final String? url;
  final bool isSaving;
  final String? validationError;
  final bool isSaved;

  const WishItemFormState({
    required this.title,
    required this.estimatedMinor,
    required this.priority,
    required this.categoryId,
    required this.notes,
    required this.url,
    this.isSaving = false,
    this.validationError,
    this.isSaved = false,
  });

  /// Пустое состояние для режима создания.
  factory WishItemFormState.initial() => const WishItemFormState(
    title: '',
    estimatedMinor: null,
    priority: WishItemPriority.normal,
    categoryId: null,
    notes: null,
    url: null,
  );

  WishItemFormState copyWith({
    String? title,
    int? estimatedMinor,
    WishItemPriority? priority,
    String? categoryId,
    String? notes,
    String? url,
    bool? isSaving,
    String? validationError,
    bool clearValidationError = false,
    bool? isSaved,
  }) {
    return WishItemFormState(
      title: title ?? this.title,
      estimatedMinor: estimatedMinor ?? this.estimatedMinor,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      url: url ?? this.url,
      isSaving: isSaving ?? this.isSaving,
      validationError: clearValidationError
          ? null
          : (validationError ?? this.validationError),
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
