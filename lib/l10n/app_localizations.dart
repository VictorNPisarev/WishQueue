import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('es', 'MX'),
    Locale('ru'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'WishQueue'**
  String get appTitle;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItem;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @distribute.
  ///
  /// In en, this message translates to:
  /// **'Distribute'**
  String get distribute;

  /// No description provided for @cat_auto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get cat_auto;

  /// No description provided for @cat_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get cat_home;

  /// No description provided for @cat_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get cat_tools;

  /// No description provided for @cat_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get cat_other;

  /// No description provided for @priority_urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get priority_urgent;

  /// No description provided for @priority_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priority_high;

  /// No description provided for @priority_normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get priority_normal;

  /// No description provided for @priority_someday.
  ///
  /// In en, this message translates to:
  /// **'Someday'**
  String get priority_someday;

  /// No description provided for @status_planned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get status_planned;

  /// No description provided for @status_reserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get status_reserved;

  /// No description provided for @status_bought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get status_bought;

  /// No description provided for @status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get status_cancelled;

  /// No description provided for @wishlistTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get wishlistTabActive;

  /// No description provided for @wishlistTabBought.
  ///
  /// In en, this message translates to:
  /// **'Bought'**
  String get wishlistTabBought;

  /// No description provided for @addItemTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add item'**
  String get addItemTooltip;

  /// No description provided for @wishlistEmptyActive.
  ///
  /// In en, this message translates to:
  /// **'The list is empty.\nTap + to add your first item.'**
  String get wishlistEmptyActive;

  /// No description provided for @wishlistEmptyBought.
  ///
  /// In en, this message translates to:
  /// **'Bought items will appear here.'**
  String get wishlistEmptyBought;

  /// No description provided for @wishlistLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load the list.'**
  String get wishlistLoadError;

  /// No description provided for @actionReserve.
  ///
  /// In en, this message translates to:
  /// **'I\'ll buy it'**
  String get actionReserve;

  /// No description provided for @actionBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy now'**
  String get actionBuyNow;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel item'**
  String get actionCancel;

  /// No description provided for @actionUnreserve.
  ///
  /// In en, this message translates to:
  /// **'Back to queue'**
  String get actionUnreserve;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete item?'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be deleted permanently.'**
  String deleteItemMessage(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get themeColor;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @newItemTitle.
  ///
  /// In en, this message translates to:
  /// **'New item'**
  String get newItemTitle;

  /// No description provided for @editItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get editItemTitle;

  /// No description provided for @fieldTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get fieldTitle;

  /// No description provided for @fieldPriceRub.
  ///
  /// In en, this message translates to:
  /// **'Price (₽)'**
  String get fieldPriceRub;

  /// No description provided for @fieldPriceHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 30000'**
  String get fieldPriceHint;

  /// No description provided for @fieldPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get fieldPriority;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @categoryNone.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get categoryNone;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @fieldUrl.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get fieldUrl;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @validationTitleEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title must not be empty'**
  String get validationTitleEmpty;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get saveFailed;

  /// No description provided for @loadError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get loadError;

  /// No description provided for @categoriesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load categories'**
  String get categoriesLoadError;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Sistem'**
  String get languageSystem;

  /// No description provided for @newIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'New income'**
  String get newIncomeTitle;

  /// No description provided for @editIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get editIncomeTitle;

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @fieldAmountHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 80000'**
  String get fieldAmountHint;

  /// No description provided for @fieldDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get fieldDate;

  /// No description provided for @fieldWorkedHours.
  ///
  /// In en, this message translates to:
  /// **'Worked hours'**
  String get fieldWorkedHours;

  /// No description provided for @fieldWorkedHoursHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 120'**
  String get fieldWorkedHoursHint;

  /// No description provided for @validationAmountInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive amount'**
  String get validationAmountInvalid;

  /// No description provided for @incomesTitle.
  ///
  /// In en, this message translates to:
  /// **'Incomes'**
  String get incomesTitle;

  /// No description provided for @addIncomeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncomeTooltip;

  /// No description provided for @incomesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No incomes yet.\nTap + to add your first one.'**
  String get incomesEmpty;

  /// No description provided for @incomesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load incomes.'**
  String get incomesLoadError;

  /// No description provided for @actionMarkReceived.
  ///
  /// In en, this message translates to:
  /// **'Mark as received'**
  String get actionMarkReceived;

  /// No description provided for @incomesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load'**
  String get incomesLoadFailed;

  /// No description provided for @deleteIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete income?'**
  String get deleteIncomeTitle;

  /// No description provided for @deleteIncomeMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" will be deleted permanently.'**
  String deleteIncomeMessage(String title);

  /// No description provided for @statusLabelPlanned.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get statusLabelPlanned;

  /// No description provided for @statusLabelReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get statusLabelReceived;

  /// No description provided for @statusLabelCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusLabelCancelled;

  /// No description provided for @balanceCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get balanceCurrent;

  /// No description provided for @balancePlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get balancePlanned;

  /// No description provided for @balanceSpent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get balanceSpent;

  /// No description provided for @balanceReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get balanceReserved;

  /// No description provided for @balanceRemaining.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get balanceRemaining;

  /// No description provided for @balancePositionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {no items} =1 {1 item} other {{count} items}}'**
  String balancePositionCount(int count);

  /// No description provided for @fieldReceivedAt.
  ///
  /// In en, this message translates to:
  /// **'Date received'**
  String get fieldReceivedAt;

  /// No description provided for @fieldBoughtAt.
  ///
  /// In en, this message translates to:
  /// **'Date purchased'**
  String get fieldBoughtAt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'es':
      {
        switch (locale.countryCode) {
          case 'MX':
            return AppLocalizationsEsMx();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
