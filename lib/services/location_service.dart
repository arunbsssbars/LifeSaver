import 'package:geolocator/geolocator.dart';
import '../models/region_preset.dart';

class LocationService {
  /// Request GPS permission and fetch current position
  static Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

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

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  /// Detects if coordinates fall within Nepal bounding box (approx 26.34 to 30.45° N, 80.06 to 88.20° E)
  static String detectCountryCode(double lat, double lng) {
    if (lat >= 26.3 && lat <= 30.5 && lng >= 80.0 && lng <= 88.3) {
      return 'NP';
    }
    // Default to India for South Asian subcontinent
    return 'IN';
  }

  /// Finds the closest monitored river basin preset to the user's coordinates
  static RegionPreset findClosestPreset(double lat, double lng) {
    RegionPreset closest = RegionPreset.presets.first;
    double minDistance = double.infinity;

    for (final preset in RegionPreset.presets) {
      final distance = Geolocator.distanceBetween(
        lat,
        lng,
        preset.latitude,
        preset.longitude,
      );
      if (distance < minDistance) {
        minDistance = distance;
        closest = preset;
      }
    }

    return closest;
  }
}
