// lib/features/wishlist/presentation/wishlist_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/db/database.dart';
import 'wishlist_provider.dart';
import 'widgets/wish_item_tile.dart';

/// Экран списка позиций.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('WishQueue')),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _ErrorView(error: error),
        data: (items) =>
            items.isEmpty ? const _EmptyView() : _ItemsList(items: items),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/wishlist/new'),
        tooltip: 'Добавить позицию',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ItemsList extends StatelessWidget {
  const _ItemsList({required this.items});

  final List<WishItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = items[index];
        return WishItemTile(
          item: item,
          onTap: () => context.go('/wishlist/${item.id}'),
        );
      },
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Список пуст.\nНажмите +, чтобы добавить первую позицию.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
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
            const Icon(Icons.error_outline, size: 48),
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
