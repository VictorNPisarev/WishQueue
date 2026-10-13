// lib/features/wishlist/presentation/widgets/swipeable_wish_item_tile.dart

import 'package:flutter/material.dart';

import '../../../../core/db/database.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/wish_item_status.dart';
import 'wish_item_tile.dart';

/// Обёртка над [WishItemTile] с обработкой свайпов.
///
/// Свайп влево (planned → reserved) — «куплю».
/// Свайп вправо (reserved → planned) — «вернуть в очередь».
class SwipeableWishItemTile extends StatelessWidget {
  const SwipeableWishItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onReserve,
    required this.onUnreserve,
    this.onLongPress,
  });

  final WishItem item;
  final VoidCallback onTap;
  final VoidCallback onReserve;
  final VoidCallback onUnreserve;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = WishItemStatus.fromDb(item.status);

    final direction = switch (status) {
      WishItemStatus.planned => DismissDirection.endToStart,
      WishItemStatus.reserved => DismissDirection.startToEnd,
      WishItemStatus.bought => DismissDirection.none,
      WishItemStatus.cancelled => DismissDirection.none,
    };

    return Dismissible(
      key: ValueKey(item.id),
      direction: direction,
      background: _buildBackground(
        color: Colors.orange,
        icon: Icons.undo,
        text: l10n.actionUnreserve,
        alignment: Alignment.centerLeft,
      ),
      secondaryBackground: _buildBackground(
        color: Colors.blue,
        icon: Icons.bookmark_add,
        text: l10n.actionReserve,
        alignment: Alignment.centerRight,
      ),
      confirmDismiss: (dir) async {
        if (dir == DismissDirection.startToEnd) {
          onUnreserve();
        } else if (dir == DismissDirection.endToStart) {
          onReserve();
        }
        return false;
      },
      child: WishItemTile(item: item, onTap: onTap, onLongPress: onLongPress),
    );
  }

  Widget _buildBackground({
    required Color color,
    required IconData icon,
    required String text,
    required Alignment alignment,
  }) {
    final isLeft = alignment == Alignment.centerLeft;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLeft) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ] else ...[
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
