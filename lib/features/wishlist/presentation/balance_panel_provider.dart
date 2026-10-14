// lib/features/wishlist/presentation/balance_panel_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Свёрнута ли карточка текущего поступления на панели баланса.
final currentCardCollapsedProvider = StateProvider<bool>((ref) => false);

/// Свёрнута ли карточка запланированного поступления.
final plannedCardCollapsedProvider = StateProvider<bool>((ref) => false);
