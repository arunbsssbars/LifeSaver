/// Model representing Synthetic Aperture Radar (SAR) Sentinel-1 / RISAT-1A
/// Cloud-penetrating radar flood inundation footprint telemetry.
class SarSatelliteObservation {
  final String satelliteConstellation;
  final DateTime acquisitionTimestamp;
  final String riverBasin;
  final double totalInundatedAreaSquareKm;
  final double cropSubmergenceHectares;
  final double radarBackscatterCoeffDb;
  final double confidenceLevelPercent;
  final List<String> mostSeverelySubmergedTaluks;

  const SarSatelliteObservation({
    required this.satelliteConstellation,
    required this.acquisitionTimestamp,
    required this.riverBasin,
    required this.totalInundatedAreaSquareKm,
    required this.cropSubmergenceHectares,
    required this.radarBackscatterCoeffDb,
    required this.confidenceLevelPercent,
    required this.mostSeverelySubmergedTaluks,
  });

  /// Evaluates whether SAR backscatter indicates open standing water (-18 to -25 dB is typical specular reflection of standing water)
  bool get isStandingWaterDetected => radarBackscatterCoeffDb <= -16.0;

  static List<SarSatelliteObservation> getMockSatellitePasses(String basinName) {
    return [
      SarSatelliteObservation(
        satelliteConstellation: 'ISRO RISAT-1A / EOS-04 (C-band SAR)',
        acquisitionTimestamp: DateTime.now().subtract(const Duration(hours: 3)),
        riverBasin: basinName,
        totalInundatedAreaSquareKm: 18.5,
        cropSubmergenceHectares: 420.0,
        radarBackscatterCoeffDb: -19.4,
        confidenceLevelPercent: 94.5,
        mostSeverelySubmergedTaluks: const ['Lowland Floodplain Reach', 'Agricultural Polder A', 'Riparian Sector 4'],
      ),
      SarSatelliteObservation(
        satelliteConstellation: 'ESA Copernicus Sentinel-1B SAR',
        acquisitionTimestamp: DateTime.now().subtract(const Duration(hours: 14)),
        riverBasin: basinName,
        totalInundatedAreaSquareKm: 14.2,
        cropSubmergenceHectares: 310.0,
        radarBackscatterCoeffDb: -18.8,
        confidenceLevelPercent: 91.0,
        mostSeverelySubmergedTaluks: const ['Embankment Toe Belt', 'River Bend Lowlands'],
      ),
    ];
  }
}
