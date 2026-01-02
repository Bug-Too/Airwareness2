import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Airwareness2'**
  String get appTitle;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search Location'**
  String get searchLocation;

  /// No description provided for @noLocationSelected.
  ///
  /// In en, this message translates to:
  /// **'No location selected'**
  String get noLocationSelected;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLocation;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @sensitiveGroup.
  ///
  /// In en, this message translates to:
  /// **'Sensitive Group'**
  String get sensitiveGroup;

  /// No description provided for @sensitiveGroupDesc.
  ///
  /// In en, this message translates to:
  /// **'I have asthma, allergies, or other respiratory conditions.'**
  String get sensitiveGroupDesc;

  /// No description provided for @generalPopulation.
  ///
  /// In en, this message translates to:
  /// **'General Population'**
  String get generalPopulation;

  /// No description provided for @generalPopulationDesc.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have any specific respiratory sensitivities.'**
  String get generalPopulationDesc;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nAirwareness'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s customize your experience based on your health needs.'**
  String get welcomeSubtitle;

  /// No description provided for @wearingMask.
  ///
  /// In en, this message translates to:
  /// **'Wear a mask'**
  String get wearingMask;

  /// No description provided for @closeWindows.
  ///
  /// In en, this message translates to:
  /// **'Close windows'**
  String get closeWindows;

  /// No description provided for @sunscreen.
  ///
  /// In en, this message translates to:
  /// **'Sunscreen'**
  String get sunscreen;

  /// No description provided for @umbrella.
  ///
  /// In en, this message translates to:
  /// **'Umbrella'**
  String get umbrella;

  /// No description provided for @airPurifier.
  ///
  /// In en, this message translates to:
  /// **'Air Purifier On'**
  String get airPurifier;

  /// No description provided for @aqiGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get aqiGood;

  /// No description provided for @aqiModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get aqiModerate;

  /// No description provided for @aqiUnhealthySensitive.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy for Sensitive Groups'**
  String get aqiUnhealthySensitive;

  /// No description provided for @aqiUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Unhealthy'**
  String get aqiUnhealthy;

  /// No description provided for @aqiVeryUnhealthy.
  ///
  /// In en, this message translates to:
  /// **'Very Unhealthy'**
  String get aqiVeryUnhealthy;

  /// No description provided for @aqiHazardous.
  ///
  /// In en, this message translates to:
  /// **'Hazardous'**
  String get aqiHazardous;

  /// No description provided for @actGood.
  ///
  /// In en, this message translates to:
  /// **'It’s a great day to be active outside.'**
  String get actGood;

  /// No description provided for @actModerateGeneral.
  ///
  /// In en, this message translates to:
  /// **'It’s a good day to be active outside.'**
  String get actModerateGeneral;

  /// No description provided for @actModerateSensitive.
  ///
  /// In en, this message translates to:
  /// **'Consider making outdoor activities shorter and less intense.'**
  String get actModerateSensitive;

  /// No description provided for @actUnhealthySensitiveGeneral.
  ///
  /// In en, this message translates to:
  /// **'It’s a good day to be active outside.'**
  String get actUnhealthySensitiveGeneral;

  /// No description provided for @actUnhealthySensitiveSensitive.
  ///
  /// In en, this message translates to:
  /// **'Make outdoor activities shorter and less intense. Take more breaks.'**
  String get actUnhealthySensitiveSensitive;

  /// No description provided for @actUnhealthyGeneral.
  ///
  /// In en, this message translates to:
  /// **'Reduce long or intense activities. Take more breaks.'**
  String get actUnhealthyGeneral;

  /// No description provided for @actUnhealthySensitive.
  ///
  /// In en, this message translates to:
  /// **'Avoid long or intense outdoor activities. Consider moving indoors.'**
  String get actUnhealthySensitive;

  /// No description provided for @actVeryUnhealthyGeneral.
  ///
  /// In en, this message translates to:
  /// **'Avoid long or intense activities. Consider moving indoors.'**
  String get actVeryUnhealthyGeneral;

  /// No description provided for @actVeryUnhealthySensitive.
  ///
  /// In en, this message translates to:
  /// **'Avoid all physical activity outdoors. Move activities indoors.'**
  String get actVeryUnhealthySensitive;

  /// No description provided for @actHazardousGeneral.
  ///
  /// In en, this message translates to:
  /// **'Avoid all physical activity outdoors.'**
  String get actHazardousGeneral;

  /// No description provided for @actHazardousSensitive.
  ///
  /// In en, this message translates to:
  /// **'Remain indoors and keep activity levels low.'**
  String get actHazardousSensitive;
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
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
