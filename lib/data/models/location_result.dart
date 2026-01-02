import 'package:equatable/equatable.dart';

class LocationResult extends Equatable {
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  const LocationResult({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.country,
  });

  factory LocationResult.fromJson(Map<String, dynamic> json) {
    return LocationResult(
      name: json['name'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      country: json['country'] ?? '',
    );
  }

  @override
  List<Object?> get props => [name, latitude, longitude, country];
}
