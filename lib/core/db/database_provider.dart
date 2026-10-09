// lib/core/db/database_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database.dart';

/// Singleton [AppDatabase] на всё приложение.
///
/// **Обязательно переопределяется** в `main.dart` через
/// `ProviderScope(overrides: [appDatabaseProvider.overrideWithValue(db)])`.
/// Тесты переопределяют своим экземпляром (обычно in-memory).
///
/// Паттерн «провайдер без реализации» даёт compile-time-гарантию, что
/// приложение не запустится, если БД не инициализирована.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError(
    'appDatabaseProvider must be overridden in ProviderScope. '
    'See main.dart.',
  );
});
