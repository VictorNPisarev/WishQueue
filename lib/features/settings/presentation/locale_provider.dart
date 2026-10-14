// lib/features/settings/presentation/locale_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository_provider.dart';
import '../domain/app_locale.dart';

/// Контроллер языка приложения: читает выбор из БД, сохраняет изменения.
final appLocaleProvider = AsyncNotifierProvider<LocaleController, AppLocale>(
  LocaleController.new,
);

class LocaleController extends AsyncNotifier<AppLocale> {
  @override
  Future<AppLocale> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.getAppLocale();
  }

  Future<void> setLocale(AppLocale locale) async {
    state = AsyncData(locale);

    final repo = ref.read(settingsRepositoryProvider);
    try {
      await repo.setAppLocale(locale);
    } catch (_) {
      final previous = await repo.getAppLocale();
      state = AsyncData(previous);
      rethrow;
    }
  }
}
