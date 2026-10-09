// lib/features/wishlist/presentation/widgets/wish_item_tile.dart

import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../domain/wish_item_extensions.dart';
import '../../domain/wish_item_priority.dart';
import '../../domain/wish_item_status.dart';

/// Элемент списка позиций.
class WishItemTile extends StatelessWidget {
  const WishItemTile({super.key, required this.item, required this.onTap});

  final WishItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final priority = WishItemPriority.fromDb(item.priority);
    final status = WishItemStatus.fromDb(item.status);

    return ListTile(
      titleAlignment: ListTileTitleAlignment.center,
      onTap: onTap,
      leading: _PriorityIcon(priority: priority),
      title: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: _titleStyle(context, status),
      ),
      subtitle: _Subtitle(item: item, status: status),
      trailing: _Trailing(item: item, status: status),
    );
  }

  TextStyle? _titleStyle(BuildContext context, WishItemStatus status) {
    final base = Theme.of(context).textTheme.bodyLarge;
    if (status == WishItemStatus.cancelled) {
      return base?.copyWith(
        decoration: TextDecoration.lineThrough,
        color: Theme.of(context).disabledColor,
      );
    }
    return base;
  }
}

class _PriorityIcon extends StatelessWidget {
  const _PriorityIcon({required this.priority});

  final WishItemPriority priority;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (priority) {
      WishItemPriority.urgent => (Icons.priority_high, Colors.red),
      WishItemPriority.high => (Icons.keyboard_arrow_up, Colors.orange),
      WishItemPriority.normal => (Icons.remove, Colors.grey),
      WishItemPriority.someday => (Icons.keyboard_arrow_down, Colors.blueGrey),
    };
    return Icon(icon, color: color);
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.item, required this.status});

  final WishItem item;
  final WishItemStatus status;

  @override
  Widget build(BuildContext context) {
    final notes = item.notes?.trim();
    if (notes == null || notes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Text(
      notes,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.item, required this.status});

  final WishItem item;
  final WishItemStatus status;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == WishItemStatus.reserved)
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.bookmark_outline, size: 18),
          ),
        if (status == WishItemStatus.bought)
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.check_circle, size: 18, color: Colors.green),
          ),
        Text(_priceText(), style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  String _priceText() {
    final price = item.displayPrice;
    if (price == null) return '—';
    return price.format(locale: 'ru_RU');
  }
}
