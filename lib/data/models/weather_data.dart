class AirQuality {
  final int aqi; // US AQI
  final double pm25;
  final double pm10;

  AirQuality({
    required this.aqi,
    required this.pm25,
    required this.pm10,
  });

  factory AirQuality.fromJson(Map<String, dynamic> json) {
    // Open-Meteo Air Quality API returns hourly data, we'll take the current hour (index 0 for simplicity or match current time)
    // Actually, usually we can request 'current' but let's see how we parse it.
    // For now assuming we get a simplified structure passed from the service.
    return AirQuality(
      aqi: json['us_aqi'] is int ? json['us_aqi'] : (json['us_aqi'] as num).toInt(),
      pm25: (json['pm2_5'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
    );
  }
}

class Weather {
  final double temperature;
  final double uvIndex;
  final double rainProbability; // 0-100
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.uvIndex,
    required this.rainProbability,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['temperature_2m'] as num).toDouble(),
      uvIndex: (json['uv_index'] as num).toDouble(), // Careful, Open-Meteo might put this in daily or hourly
      rainProbability: (json['precipitation_probability'] as num).toDouble(),
      windSpeed: (json['wind_speed_10m'] as num).toDouble(),
    );
  }
}
