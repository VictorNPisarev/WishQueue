// lib/features/wishlist/presentation/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import '../../../core/errors/app_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/presentation/widgets/theme_picker_sheet.dart';
import '../data/wish_item_repository_provider.dart';
import '../domain/wish_item_status.dart';
import 'widgets/swipeable_wish_item_tile.dart';
import 'wishlist_provider.dart';
import '../../settings/presentation/widgets/locale_picker_sheet.dart';

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
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.list_alt), text: l10n.wishlistTabActive),
            Tab(
              icon: const Icon(Icons.check_circle_outline),
              text: l10n.wishlistTabBought,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
            onPressed: () => showLocalePicker(context),
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: l10n.themeColor,
            onPressed: () => showThemePicker(context),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActiveTab(
            onTapItem: _openItem,
            onLongPressItem: _showItemMenu,
            onReserve: _reserve,
            onUnreserve: _unreserve,
          ),
          _BoughtTab(
            onTapItem: _openItem,
            onLongPressItem: _showItemMenu,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/wishlist/new'),
        tooltip: l10n.addItemTooltip,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openItem(WishItem item) {
    context.go('/wishlist/${item.id}');
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
    final l10n = AppLocalizations.of(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteItemTitle),
        content: Text(l10n.deleteItemMessage(item.title)),
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
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showItemMenu(WishItem item) {
    final l10n = AppLocalizations.of(context);
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
                label: l10n.actionReserve,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _reserve(item),
                ),
              ),
              _menuTile(
                icon: Icons.shopping_cart_checkout,
                label: l10n.actionBuyNow,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _markBought(item),
                ),
              ),
              _menuTile(
                icon: Icons.cancel_outlined,
                label: l10n.actionCancel,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _cancel(item),
                ),
              ),
            ],

            if (status == WishItemStatus.reserved) ...[
              _menuTile(
                icon: Icons.undo,
                label: l10n.actionUnreserve,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _unreserve(item),
                ),
              ),
              _menuTile(
                icon: Icons.shopping_cart_checkout,
                label: l10n.actionBuyNow,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _markBought(item),
                ),
              ),
              _menuTile(
                icon: Icons.cancel_outlined,
                label: l10n.actionCancel,
                onTap: () => _closeAndRun(
                  sheetContext,
                  () => _cancel(item),
                ),
              ),
            ],

            _menuTile(
              icon: Icons.delete_outline,
              label: l10n.actionDelete,
              color: Colors.red,
              onTap: () => _closeAndRun(
                sheetContext,
                () => _delete(item),
              ),
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
    Navigator.pop(sheetContext);
    action();
  }
}

class _ActiveTab extends ConsumerWidget {
  const _ActiveTab({
    required this.onTapItem,
    required this.onLongPressItem,
    required this.onReserve,
    required this.onUnreserve,
  });

  final void Function(WishItem) onTapItem;
  final void Function(WishItem) onLongPressItem;
  final void Function(WishItem) onReserve;
  final void Function(WishItem) onUnreserve;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(activeWishlistProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(error: e),
      data: (items) => items.isEmpty
          ? _EmptyView(
              message: l10n.wishlistEmptyActive,
              icon: Icons.inbox_outlined,
            )
          : _ItemsList(
              items: items,
              onTapItem: onTapItem,
              onLongPressItem: onLongPressItem,
              onReserve: onReserve,
              onUnreserve: onUnreserve,
            ),
    );
  }
}

class _BoughtTab extends ConsumerWidget {
  const _BoughtTab({
    required this.onTapItem,
    required this.onLongPressItem,
  });

  final void Function(WishItem) onTapItem;
  final void Function(WishItem) onLongPressItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final itemsAsync = ref.watch(boughtWishlistProvider);

    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(error: e),
      data: (items) => items.isEmpty
          ? _EmptyView(
              message: l10n.wishlistEmptyBought,
              icon: Icons.check_circle_outline,
            )
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

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.message, required this.icon});

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
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
              l10n.wishlistLoadError,
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