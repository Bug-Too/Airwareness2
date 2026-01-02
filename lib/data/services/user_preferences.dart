import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_result.dart';

class UserPreferences {
  static const String keyIsSensitive = 'isSensitive';
  static const String keyOnboardingComplete = 'onboardingComplete';
  static const String keySavedLocation = 'savedLocation';

  Future<void> setSensitive(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyIsSensitive, value);
  }

  Future<bool> isSensitive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyIsSensitive) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(keyOnboardingComplete, value);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(keyOnboardingComplete) ?? false;
  }

  Future<void> saveLocation(LocationResult location) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode({
      'name': location.name,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'country': location.country,
    });
    await prefs.setString(keySavedLocation, jsonString);
  }

  Future<LocationResult?> getSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(keySavedLocation);
    if (jsonString != null) {
      return LocationResult.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
