class Marker {
  int id;
  double latitude;
  double longitude;
  int marketRate;
  String unit;
  String color;
  String createdAt;

  Marker({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.marketRate,
    required this.unit,
    required this.color,
    required this.createdAt,
  });

  factory Marker.fromJson(Map<String, dynamic> data) {
    return Marker(
      id: data['id'] ?? 0,
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
      marketRate: data['marketRate'] ?? 0,
      unit: data['unit'] ?? '',
      color: data['color'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'marketRate': marketRate,
      'unit': unit,
      'color': color,
      'createdAt': createdAt,
    };
  }
}
