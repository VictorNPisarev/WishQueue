// lib/features/incomes/domain/income_status.dart

/// Статусы поступления.
///
/// Хранятся в БД как строки. Здесь — типизированный доступ
/// из кода, чтобы не опечататься в литералах.
enum IncomeStatus {
  planned,
  received,
  cancelled;

  /// Строковое представление для БД.
  String get dbValue => name;

  /// Парсит значение из БД. Бросает [FormatException], если неизвестное.
  static IncomeStatus fromDb(String value) {
    for (final s in IncomeStatus.values) {
      if (s.dbValue == value) return s;
    }
    throw FormatException('Unknown IncomeStatus: $value');
  }
}