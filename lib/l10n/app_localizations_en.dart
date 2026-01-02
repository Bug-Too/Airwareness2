// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Airwareness2';

  @override
  String get searchLocation => 'Search Location';

  @override
  String get noLocationSelected => 'No location selected';

  @override
  String get unknownLocation => 'Unknown';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get sensitiveGroup => 'Sensitive Group';

  @override
  String get sensitiveGroupDesc =>
      'I have asthma, allergies, or other respiratory conditions.';

  @override
  String get generalPopulation => 'General Population';

  @override
  String get generalPopulationDesc =>
      'I don\'t have any specific respiratory sensitivities.';

  @override
  String get welcomeTitle => 'Welcome to\nAirwareness';

  @override
  String get welcomeSubtitle =>
      'Let\'s customize your experience based on your health needs.';

  @override
  String get wearingMask => 'Wear a mask';

  @override
  String get closeWindows => 'Close windows';

  @override
  String get sunscreen => 'Sunscreen';

  @override
  String get umbrella => 'Umbrella';

  @override
  String get airPurifier => 'Air Purifier On';

  @override
  String get aqiGood => 'Good';

  @override
  String get aqiModerate => 'Moderate';

  @override
  String get aqiUnhealthySensitive => 'Unhealthy for Sensitive Groups';

  @override
  String get aqiUnhealthy => 'Unhealthy';

  @override
  String get aqiVeryUnhealthy => 'Very Unhealthy';

  @override
  String get aqiHazardous => 'Hazardous';

  @override
  String get actGood => 'It’s a great day to be active outside.';

  @override
  String get actModerateGeneral => 'It’s a good day to be active outside.';

  @override
  String get actModerateSensitive =>
      'Consider making outdoor activities shorter and less intense.';

  @override
  String get actUnhealthySensitiveGeneral =>
      'It’s a good day to be active outside.';

  @override
  String get actUnhealthySensitiveSensitive =>
      'Make outdoor activities shorter and less intense. Take more breaks.';

  @override
  String get actUnhealthyGeneral =>
      'Reduce long or intense activities. Take more breaks.';

  @override
  String get actUnhealthySensitive =>
      'Avoid long or intense outdoor activities. Consider moving indoors.';

  @override
  String get actVeryUnhealthyGeneral =>
      'Avoid long or intense activities. Consider moving indoors.';

  @override
  String get actVeryUnhealthySensitive =>
      'Avoid all physical activity outdoors. Move activities indoors.';

  @override
  String get actHazardousGeneral => 'Avoid all physical activity outdoors.';

  @override
  String get actHazardousSensitive =>
      'Remain indoors and keep activity levels low.';
}
