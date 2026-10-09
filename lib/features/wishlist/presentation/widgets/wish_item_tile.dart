// lib/features/wishlist/presentation/widgets/wish_item_tile.dart

import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../domain/wish_item_extensions.dart';
import '../../domain/wish_item_priority.dart';
import '../../domain/wish_item_status.dart';

/// Элемент списка позиций.
///
/// Своя вёрстка (InkWell + Row) вместо ListTile — для полного контроля
/// над выравниванием и кастомным контентом (иконки статуса, цена,
/// в будущем — категория).
class WishItemTile extends StatelessWidget {
  const WishItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.onLongPress,
  });

  final WishItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final priority = WishItemPriority.fromDb(item.priority);
    final status = WishItemStatus.fromDb(item.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _PriorityIcon(priority: priority),
              const SizedBox(width: 12),
              Expanded(
                child: _MiddleColumn(item: item, status: status),
              ),
              const SizedBox(width: 8),
              _Trailing(item: item, status: status),
            ],
          ),
        ),
      ),
    );
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
    return Icon(icon, color: color, size: 28);
  }
}

class _MiddleColumn extends StatelessWidget {
  const _MiddleColumn({required this.item, required this.status});

  final WishItem item;
  final WishItemStatus status;

  @override
  Widget build(BuildContext context) {
    final cancelled = status == WishItemStatus.cancelled;
    final notes = item.notes?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: cancelled ? TextDecoration.lineThrough : null,
            color: cancelled ? Theme.of(context).disabledColor : null,
          ),
        ),
        if (notes != null && notes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              notes,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.item, required this.status});

  final WishItem item;
  final WishItemStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == WishItemStatus.reserved)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Icon(Icons.bookmark, size: 18, color: Colors.blue),
          ),
        if (status == WishItemStatus.bought)
          const Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Icon(Icons.check_circle, size: 18, color: Colors.green),
          ),
        Text(
          _priceText(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  String _priceText() {
    final price = status == WishItemStatus.bought
        ? (item.actualPrice ?? item.estimatedPrice)
        : item.estimatedPrice;
    if (price == null) return '—';
    return price.format(locale: 'ru_RU');
  }
}
