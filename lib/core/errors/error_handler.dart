// lib/core/errors/error_handler.dart

import 'dart:developer' as developer;

import 'app_exception.dart';

/// Централизованный обработчик ошибок.
///
/// Сюда стекаются все ошибки приложения: пойманные явно
/// (`try/catch` в репозиториях и notifier'ах) и непойманные
/// (через `FlutterError.onError` и `PlatformDispatcher.onError`).
///
/// Задачи:
/// - логирование (сейчас — `dart:developer`, потом — Sentry/Crashlytics);
/// - трансформация произвольных ошибок в [AppException];
/// - развилка «фатальная / нефатальная» (задел, пока не используется).
///
/// НЕ показывает UI. Показ SnackBar/диалогов — задача UI-слоя.
class ErrorHandler {
  const ErrorHandler();

  /// Обрабатывает ошибку: логирует и, если нужно, отправляет в аналитику.
  ///
  /// [fatal] — если `true`, ошибка считается критичной (например,
  /// падение при старте). Сейчас только для логов, в будущем — для
  /// Crashlytics (fatal vs non-fatal).
  void handle(Object error, StackTrace stackTrace, {bool fatal = false}) {
    final appError = _normalize(error);
    _log(appError, stackTrace, fatal: fatal);
    _report(appError, stackTrace, fatal: fatal);
  }

  /// Приводит любое исключение к [AppException].
  ///
  /// Если ошибка уже является [AppException] — возвращается как есть.
  /// Иначе оборачивается в [UnexpectedException] с сохранением [cause].
  AppException _normalize(Object error) {
    if (error is AppException) return error;
    return UnexpectedException(
      'Unhandled error: ${error.runtimeType}',
      cause: error,
    );
  }

  /// Логирует ошибку. Сейчас — в `dart:developer`, потом заменим на
  /// структурированный вывод (JSON) для Sentry.
  void _log(AppException error, StackTrace stackTrace, {required bool fatal}) {
    final level = fatal
        ? 1000
        : 900; // SEVERE : WARNING (по шкале dart:developer)
    developer.log(
      error.message,
      name: 'wishqueue',
      level: level,
      error: error.cause ?? error,
      stackTrace: stackTrace,
    );
  }

  /// Отправка во внешнюю систему аналитики.
  ///
  /// Пока заглушка. Сюда подключим Sentry/Firebase Crashlytics,
  /// когда появится необходимость.
  void _report(
    AppException error,
    StackTrace stackTrace, {
    required bool fatal,
  }) {
    // TODO: интеграция с Sentry / Crashlytics.
  }
}
