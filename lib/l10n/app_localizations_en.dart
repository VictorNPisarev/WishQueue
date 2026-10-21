// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WishQueue';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get addItem => 'Add item';

  @override
  String get addIncome => 'Add income';

  @override
  String get distribute => 'Distribute';

  @override
  String get cat_auto => 'Auto';

  @override
  String get cat_home => 'Home';

  @override
  String get cat_tools => 'Tools';

  @override
  String get cat_other => 'Other';

  @override
  String get priority_urgent => 'Urgent';

  @override
  String get priority_high => 'High';

  @override
  String get priority_normal => 'Normal';

  @override
  String get priority_someday => 'Someday';

  @override
  String get status_planned => 'Planned';

  @override
  String get status_reserved => 'Reserved';

  @override
  String get status_bought => 'Bought';

  @override
  String get status_cancelled => 'Cancelled';

  @override
  String get wishlistTabActive => 'Active';

  @override
  String get wishlistTabBought => 'Bought';

  @override
  String get addItemTooltip => 'Add item';

  @override
  String get wishlistEmptyActive =>
      'The list is empty.\nTap + to add your first item.';

  @override
  String get wishlistEmptyBought => 'Bought items will appear here.';

  @override
  String get wishlistLoadError => 'Failed to load the list.';

  @override
  String get actionReserve => 'I\'ll buy it';

  @override
  String get actionBuyNow => 'Buy now';

  @override
  String get actionCancel => 'Cancel item';

  @override
  String get actionUnreserve => 'Back to queue';

  @override
  String get actionDelete => 'Delete';

  @override
  String get deleteItemTitle => 'Delete item?';

  @override
  String deleteItemMessage(String title) {
    return '\"$title\" will be deleted permanently.';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get themeColor => 'Theme color';

  @override
  String get selected => 'Selected';

  @override
  String get newItemTitle => 'New item';

  @override
  String get editItemTitle => 'Edit item';

  @override
  String get fieldTitle => 'Title';

  @override
  String get fieldPriceRub => 'Price (₽)';

  @override
  String get fieldPriceHint => 'For example: 30000';

  @override
  String get fieldPriority => 'Priority';

  @override
  String get fieldCategory => 'Category';

  @override
  String get categoryNone => 'No category';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get fieldUrl => 'Link';

  @override
  String get save => 'Save';

  @override
  String get validationTitleEmpty => 'Title must not be empty';

  @override
  String get saveFailed => 'Failed to save';

  @override
  String get loadError => 'Error';

  @override
  String get categoriesLoadError => 'Failed to load categories';

  @override
  String get language => 'Language';

  @override
  String get languageSystem => 'Sistem';

  @override
  String get newIncomeTitle => 'New income';

  @override
  String get editIncomeTitle => 'Edit income';

  @override
  String get fieldAmount => 'Amount';

  @override
  String get fieldAmountHint => 'For example: 80000';

  @override
  String get fieldDate => 'Date';

  @override
  String get fieldWorkedHours => 'Worked hours';

  @override
  String get fieldWorkedHoursHint => 'For example: 120';

  @override
  String get validationAmountInvalid => 'Enter a positive amount';

  @override
  String get incomesTitle => 'Incomes';

  @override
  String get addIncomeTooltip => 'Add income';

  @override
  String get incomesEmpty => 'No incomes yet.\nTap + to add your first one.';

  @override
  String get incomesLoadError => 'Failed to load incomes.';

  @override
  String get actionMarkReceived => 'Mark as received';

  @override
  String get incomesLoadFailed => 'Failed to load';

  @override
  String get deleteIncomeTitle => 'Delete income?';

  @override
  String deleteIncomeMessage(String title) {
    return '\"$title\" will be deleted permanently.';
  }

  @override
  String get statusLabelPlanned => 'Expected';

  @override
  String get statusLabelReceived => 'Received';

  @override
  String get statusLabelCancelled => 'Cancelled';

  @override
  String get balanceCurrent => 'Current';

  @override
  String get balancePlanned => 'Planned';

  @override
  String get balanceSpent => 'Spent';

  @override
  String get balanceReserved => 'Reserved';

  @override
  String get balanceRemaining => 'Free';

  @override
  String balancePositionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'no items',
    );
    return '$_temp0';
  }

  @override
  String get fieldReceivedAt => 'Date received';

  @override
  String get fieldBoughtAt => 'Date purchased';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutApp => 'About WishQueue';

  @override
  String get settingsAboutText =>
      'WishQueue is a lightweight list of planned purchases and expected incomes.';

  @override
  String get settingsVersion => 'Version';

  @override
  String get close => 'Close';

  @override
  String get tabReserved => 'To buy';

  @override
  String get tabPlanned => 'In queue';

  @override
  String get tabBought => 'Bought';

  @override
  String get wishlistEmptyReserved =>
      'Nothing planned to buy yet. Swipe left on the \"In queue\" tab to add.';

  @override
  String get wishlistEmptyPlanned => 'Nothing in queue. Tap + to add.';
}
