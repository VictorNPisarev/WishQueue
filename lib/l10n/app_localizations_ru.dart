// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Очередь желаемого';

  @override
  String get wishlistTitle => 'Список к покупке';

  @override
  String get addItem => 'Добавить товар';

  @override
  String get addIncome => 'Добавить приход';

  @override
  String get distribute => 'Распределить';

  @override
  String get cat_auto => 'Авто';

  @override
  String get cat_home => 'Дом';

  @override
  String get cat_tools => 'Инструменты';

  @override
  String get cat_other => 'Другое';

  @override
  String get priority_urgent => 'Неотложный';

  @override
  String get priority_high => 'Высокий';

  @override
  String get priority_normal => 'Обычный';

  @override
  String get priority_someday => 'Когда-нибудь';

  @override
  String get status_planned => 'Запланирован';

  @override
  String get status_reserved => 'Зарезервирован';

  @override
  String get status_bought => 'Куплен';

  @override
  String get status_cancelled => 'Отменен';
}
