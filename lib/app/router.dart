// lib/app/router.dart

import 'package:go_router/go_router.dart';

import '../features/incomes/presentation/income_form_screen.dart';
import '../features/incomes/presentation/incomes_screen.dart';
import '../features/wishlist/presentation/wish_item_form_screen.dart';
import '../features/wishlist/presentation/wishlist_screen.dart';
import '../features/settings/presentation/settings_screen.dart';

/// Корневой роутер приложения.
final appRouter = GoRouter(
  initialLocation: '/wishlist',
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/wishlist'),

    // Wishlist
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const WishItemFormScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              WishItemFormScreen(itemId: state.pathParameters['id']),
        ),
      ],
    ),

    // Incomes
    GoRoute(
      path: '/incomes',
      builder: (context, state) => const IncomesScreen(),
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => const IncomeFormScreen(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              IncomeFormScreen(incomeId: state.pathParameters['id']),
        ),
      ],
    ),

    // Settings
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
