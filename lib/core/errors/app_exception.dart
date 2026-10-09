// lib/core/errors/app_exception.dart

/// Базовый тип доменных исключений приложения.
///
/// Все ошибки, которые бросаются из репозиториев и сервисов,
/// должны быть наследниками [AppException]. Технические ошибки
/// (SqliteException, FormatException, ...) не должны выходить наружу —
/// репозитории оборачивают их в соответствующий подтип.
///
/// [message] — технический, для логов. Не показывается пользователю.
/// Пользовательские сообщения формируются в UI через локализацию.
sealed class AppException implements Exception {
  /// Техническое описание (для логов).
  final String message;

  /// Исходная ошибка, если есть. Для отладки и логов.
  final Object? cause;

  const AppException(this.message, {this.cause});

  @override
  String toString() => cause == null
      ? '$runtimeType: $message'
      : '$runtimeType: $message (cause: $cause)';
}

/// Сущность не найдена.
///
/// Например: `getById` вернул null, а вызывающий код ожидал запись.
final class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.cause});
}

/// Нарушение инварианта или бизнес-правила.
///
/// Например: у категории заполнены и `nameKey`, и `nameCustom`;
/// неизвестное значение `status`; отрицательная сумма.
final class ValidationException extends AppException {
  const ValidationException(super.message, {super.cause});
}

/// Ошибка на уровне БД.
///
/// Репозитории оборачивают сюда `SqliteException` и прочие технические сбои.
final class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.cause});
}

/// Сетевая ошибка (задел на будущее — синхронизация с сервером).
final class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

/// Непредвиденная ошибка — то, что не должно случаться.
///
/// Если сюда попало — значит, где-то в коде протекла техническая ошибка
/// или необработанный случай. Логируется всегда, показывается пользователю
/// как generic «Что-то пошло не так».
final class UnexpectedException extends AppException {
  const UnexpectedException(super.message, {super.cause});
}
