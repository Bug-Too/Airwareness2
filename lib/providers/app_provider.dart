import 'package:flutter/material.dart';
import '../data/models/location_result.dart';
import '../data/models/weather_data.dart';
import '../data/services/user_preferences.dart';
import '../data/services/weather_service.dart';
import '../data/services/location_service.dart';

class AppProvider with ChangeNotifier {
  final UserPreferences _prefs = UserPreferences();
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();

  bool _isSensitive = false;
  bool _isOnboardingComplete = false;
  LocationResult? _currentLocation;
  bool _isInitialized = false;
  
  bool get isSensitive => _isSensitive;
  bool get isOnboardingComplete => _isOnboardingComplete;
  bool get isInitialized => _isInitialized;
  
  AirQuality? _airQuality;
  Weather? _weather;
  bool _isLoading = false;
  String? _error;
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    notifyListeners();
  }

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

  // Return a key to map to localization in UI
  String get aqiLabelKey {
    final aqi = _airQuality?.aqi ?? 0;
    if (aqi <= 50) return 'aqiGood';
    if (aqi <= 100) return 'aqiModerate';
    if (aqi <= 150) return 'aqiUnhealthySensitive';
    if (aqi <= 200) return 'aqiUnhealthy';
    if (aqi <= 300) return 'aqiVeryUnhealthy';
    return 'aqiHazardous';
  }

  // Return key for activity recommendation
  String get activityRecommendationKey {
    final aqi = _airQuality?.aqi ?? 0;
     if (aqi <= 50) return 'actGood';
     if (aqi <= 100) {
       return _isSensitive ? 'actModerateSensitive' : 'actModerateGeneral';
     }
     if (aqi <= 150) {
       return _isSensitive ? 'actUnhealthySensitiveSensitive' : 'actUnhealthySensitiveGeneral';
     }
     if (aqi <= 200) {
       return _isSensitive ? 'actUnhealthySensitive' : 'actUnhealthyGeneral';
     }
     if (aqi <= 300) {
       return _isSensitive ? 'actVeryUnhealthySensitive' : 'actVeryUnhealthyGeneral';
     }
     return _isSensitive ? 'actHazardousSensitive' : 'actHazardousGeneral';
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
    
    // If onboarding is complete but no location is selected (e.g. first run or cleared), try device location
    if (_isOnboardingComplete && _currentLocation == null) {
      await useDeviceLocation();
    }
    
    if (_isOnboardingComplete && _currentLocation != null) {
      fetchData();
    }
    
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding(bool isSensitive) async {
    _isSensitive = isSensitive;
    _isOnboardingComplete = true;
    await _prefs.setSensitive(isSensitive);
    await _prefs.setOnboardingComplete(true);
    
    // Try to get location immediately after onboarding
    await useDeviceLocation();
    
    notifyListeners();
  }

  Future<void> setLocation(LocationResult location) async {
    _currentLocation = location;
    await _prefs.saveLocation(location);
    fetchData(); // Refresh data for new location
    notifyListeners();
  }
  
  Future<void> useDeviceLocation() async {
    _isLoading = true;
    notifyListeners();
    
    final location = await _locationService.determinePosition();
    if (location != null) {
      _currentLocation = location;
      await _prefs.saveLocation(location);
      await fetchData();
    }
    
    _isLoading = false;
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
