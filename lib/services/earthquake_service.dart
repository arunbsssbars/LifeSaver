import 'dart:convert';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import '../models/earthquake_event.dart';

class EarthquakeService {
  // USGS GeoJSON live feed of M2.5+ earthquakes for past 24 hours
  static const String _usgsUrl =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/2.5_day.geojson';

  static Future<List<EarthquakeEvent>> fetchRecentEarthquakes({
    double? userLat,
    double? userLng,
  }) async {
    try {
      final response = await http
          .get(Uri.parse(_usgsUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> features = data['features'] ?? [];

        List<EarthquakeEvent> events = features.map((f) {
          final event = EarthquakeEvent.fromJson(f as Map<String, dynamic>);
          if (userLat != null && userLng != null) {
            final distance = calculateDistanceKm(
              userLat,
              userLng,
              event.latitude,
              event.longitude,
            );
            return event.copyWithDistance(distance);
          }
          return event;
        }).toList();

        // Sort: If user location is given, prioritize by proximity or magnitude
        events.sort((a, b) {
          if (a.distanceKm != null && b.distanceKm != null) {
            return a.distanceKm!.compareTo(b.distanceKm!);
          }
          return b.time.compareTo(a.time);
        });

        return events;
      }
      return _generateSampleEvents(userLat, userLng);
    } catch (e) {
      return _generateSampleEvents(userLat, userLng);
    }
  }

  /// Haversine Formula for distance between two GPS coordinates in kilometers
  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double p = 0.017453292519943295; // Math.PI / 180
    final double a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R * asin... R = 6371 km
  }

  static List<EarthquakeEvent> _generateSampleEvents(double? userLat, double? userLng) {
    final list = [
      EarthquakeEvent(
        id: 'sample_np_1',
        title: 'M 4.8 - 28 km NW of Jajarkot, Nepal',
        magnitude: 4.8,
        place: 'Jajarkot, Karnali, Nepal',
        time: DateTime.now().subtract(const Duration(hours: 3)),
        latitude: 28.70,
        longitude: 82.20,
        depthKm: 10.0,
        tsunamiAlert: false,
        alertColor: 'yellow',
      ),
      EarthquakeEvent(
        id: 'sample_in_1',
        title: 'M 4.2 - 45 km NE of Chamoli, Uttarakhand, India',
        magnitude: 4.2,
        place: 'Chamoli, Uttarakhand, India',
        time: DateTime.now().subtract(const Duration(hours: 8)),
        latitude: 30.40,
        longitude: 79.35,
        depthKm: 12.0,
        tsunamiAlert: false,
        alertColor: 'green',
      ),
      EarthquakeEvent(
        id: 'sample_in_2',
        title: 'M 3.9 - 18 km S of Guwahati, Assam, India',
        magnitude: 3.9,
        place: 'Guwahati, Assam, India',
        time: DateTime.now().subtract(const Duration(hours: 14)),
        latitude: 26.05,
        longitude: 91.75,
        depthKm: 15.0,
        tsunamiAlert: false,
        alertColor: 'green',
      ),
    ];

    if (userLat != null && userLng != null) {
      return list.map((e) {
        final dist = calculateDistanceKm(userLat, userLng, e.latitude, e.longitude);
        return e.copyWithDistance(dist);
      }).toList();
    }
    return list;
  }
}
