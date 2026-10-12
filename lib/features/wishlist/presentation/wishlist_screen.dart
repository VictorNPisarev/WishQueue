// lib/features/wishlist/presentation/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wishqueue/features/wishlist/domain/wish_item_status.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../data/wish_item_repository_provider.dart';
import 'widgets/swipeable_wish_item_tile.dart';
import 'wishlist_provider.dart';
import '../../settings/presentation/widgets/theme_picker_sheet.dart';

/// Экран списка позиций с двумя вкладками: «Активные» и «Куплено».
class WishlistScreen extends ConsumerStatefulWidget {
  const WishlistScreen({super.key});

  @override
  ConsumerState<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends ConsumerState<WishlistScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: const Text('WishQueue'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'Активные'),
            Tab(icon: Icon(Icons.check_circle_outline), text: 'Куплено'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Цвет темы',
            onPressed: () => showThemePicker(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActiveTab(onTapItem: _openItem, onLongPressItem: _showItemMenu),
          _BoughtTab(onTapItem: _openItem, onLongPressItem: _showItemMenu),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/wishlist/new'),
        tooltip: 'Добавить позицию',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openItem(WishItem item) {
    context.go('/wishlist/${item.id}');
  }

void _showItemMenu(WishItem item) {
    final status = WishItemStatus.fromDb(item.status);

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),

            if (status == WishItemStatus.planned) ...[
              _menuTile(
                icon: Icons.bookmark_add,
                label: 'Куплю',
                onTap: () => _closeAndRun(sheetContext, () => _reserve(item)),
              ),
              _menuTile(
                icon: Icons.shopping_cart_checkout,
                label: 'Купить сейчас',
                onTap: () =>
                    _closeAndRun(sheetContext, () => _markBought(item)),
              ),
              _menuTile(
                icon: Icons.cancel_outlined,
                label: 'Отменить',
                onTap: () => _closeAndRun(sheetContext, () => _cancel(item)),
              ),
            ],

            if (status == WishItemStatus.reserved) ...[
              _menuTile(
                icon: Icons.undo,
                label: 'В очередь',
                onTap: () => _closeAndRun(sheetContext, () => _unreserve(item)),
              ),
              _menuTile(
                icon: Icons.shopping_cart_checkout,
                label: 'Купить сейчас',
                onTap: () =>
                    _closeAndRun(sheetContext, () => _markBought(item)),
              ),
              _menuTile(
                icon: Icons.cancel_outlined,
                label: 'Отменить',
                onTap: () => _closeAndRun(sheetContext, () => _cancel(item)),
              ),
            ],

            _menuTile(
              icon: Icons.delete_outline,
              label: 'Удалить',
              color: Colors.red,
              onTap: () => _closeAndRun(sheetContext, () => _delete(item)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label, style: TextStyle(color: color)),
      onTap: onTap,
    );
  }

  void _closeAndRun(BuildContext sheetContext, Future<void> Function() action) {
    Navigator.pop(sheetContext); // закрываем меню
    action(); // выполняем
  }

  Future<void> _reserve(WishItem item) => _runWithErrorHandling(
    () => ref.read(wishItemRepositoryProvider).reserve(item.id),
  );

  Future<void> _unreserve(WishItem item) => _runWithErrorHandling(
    () => ref.read(wishItemRepositoryProvider).unreserve(item.id),
  );

  Future<void> _markBought(WishItem item) => _runWithErrorHandling(
    () => ref.read(wishItemRepositoryProvider).markBought(item.id),
  );

  Future<void> _cancel(WishItem item) => _runWithErrorHandling(
    () => ref.read(wishItemRepositoryProvider).cancel(item.id),
  );

  Future<void> _delete(WishItem item) async {
    // Удаление — с подтверждением
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить позицию?'),
        content: Text(
          '«${item.title}» будет удалена без возможности восстановления.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    if (!mounted) return;
    await _runWithErrorHandling(
      () => ref.read(wishItemRepositoryProvider).softDelete(item.id),
    );
  }

  Future<void> _runWithErrorHandling(Future<void> Function() action) async {
    try {
      await action();
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message), backgroundColor: Colors.red),
      );
    }
  }
}

// --- Вкладка «Активные» ---

class _ActiveTab extends ConsumerWidget {
  const _ActiveTab({required this.onTapItem, required this.onLongPressItem});

  final void Function(WishItem) onTapItem;
  final void Function(WishItem) onLongPressItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(activeWishlistProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(error: e),
      data: (items) => items.isEmpty
          ? const _EmptyView(
              message:
                  'Список пуст.\nНажмите +, чтобы добавить первую позицию.',
            )
          : _ItemsList(
              items: items,
              onTapItem: onTapItem,
              onLongPressItem: onLongPressItem,
              onReserve: (item) => _reserve(context, ref, item),
              onUnreserve: (item) => _unreserve(context, ref, item),
            ),
    );
  }

  Future<void> _reserve(
    BuildContext context,
    WidgetRef ref,
    WishItem item,
  ) async {
    try {
      await ref.read(wishItemRepositoryProvider).reserve(item.id);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _unreserve(
    BuildContext context,
    WidgetRef ref,
    WishItem item,
  ) async {
    try {
      await ref.read(wishItemRepositoryProvider).unreserve(item.id);
    } on AppException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

// --- Вкладка «Куплено» ---

class _BoughtTab extends ConsumerWidget {
  const _BoughtTab({required this.onTapItem, required this.onLongPressItem});

  final void Function(WishItem) onTapItem;
  final void Function(WishItem) onLongPressItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(boughtWishlistProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(error: e),
      data: (items) => items.isEmpty
          ? const _EmptyView(message: 'Здесь появятся купленные позиции.')
          : _ItemsList(
              items: items,
              onTapItem: onTapItem,
              onLongPressItem: onLongPressItem,
              onReserve: (_) {},
              onUnreserve: (_) {},
            ),
    );
  }
}

// --- Общий список ---

class _ItemsList extends StatelessWidget {
  const _ItemsList({
    required this.items,
    required this.onTapItem,
    required this.onLongPressItem,
    required this.onReserve,
    required this.onUnreserve,
  });

  final List<WishItem> items;
  final void Function(WishItem) onTapItem;
  final void Function(WishItem) onLongPressItem;
  final void Function(WishItem) onReserve;
  final void Function(WishItem) onUnreserve;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return SwipeableWishItemTile(
          item: item,
          onTap: () => onTapItem(item),
          onLongPress: () => onLongPressItem(item),
          onReserve: () => onReserve(item),
          onUnreserve: () => onUnreserve(item),
        );
      },
    );
  }
}

// --- Пустое состояние и ошибка ---

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
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            const Text(
              'Не удалось загрузить список.',
              style: TextStyle(fontSize: 16),
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