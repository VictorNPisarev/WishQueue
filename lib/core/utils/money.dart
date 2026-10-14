// lib/core/utils/money.dart

import 'package:intl/intl.dart';

class Money {
  final int minorUnits;
  final String currency;

  const Money(this.minorUnits, this.currency);

  const Money.zero(this.currency) : minorUnits = 0;

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

  /// Форматирует в строку.
  ///
  /// Локаль влияет на разделители тысяч и десятичный разделитель
  /// (запятая или точка), но **не** на символ валюты: он всегда
  /// берётся из [currency].
  String format({String? locale}) {
    final normalizedLocale = _normalizeLocale(locale);
    final fmt = NumberFormat.currency(
      locale: normalizedLocale,
      name: currency,
      symbol: _symbolFor(currency),
      decimalDigits: 2,
    );
    return fmt.format(minorUnits / 100);
  }

  /// Приводит локаль к формату, который понимает `intl`.
  ///
  /// - `zh_Hans` → `zh` (скрипт отбрасываем, intl не поддерживает).
  /// - `es_MX` → `es_MX` (страна поддерживается).
  /// - `ru` → `ru`.
  static String _normalizeLocale(String? locale) {
    if (locale == null || locale.isEmpty) return 'ru_RU';

    // Формат Flutter: 'zh_Hans', 'es_MX', 'ru'.
    final parts = locale.split('_');
    if (parts.length == 1) return parts[0];

    // Если второй сегмент — 4 буквы (скрипт, напр. 'Hans'), отбрасываем.
    final second = parts[1];
    if (second.length == 4) {
      return parts[0];
    }

    // Иначе — это страна (2 буквы), оставляем как есть.
    return locale;
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
