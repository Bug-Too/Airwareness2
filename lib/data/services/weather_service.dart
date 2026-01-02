import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_result.dart';
import '../models/weather_data.dart';

class WeatherService {
  static const String _geocodingUrl = 'https://geocoding-api.open-meteo.com/v1/search';
  static const String _airQualityUrl = 'https://air-quality-api.open-meteo.com/v1/air-quality';
  static const String _weatherUrl = 'https://api.open-meteo.com/v1/forecast';

  Future<List<LocationResult>> searchCity(String query) async {
    final response = await http.get(Uri.parse('$_geocodingUrl?name=$query&count=10&language=en&format=json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null) {
        return (data['results'] as List)
            .map((e) => LocationResult.fromJson(e))
            .toList();
      }
      return [];
    } else {
      throw Exception('Failed to load cities');
    }
  }

  Future<AirQuality> fetchAirQuality(double lat, double long) async {
    // requesting US AQI and PM values
    final url = '$_airQualityUrl?latitude=$lat&longitude=$long&current=us_aqi,pm10,pm2_5';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final current = data['current'];
      return AirQuality.fromJson(current);
    } else {
      throw Exception('Failed to load air quality data');
    }
  }

  Future<Weather> fetchWeather(double lat, double long) async {
     final url = '$_weatherUrl?latitude=$lat&longitude=$long&current=temperature_2m,wind_speed_10m&hourly=uv_index,precipitation_probability&timezone=auto';
     final response = await http.get(Uri.parse(url));
     
     if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final current = data['current'];
        final hourly = data['hourly'];
        
        String currentTimeStr = current['time'];
        // Note: Open-Meteo returns ISO8601 usually e.g. "2023-11-13T14:45"
        // But for hourly mapping, we need the hour floor.
        // Actually current['time'] might be :45 or :30 depending on update interval? 
        // Usually it matches one of the hourly slots if we are lucky, or we need to round.
        // Hourly slots are :00.
        // Let's parse and round down to hour.
        
        DateTime remoteTime = DateTime.parse(currentTimeStr);
        // We want YYYY-MM-DDTHH:00
        String targetTimeStr = DateTime(remoteTime.year, remoteTime.month, remoteTime.day, remoteTime.hour)
            .toIso8601String().substring(0, 16); // "2023-11-13T14:00" approx

        // Actually Open-Meteo time format in JSON is "yyyy-mm-ddThh:mm"
        // We can just try to match the prefix or parse.
        
        double uv = 0.0;
        double rainProb = 0.0;
        
        List<dynamic> timeList = hourly['time'];
        int limit = timeList.length;
        
        int matchIndex = -1;
        
        for(int i=0; i<limit; i++) {
          if (timeList[i] == targetTimeStr || timeList[i].toString().startsWith(targetTimeStr)) {
            matchIndex = i;
            break;
          }
        }
        
        if (matchIndex != -1) {
          uv = (hourly['uv_index'][matchIndex] as num).toDouble();
          rainProb = (hourly['precipitation_probability'][matchIndex] as num).toDouble();
        } else {
           // Fallback to hour index if string match fails
           int hourIndex = remoteTime.hour;
           if (hourIndex < hourly['uv_index'].length) {
              uv = (hourly['uv_index'][hourIndex] as num).toDouble();
              rainProb = (hourly['precipitation_probability'][hourIndex] as num).toDouble();
           }
        }

        return Weather(
          temperature: (current['temperature_2m'] as num).toDouble(),
          windSpeed: (current['wind_speed_10m'] as num).toDouble(),
          uvIndex: uv,
          rainProbability: rainProb,
        );
     }
     throw Exception('Failed to load weather data');
  }


  Future<String?> getCityNameFromCoordinates(double lat, double long) async {
    try {
      final reverseUrl = 'https://geocoding-api.open-meteo.com/v1/reverse?latitude=$lat&longitude=$long&count=1&language=en&format=json';
      final response = await http.get(Uri.parse(reverseUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] != null && (data['results'] as List).isNotEmpty) {
           final place = data['results'][0];
           return place['name'] ?? place['city'] ?? place['town'] ?? place['village'];
        }
      }
    } catch (e) {
      // debugPrint(e.toString());
    }
    return null;
  }
}
