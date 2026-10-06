class EarthquakeEvent {
  final String id;
  final String title;
  final double magnitude;
  final String place;
  final DateTime time;
  final double latitude;
  final double longitude;
  final double depthKm;
  final bool tsunamiAlert;
  final String? alertColor;
  final double? distanceKm;

  EarthquakeEvent({
    required this.id,
    required this.title,
    required this.magnitude,
    required this.place,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.depthKm,
    required this.tsunamiAlert,
    this.alertColor,
    this.distanceKm,
  });

  factory EarthquakeEvent.fromJson(Map<String, dynamic> json) {
    final props = json['properties'] ?? {};
    final geom = json['geometry'] ?? {};
    final coords = (geom['coordinates'] as List<dynamic>?) ?? [0.0, 0.0, 0.0];

    return EarthquakeEvent(
      id: json['id'] ?? '',
      title: props['title'] ?? 'Seismic Event',
      magnitude: (props['mag'] as num?)?.toDouble() ?? 0.0,
      place: props['place'] ?? 'Unknown Location',
      time: DateTime.fromMillisecondsSinceEpoch(props['time'] ?? 0),
      longitude: (coords[0] as num).toDouble(),
      latitude: (coords[1] as num).toDouble(),
      depthKm: coords.length > 2 ? (coords[2] as num).toDouble() : 0.0,
      tsunamiAlert: (props['tsunami'] == 1),
      alertColor: props['alert'],
    );
  }

  EarthquakeEvent copyWithDistance(double km) {
    return EarthquakeEvent(
      id: id,
      title: title,
      magnitude: magnitude,
      place: place,
      time: time,
      latitude: latitude,
      longitude: longitude,
      depthKm: depthKm,
      tsunamiAlert: tsunamiAlert,
      alertColor: alertColor,
      distanceKm: km,
    );
  }
}
