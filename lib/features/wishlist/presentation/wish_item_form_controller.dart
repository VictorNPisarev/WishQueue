// lib/features/wishlist/presentation/wish_item_form_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../data/wish_item_repository_provider.dart';
import '../domain/wish_item_priority.dart';
import 'wish_item_form_state.dart';

final wishItemFormControllerProvider = AsyncNotifierProvider.autoDispose
    .family<WishItemFormController, WishItemFormState, String?>(
      WishItemFormController.new,
    );

class WishItemFormController
    extends AutoDisposeFamilyAsyncNotifier<WishItemFormState, String?> {
  @override
  Future<WishItemFormState> build(String? itemId) async {
    if (itemId == null) {
      return WishItemFormState.initial();
    }

    final repo = ref.read(wishItemRepositoryProvider);
    final item = await repo.getById(itemId);

    return WishItemFormState(
      title: item.title,
      estimatedMinor: item.estimatedMinor,
      priority: WishItemPriority.fromDb(item.priority),
      categoryId: item.categoryId,
      notes: item.notes,
      url: item.url,
    );
  }

  void setTitle(String value) =>
      _update((s) => s.copyWith(title: value, validationTitleEmpty: false));

  void setEstimatedMinor(int? value) =>
      _update((s) => s.copyWith(estimatedMinor: value));

  void setPriority(WishItemPriority value) =>
      _update((s) => s.copyWith(priority: value));

  void setCategoryId(String? value) =>
      _update((s) => s.copyWith(categoryId: value));

  void setNotes(String? value) => _update((s) => s.copyWith(notes: value));

  void setUrl(String? value) => _update((s) => s.copyWith(url: value));

  Future<void> save(String? itemId) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final trimmedTitle = current.title.trim();
    if (trimmedTitle.isEmpty) {
      state = AsyncData(current.copyWith(validationTitleEmpty: true));
      return;
    }

    state = AsyncData(
      current.copyWith(isSaving: true, validationTitleEmpty: false),
    );

    try {
      final repo = ref.read(wishItemRepositoryProvider);

      if (itemId == null) {
        await repo.create(
          title: trimmedTitle,
          estimatedMinor: current.estimatedMinor,
          priority: current.priority,
          categoryId: current.categoryId,
          notes: _normalize(current.notes),
          url: _normalize(current.url),
        );
      } else {
        await repo.update(
          id: itemId,
          title: trimmedTitle,
          estimatedMinor: current.estimatedMinor,
          priority: current.priority,
          categoryId: current.categoryId,
          notes: _normalize(current.notes),
          url: _normalize(current.url),
        );
      }

      state = AsyncData(current.copyWith(isSaving: false, isSaved: true));
    } on AppException catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void _update(WishItemFormState Function(WishItemFormState) transform) {
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
