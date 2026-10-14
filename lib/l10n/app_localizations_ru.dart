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

  @override
  String get wishlistTabActive => 'Активные';

  @override
  String get wishlistTabBought => 'Куплено';

  @override
  String get addItemTooltip => 'Добавить позицию';

  @override
  String get wishlistEmptyActive =>
      'Список пуст.\nНажмите +, чтобы добавить первую позицию.';

  @override
  String get wishlistEmptyBought => 'Здесь появятся купленные позиции.';

  @override
  String get wishlistLoadError => 'Не удалось загрузить список.';

  @override
  String get actionReserve => 'Куплю';

  @override
  String get actionBuyNow => 'Купить сейчас';

  @override
  String get actionCancel => 'Отменить';

  @override
  String get actionUnreserve => 'В очередь';

  @override
  String get actionDelete => 'Удалить';

  @override
  String get deleteItemTitle => 'Удалить позицию?';

  @override
  String deleteItemMessage(String title) {
    return '«$title» будет удалена без возможности восстановления.';
  }

  @override
  String get cancel => 'Отмена';

  @override
  String get themeColor => 'Цвет темы';

  @override
  String get selected => 'Выбрано';

  @override
  String get newItemTitle => 'Новая позиция';

  @override
  String get editItemTitle => 'Редактирование';

  @override
  String get fieldTitle => 'Название';

  @override
  String get fieldPriceRub => 'Цена (₽)';

  @override
  String get fieldPriceHint => 'Например: 30000';

  @override
  String get fieldPriority => 'Приоритет';

  @override
  String get fieldCategory => 'Категория';

  @override
  String get categoryNone => 'Без категории';

  @override
  String get fieldNotes => 'Заметки';

  @override
  String get fieldUrl => 'Ссылка';

  @override
  String get save => 'Сохранить';

  @override
  String get validationTitleEmpty => 'Название не может быть пустым';

  @override
  String get saveFailed => 'Не удалось сохранить';

  @override
  String get loadError => 'Ошибка';

  @override
  String get categoriesLoadError => 'Не удалось загрузить категории';

  @override
  String get language => 'Язык';

  @override
  String get languageSystem => 'Системный';
}
