// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/domain/theme_seed.dart';
import '../features/settings/presentation/theme_provider.dart';
import 'router.dart';

class WishQueueApp extends ConsumerWidget {
  const WishQueueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedAsync = ref.watch(themeSeedProvider);

    // Пока читается из БД — используем дефолт. Это доли секунды,
    // и обычно seed уже в кэше к моменту первого рендера.
    final seed = seedAsync.valueOrNull ?? ThemeSeed.defaultSeed;

    return MaterialApp.router(
      title: 'WishQueue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed.color),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
