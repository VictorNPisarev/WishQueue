// lib/features/wishlist/presentation/wish_item_form_state.dart

import '../domain/wish_item_priority.dart';

class WishItemFormState {
  final String title;
  final int? estimatedMinor;
  final WishItemPriority priority;
  final String? categoryId;
  final String? notes;
  final String? url;
  final bool isSaving;
  final bool isSaved;
  final bool validationTitleEmpty;

  const WishItemFormState({
    required this.title,
    required this.estimatedMinor,
    required this.priority,
    required this.categoryId,
    required this.notes,
    required this.url,
    this.isSaving = false,
    this.isSaved = false,
    this.validationTitleEmpty = false,
  });

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
    bool? isSaved,
    bool? validationTitleEmpty,
  }) {
    return WishItemFormState(
      title: title ?? this.title,
      estimatedMinor: estimatedMinor ?? this.estimatedMinor,
      priority: priority ?? this.priority,
      categoryId: categoryId ?? this.categoryId,
      notes: notes ?? this.notes,
      url: url ?? this.url,
      isSaving: isSaving ?? this.isSaving,
      isSaved: isSaved ?? this.isSaved,
      validationTitleEmpty: validationTitleEmpty ?? this.validationTitleEmpty,
    );
  }
}
