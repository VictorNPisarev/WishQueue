// lib/features/settings/presentation/theme_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_repository_provider.dart';
import '../domain/theme_seed.dart';

/// Контроллер темы: читает выбранный seed из БД, сохраняет изменения.
final themeSeedProvider = AsyncNotifierProvider<ThemeController, ThemeSeed>(
  ThemeController.new,
);

class ThemeController extends AsyncNotifier<ThemeSeed> {
  @override
  Future<ThemeSeed> build() async {
    final repo = ref.read(settingsRepositoryProvider);
    return repo.getThemeSeed();
  }

  /// Устанавливает новый seed и сохраняет в БД.
  Future<void> setSeed(ThemeSeed seed) async {
    // Оптимистично: сразу меняем UI.
    state = AsyncData(seed);

    final repo = ref.read(settingsRepositoryProvider);
    try {
      await repo.setThemeSeed(seed);
    } catch (_) {
      // При ошибке — вернуть предыдущее значение.
      final previous = await repo.getThemeSeed();
      state = AsyncData(previous);
      rethrow;
    }
  }
}
