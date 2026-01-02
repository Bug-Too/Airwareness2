import 'package:flutter/material.dart';
import '../data/models/location_result.dart';
import '../data/models/weather_data.dart';
import '../data/services/user_preferences.dart';
import '../data/services/weather_service.dart';

class AppProvider with ChangeNotifier {
  final UserPreferences _prefs = UserPreferences();
  final WeatherService _weatherService = WeatherService();

  bool _isSensitive = false;
  bool _isOnboardingComplete = false;
  LocationResult? _currentLocation;
  
  AirQuality? _airQuality;
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  bool get isSensitive => _isSensitive;
  bool get isOnboardingComplete => _isOnboardingComplete;
  LocationResult? get currentLocation => _currentLocation;
  AirQuality? get airQuality => _airQuality;
  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> init() async {
    _isSensitive = await _prefs.isSensitive();
    _isOnboardingComplete = await _prefs.isOnboardingComplete();
    _currentLocation = await _prefs.getSavedLocation();
    
    if (_isOnboardingComplete && _currentLocation != null) {
      fetchData();
    }
    notifyListeners();
  }

  Future<void> completeOnboarding(bool isSensitive) async {
    _isSensitive = isSensitive;
    _isOnboardingComplete = true;
    await _prefs.setSensitive(isSensitive);
    await _prefs.setOnboardingComplete(true);
    notifyListeners();
  }

  Future<void> setLocation(LocationResult location) async {
    _currentLocation = location;
    await _prefs.saveLocation(location);
    fetchData(); // Refresh data for new location
    notifyListeners();
  }

  Future<void> fetchData() async {
    if (_currentLocation == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final lat = _currentLocation!.latitude;
      final long = _currentLocation!.longitude;

      final results = await Future.wait([
        _weatherService.fetchAirQuality(lat, long),
        _weatherService.fetchWeather(lat, long),
      ]);

      _airQuality = results[0] as AirQuality;
      _weather = results[1] as Weather;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
