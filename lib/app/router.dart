// lib/app/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/wishlist/presentation/wish_item_form_screen.dart';
import '../features/wishlist/presentation/wishlist_screen.dart';

/// Корневой роутер приложения.
final appRouter = GoRouter(
  initialLocation: '/wishlist',
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/wishlist'),
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
  ],
);
