// lib/features/wishlist/presentation/wish_item_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/utils/money.dart';
import '../../../l10n/app_localizations.dart';
import '../../categories/presentation/categories_provider.dart';
import '../domain/wish_item_priority.dart';
import 'wish_item_form_controller.dart';
import 'wish_item_form_state.dart';
import '../domain/wish_item_status.dart';

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
    final l10n = AppLocalizations.of(context);
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
        //context.go('/wishlist');
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
          widget.itemId == null ? l10n.newItemTitle : l10n.editItemTitle,
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
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      WishItemFormController,
      WishItemFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
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
          controller: _priceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.fieldPriceRub,
            hintText: l10n.fieldPriceHint,
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

        _buildPriorityDropdown(state, provider, l10n),

        const SizedBox(height: 16),

        _buildCategoryDropdown(state, provider, l10n),

        const SizedBox(height: 16),

        TextFormField(
          controller: _notesController,
          maxLines: 3,
          decoration: InputDecoration(labelText: l10n.fieldNotes),
          onChanged: (v) => ref.read(provider.notifier).setNotes(v),
        ),
        const SizedBox(height: 16),

        TextFormField(
          controller: _urlController,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(labelText: l10n.fieldUrl),
          onChanged: (v) => ref.read(provider.notifier).setUrl(v),
        ),
        const SizedBox(height: 24),

        // Поле «Дата покупки» — только для bought.
        if (state.status == WishItemStatus.bought.dbValue) ...[
          const SizedBox(height: 16),
          _buildBoughtAtField(context, state, provider, l10n),
        ],

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
              : Text(l10n.save),
        ),
      ],
    );
  }

  Widget _buildPriorityDropdown(
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      WishItemFormController,
      WishItemFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    return DropdownButtonFormField<WishItemPriority>(
      initialValue: state.priority,
      decoration: InputDecoration(labelText: l10n.fieldPriority),
      items: WishItemPriority.values
          .map(
            (p) => DropdownMenuItem(
              value: p,
              child: Text(_priorityLabel(p, l10n)),
            ),
          )
          .toList(),
      onChanged: (v) {
        if (v != null) ref.read(provider.notifier).setPriority(v);
      },
    );
  }

  Widget _buildCategoryDropdown(
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      WishItemFormController,
      WishItemFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => Text(l10n.categoriesLoadError),
      data: (categories) => DropdownButtonFormField<String?>(
        initialValue: state.categoryId,
        decoration: InputDecoration(labelText: l10n.fieldCategory),
        items: [
          DropdownMenuItem<String?>(
            value: null,
            child: Text(l10n.categoryNone),
          ),
          ...categories.map(
            (c) => DropdownMenuItem<String?>(
              value: c.id,
              child: Text(_categoryLabel(c, l10n)),
            ),
          ),
        ],
        onChanged: (v) => ref.read(provider.notifier).setCategoryId(v),
      ),
    );
  }

  String _priorityLabel(WishItemPriority p, AppLocalizations l10n) =>
      switch (p) {
        WishItemPriority.urgent => l10n.priority_urgent,
        WishItemPriority.high => l10n.priority_high,
        WishItemPriority.normal => l10n.priority_normal,
        WishItemPriority.someday => l10n.priority_someday,
      };

  String _categoryLabel(Category c, AppLocalizations l10n) {
    if (c.isSystem && c.nameKey != null) {
      return _translateCategoryKey(c.nameKey!, l10n);
    }
    return c.nameCustom ?? c.id;
  }

  String _translateCategoryKey(String key, AppLocalizations l10n) {
    switch (key) {
      case 'cat_auto':
        return l10n.cat_auto;
      case 'cat_home':
        return l10n.cat_home;
      case 'cat_tools':
        return l10n.cat_tools;
      case 'cat_other':
        return l10n.cat_other;
      default:
        return key;
    }
  }

  Widget _buildBoughtAtField(
    BuildContext context,
    WishItemFormState state,
    AutoDisposeFamilyAsyncNotifierProvider<
      WishItemFormController,
      WishItemFormState,
      String?
    >
    provider,
    AppLocalizations l10n,
  ) {
    final date = state.boughtAt ?? DateTime.now();
    final formatted = MaterialLocalizations.of(context).formatCompactDate(date);

    return InkWell(
      onTap: () => _pickBoughtAt(context, provider, date),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n.fieldBoughtAt,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        child: Text(formatted, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Future<void> _pickBoughtAt(
    BuildContext context,
    AutoDisposeFamilyAsyncNotifierProvider<
      WishItemFormController,
      WishItemFormState,
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
    ref.read(provider.notifier).setBoughtAt(picked);
  }
}
