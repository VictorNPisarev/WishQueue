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
}
