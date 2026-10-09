// lib/features/wishlist/presentation/wish_item_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/money.dart';
import '../../categories/presentation/categories_provider.dart';
import '../domain/wish_item_priority.dart';
import 'wish_item_form_controller.dart';
import 'wish_item_form_state.dart';

/// Экран создания/редактирования позиции.
///
/// [itemId] == null — создание. Иначе — редактирование.
class WishItemFormScreen extends ConsumerStatefulWidget {
  const WishItemFormScreen({super.key, this.itemId});

  final String? itemId;

  @override
  ConsumerState<WishItemFormScreen> createState() => _WishItemFormScreenState();
}

class _WishItemFormScreenState extends ConsumerState<WishItemFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _priceController;
  late final TextEditingController _notesController;
  late final TextEditingController _urlController;

  bool _didPrefill = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _notesController = TextEditingController();
    _urlController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = wishItemFormControllerProvider(widget.itemId);

    // Синхронизация полей с загруженным состоянием — один раз.
    ref.listen(provider, (prev, next) {
      final state = next.valueOrNull;
      if (state == null || _didPrefill) return;
      _didPrefill = true;
      _titleController.text = state.title;
      _notesController.text = state.notes ?? '';
      _urlController.text = state.url ?? '';
      if (state.estimatedMinor != null) {
        _priceController.text = (state.estimatedMinor! / 100).toStringAsFixed(
          2,
        );
      }
    });

    // Реакция на успех и на ошибки.
    ref.listen(provider, (prev, next) {
      final state = next.valueOrNull;
      if (state?.isSaved == true) {
        context.go('/wishlist');
        return;
      }
      if (next is AsyncError) {
        final err = next.error;
        final msg = err is AppException ? err.message : 'Не удалось сохранить';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
      }
    });

    final stateAsync = ref.watch(provider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.itemId == null ? 'Новая позиция' : 'Редактирование'),
      ),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка: $e')),
        data: (state) => _buildForm(state, provider),
      ),
    );
  }

  Widget _buildForm(
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<WishItemFormController, WishItemFormState, String?> provider,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Название',
            errorText: state.validationError,
          ),
          onChanged: (v) => ref.read(provider.notifier).setTitle(v),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'Цена (₽)',
            hintText: 'Например: 30000',
          ),
          onChanged: (v) {
            final parsed = Money.parse(v, 'RUB');
            ref
                .read(provider.notifier)
                .setEstimatedMinor(
                  parsed.minorUnits == 0 ? null : parsed.minorUnits,
                );
          },
        ),
        const SizedBox(height: 16),

        _buildPriorityDropdown(state, provider),

        const SizedBox(height: 16),

        _buildCategoryDropdown(state, provider),

        const SizedBox(height: 16),

        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Заметки'),
          onChanged: (v) => ref.read(provider.notifier).setNotes(v),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          decoration: const InputDecoration(labelText: 'Ссылка'),
          onChanged: (v) => ref.read(provider.notifier).setUrl(v),
        ),
        const SizedBox(height: 24),

        FilledButton(
          onPressed: state.isSaving
              ? null
              : () => ref.read(provider.notifier).save(widget.itemId),
          child: state.isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Сохранить'),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown(
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<WishItemFormController, WishItemFormState, String?> provider,
  ) {
    return DropdownButtonFormField<WishItemPriority>(
      initialValue: state.priority,
      decoration: const InputDecoration(labelText: 'Приоритет'),
      items: WishItemPriority.values
          .map(
            (p) => DropdownMenuItem(value: p, child: Text(_priorityLabel(p))),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) ref.read(provider.notifier).setPriority(v);
      },
    );
  }

  Widget _buildCategoryDropdown(
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<WishItemFormController, WishItemFormState, String?> provider,
  ) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const Text('Не удалось загрузить категории'),
      data: (categories) => DropdownButtonFormField<String?>(
        initialValue: state.categoryId,
        decoration: const InputDecoration(labelText: 'Категория'),
        items: [
          const DropdownMenuItem<String?>(
            value: null,
            child: Text('Без категории'),
          ),
          ...categories.map(
            (c) => DropdownMenuItem<String?>(
              value: c.id,
              child: Text(_categoryLabel(c)),
            ),
          ),
        ],
        onChanged: (v) => ref.read(provider.notifier).setCategoryId(v),
      ),
    );
  }

  String _priorityLabel(WishItemPriority p) => switch (p) {
    WishItemPriority.urgent => 'Срочно',
    WishItemPriority.high => 'Важно',
    WishItemPriority.normal => 'Обычно',
    WishItemPriority.someday => 'Когда-нибудь',
  };

  String _categoryLabel(Category c) => c.nameCustom ?? c.nameKey ?? c.id;
}
