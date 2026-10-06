import '../models/cyclone_alert.dart';

class CycloneService {
  static const Set<String> _coastalStates = {
    'Odisha',
    'Andhra Pradesh',
    'West Bengal',
    'Tamil Nadu',
    'Kerala',
    'Gujarat',
    'Maharashtra',
    'Goa',
    'Karnataka',
    'Puducherry',
    'Andaman & Nicobar',
  };

  static bool isCoastalRegion(String stateOrDistrict) {
    for (final state in _coastalStates) {
      if (stateOrDistrict.contains(state)) return true;
    }
    return false;
  }

  /// Evaluates cyclone status for the coastal sector based on real-time wind speeds
  static CycloneAlertData evaluateCoastalCyclone({
    required String regionName,
    required String stateOrDistrict,
    required double currentWindSpeedKmh,
  }) {
    if (!isCoastalRegion(stateOrDistrict)) {
      return const CycloneAlertData(
        cycloneName: 'None',
        stage: CycloneStage.noCyclone,
        category: CycloneCategory.depression,
        estimatedWindSpeedKmh: 0.0,
        stormSurgeMeters: 0.0,
        waveHeightMeters: 1.2,
        expectedLandfallPoint: 'N/A (Inland District)',
        estimatedLandfallTime: Duration.zero,
        fishermenAdvisory: 'Inland location. No coastal advisories applicable.',
        affectedDistricts: [],
      );
    }

    if (currentWindSpeedKmh >= 90.0) {
      return CycloneAlertData(
        cycloneName: 'Severe Cyclonic Storm (Bay of Bengal / Arabian Sea)',
        stage: CycloneStage.stage4PostLandfall,
        category: CycloneCategory.verySevereCyclonicStorm,
        estimatedWindSpeedKmh: currentWindSpeedKmh,
        stormSurgeMeters: 3.5,
        waveHeightMeters: 5.8,
        expectedLandfallPoint: '$regionName Coast',
        estimatedLandfallTime: const Duration(hours: 4),
        fishermenAdvisory: 'RED ALERT: Total suspension of fishing operations. Fishermen out at sea advised to return to coast immediately.',
        affectedDistricts: [regionName, stateOrDistrict],
      );
    } else if (currentWindSpeedKmh >= 60.0) {
      return CycloneAlertData(
        cycloneName: 'Cyclonic Storm Watch',
        stage: CycloneStage.stage3Warning,
        category: CycloneCategory.cyclonicStorm,
        estimatedWindSpeedKmh: currentWindSpeedKmh,
        stormSurgeMeters: 1.8,
        waveHeightMeters: 3.8,
        expectedLandfallPoint: 'Approaching $stateOrDistrict Coastline',
        estimatedLandfallTime: const Duration(hours: 18),
        fishermenAdvisory: 'ORANGE ALERT: Fishermen are advised not to venture into deep sea or coastal waters during next 48 hours.',
        affectedDistricts: [regionName, stateOrDistrict],
      );
    } else if (currentWindSpeedKmh >= 40.0) {
      return CycloneAlertData(
        cycloneName: 'Deep Depression Activity',
        stage: CycloneStage.stage2Alert,
        category: CycloneCategory.deepDepression,
        estimatedWindSpeedKmh: currentWindSpeedKmh,
        stormSurgeMeters: 0.8,
        waveHeightMeters: 2.5,
        expectedLandfallPoint: 'Off $stateOrDistrict Coast',
        estimatedLandfallTime: const Duration(hours: 36),
        fishermenAdvisory: 'YELLOW WATCH: Sea condition likely to become rough. Small boat fishermen exercise high caution.',
        affectedDistricts: [regionName, stateOrDistrict],
      );
    }

    return CycloneAlertData(
      cycloneName: 'No Active Cyclone',
      stage: CycloneStage.noCyclone,
      category: CycloneCategory.depression,
      estimatedWindSpeedKmh: currentWindSpeedKmh,
      stormSurgeMeters: 0.0,
      waveHeightMeters: 1.2,
      expectedLandfallPoint: 'N/A',
      estimatedLandfallTime: Duration.zero,
      fishermenAdvisory: 'Sea condition normal to moderate. Standard navigation permitted.',
      affectedDistricts: [],
    );
  }
}
