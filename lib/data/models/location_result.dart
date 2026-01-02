class LocationResult {
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  LocationResult({
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
}
