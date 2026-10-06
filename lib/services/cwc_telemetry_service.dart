import '../models/cwc_river_station.dart';
import '../models/hazard_status.dart';
import '../services/earthquake_service.dart';

class CwcTelemetryService {
  static const List<CwcRiverStation> _stations = [
    // Yamuna - Delhi / Noida Station
    CwcRiverStation(
      stationName: 'Old Delhi Railway Bridge (ODRB)',
      riverName: 'Yamuna River',
      state: 'Delhi / NCR',
      currentLevelMeters: 204.85,
      warningLevelMeters: 204.50,
      dangerLevelMeters: 205.33,
      highestFloodLevelMeters: 208.66,
      hflYear: '2023',
      upstreamDamName: 'Hathnikund Barrage (Haryana)',
      damDischargeCusecs: 35200.0,
      latitude: 28.6600,
      longitude: 77.2400,
    ),

    // Ganga - Patna Station
    CwcRiverStation(
      stationName: 'Gandhi Ghat (Patna)',
      riverName: 'Ganga River',
      state: 'Bihar',
      currentLevelMeters: 48.10,
      warningLevelMeters: 48.60,
      dangerLevelMeters: 49.60,
      highestFloodLevelMeters: 50.52,
      hflYear: '2016',
      upstreamDamName: 'Indrapuri Barrage (Sone) / Tehri',
      damDischargeCusecs: 45000.0,
      latitude: 25.5941,
      longitude: 85.1376,
    ),

    // Brahmaputra - Guwahati Station
    CwcRiverStation(
      stationName: 'Pandu Gauge Station',
      riverName: 'Brahmaputra River',
      state: 'Assam',
      currentLevelMeters: 47.90,
      warningLevelMeters: 48.68,
      dangerLevelMeters: 49.68,
      highestFloodLevelMeters: 51.46,
      hflYear: '2004',
      upstreamDamName: 'Ranganadi / Kurichu Hydro',
      damDischargeCusecs: 82000.0,
      latitude: 26.1445,
      longitude: 91.7362,
    ),

    // Alaknanda / Ganga - Rishikesh Station
    CwcRiverStation(
      stationName: 'Rishikesh Triveni Ghat',
      riverName: 'Ganga / Alaknanda',
      state: 'Uttarakhand',
      currentLevelMeters: 338.20,
      warningLevelMeters: 339.50,
      dangerLevelMeters: 340.50,
      highestFloodLevelMeters: 341.90,
      hflYear: '2013',
      upstreamDamName: 'Tehri Dam Reservoir',
      damDischargeCusecs: 18000.0,
      latitude: 30.0869,
      longitude: 78.2676,
    ),

    // Periyar - Aluva / Kochi Station
    CwcRiverStation(
      stationName: 'Aluva Manappuram Gauge',
      riverName: 'Periyar River',
      state: 'Kerala',
      currentLevelMeters: 1.80,
      warningLevelMeters: 2.20,
      dangerLevelMeters: 3.00,
      highestFloodLevelMeters: 4.50,
      hflYear: '2018',
      upstreamDamName: 'Idukki & Mullaperiyar Dams',
      damDischargeCusecs: 12500.0,
      latitude: 9.9312,
      longitude: 76.2673,
    ),

    // Teesta - Jalpaiguri / Siliguri Station
    CwcRiverStation(
      stationName: 'Domohani Gauge Station',
      riverName: 'Teesta River',
      state: 'West Bengal',
      currentLevelMeters: 84.10,
      warningLevelMeters: 85.00,
      dangerLevelMeters: 85.95,
      highestFloodLevelMeters: 87.20,
      hflYear: '2023 (Chungthang Outburst)',
      upstreamDamName: 'Teesta Low Dam Stage III/IV',
      damDischargeCusecs: 28000.0,
      latitude: 26.7271,
      longitude: 88.3953,
    ),
  ];

  /// Finds the closest official CWC station and adjusts simulated gauge level according to real-time GloFAS surge
  static CwcRiverStation getCwcStationForLocation({
    required double latitude,
    required double longitude,
    required FloodStatus floodStatus,
  }) {
    CwcRiverStation closest = _stations.first;
    double minDistance = double.infinity;

    for (final stn in _stations) {
      final dist = EarthquakeService.calculateDistanceKm(
        latitude,
        longitude,
        stn.latitude,
        stn.longitude,
      );
      if (dist < minDistance) {
        minDistance = dist;
        closest = stn;
      }
    }

    // Scale level realistically based on surge ratio
    final double surge = floodStatus.surgeRatio;
    final double adjustedLevel = (surge > 1.0)
        ? closest.currentLevelMeters + (surge - 1.0) * (closest.dangerLevelMeters - closest.warningLevelMeters)
        : closest.currentLevelMeters;

    return CwcRiverStation(
      stationName: closest.stationName,
      riverName: closest.riverName,
      state: closest.state,
      currentLevelMeters: adjustedLevel,
      warningLevelMeters: closest.warningLevelMeters,
      dangerLevelMeters: closest.dangerLevelMeters,
      highestFloodLevelMeters: closest.highestFloodLevelMeters,
      hflYear: closest.hflYear,
      upstreamDamName: closest.upstreamDamName,
      damDischargeCusecs: closest.damDischargeCusecs * surge,
      latitude: closest.latitude,
      longitude: closest.longitude,
    );
  }
}
