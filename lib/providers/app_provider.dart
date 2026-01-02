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
  // Derived State (Business Logic)
  bool get showMask {
    final aqi = _airQuality?.aqi ?? 0;
    if (_isSensitive) return aqi > 100;
    return aqi > 150;
  }

  bool get showSunscreen {
    final uv = _weather?.uvIndex ?? 0;
    return uv > 3;
  }

  bool get showUmbrella {
    final rain = _weather?.rainProbability ?? 0;
    return rain > 30;
  }

  bool get closeWindows {
    final aqi = _airQuality?.aqi ?? 0;
    return aqi > 100;
  }

  bool get purifierOn {
    final aqi = _airQuality?.aqi ?? 0;
    return aqi > 50;
  }

  String get aqiLabel {
    final aqi = _airQuality?.aqi ?? 0;
    if (aqi <= 50) return 'Good';
    if (aqi <= 100) return 'Moderate';
    if (aqi <= 150) return 'Unhealthy for Sensitive Groups';
    if (aqi <= 200) return 'Unhealthy';
    if (aqi <= 300) return 'Very Unhealthy';
    return 'Hazardous';
  }

  String get activityRecommendation {
    final aqi = _airQuality?.aqi ?? 0;
     if (aqi <= 50) return 'It’s a great day to be active outside.';
     if (aqi <= 100) {
       return _isSensitive 
           ? 'Consider making outdoor activities shorter and less intense.' 
           : 'It’s a good day to be active outside.';
     }
     if (aqi <= 150) {
       return _isSensitive 
           ? 'Make outdoor activities shorter and less intense. Take more breaks.' 
           : 'It’s a good day to be active outside.';
     }
     if (aqi <= 200) {
       return _isSensitive 
           ? 'Avoid long or intense outdoor activities. Consider moving indoors.' 
           : 'Reduce long or intense activities. Take more breaks.';
     }
     if (aqi <= 300) {
       return _isSensitive 
           ? 'Avoid all physical activity outdoors. Move activities indoors.' 
           : 'Avoid long or intense activities. Consider moving indoors.';
     }
     // Hazardous
     return _isSensitive
         ? 'Remain indoors and keep activity levels low.'
         : 'Avoid all physical activity outdoors.';
  }

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
