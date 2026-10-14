// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/domain/theme_seed.dart';
import '../features/settings/presentation/locale_provider.dart';
import '../features/settings/presentation/theme_provider.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

class WishQueueApp extends ConsumerWidget {
  const WishQueueApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedAsync = ref.watch(themeSeedProvider);
    final seed = seedAsync.valueOrNull ?? ThemeSeed.defaultSeed;

    final localeAsync = ref.watch(appLocaleProvider);
    final locale = localeAsync.valueOrNull?.locale;
    // locale == null → система сама выберет по supportedLocales.

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seed.color),
        useMaterial3: true,
      ),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
