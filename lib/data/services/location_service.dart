import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/location_result.dart';
import 'weather_service.dart';

class LocationService {
  final WeatherService _weatherService = WeatherService();

  Future<LocationResult?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return null;
    } 

    final position = await Geolocator.getCurrentPosition();
    return _getLocationFromCoordinates(position);
  }
  
  Future<LocationResult?> _getLocationFromCoordinates(Position position) async {
    String name = 'Unknown';
    String country = '';

    // 1. Try Native Geocoding
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        name = place.locality ?? place.subAdministrativeArea ?? 'Unknown';
        country = place.country ?? '';
      }
    } catch (e) {
      // Native failed
    }

    // 2. Fallback to API if name is Unknown or Empty
    if (name == 'Unknown' || name.isEmpty) {
      try {
        final apiName = await _weatherService.getCityNameFromCoordinates(
          position.latitude, 
          position.longitude
        );
        if (apiName != null && apiName.isNotEmpty) {
          name = apiName;
        }
      } catch (e) {
        // API failed
      }
    }

    return LocationResult(
      name: name,
      country: country,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
