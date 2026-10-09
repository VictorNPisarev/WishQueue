// lib/core/utils/money.dart
import 'package:intl/intl.dart';

class Money {
  final int minorUnits; // копейки
  final String currency; // 'RUB', 'USD'

  const Money(this.minorUnits, this.currency);

  const Money.zero(this.currency) : minorUnits = 0;

  /// Парсит пользовательский ввод в минорные единицы.
  /// Поддерживает "1 234,56", "1234.56", "1234".
  static Money parse(String input, String currency) {
    final cleaned = input
        .replaceAll('\u00A0', '')
        .replaceAll(' ', '')
        .replaceAll(',', '.')
        .trim();

    if (cleaned.isEmpty) return Money.zero(currency);

    final value = double.tryParse(cleaned);
    if (value == null) return Money.zero(currency);

    final minor = (value * 100).round();
    return Money(minor, currency);
  }

  /// Форматирует в строку. Локаль по умолчанию — ru_RU.
  String format({String? locale}) {
    final fmt = NumberFormat.currency(
      locale: locale ?? 'ru_RU',
      name: currency,
      symbol: _symbolFor(currency),
      decimalDigits: 2,
    );
    return fmt.format(minorUnits / 100);
  }

  static String _symbolFor(String currency) {
    switch (currency) {
      case 'RUB':
        return '₽';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      default:
        return currency;
    }
  }

  Money copyWith({int? minorUnits, String? currency}) =>
      Money(minorUnits ?? this.minorUnits, currency ?? this.currency);

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minorUnits == minorUnits &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() => format();
}
