/// Model representing Bureau of Indian Standards (IS 15797) & MoHUA
/// Rooftop Rainwater Harvesting (RWH) & Urban Flash Flood Hydrograph Peak Attenuation.
class RainwaterHarvestingAttenuation {
  final String buildingComplexName;
  final double rooftopAreaSqMeters;
  final double peakRainfallIntensityMmPerHour;
  final double cisternStorageCapacityCubicMeters;
  final double runoffCoefficient; // e.g. 0.85 for concrete/tiled roof

  const RainwaterHarvestingAttenuation({
    required this.buildingComplexName,
    required this.rooftopAreaSqMeters,
    required this.peakRainfallIntensityMmPerHour,
    required this.cisternStorageCapacityCubicMeters,
    required this.runoffCoefficient,
  });

  /// Peak Runoff Rate without RWH cistern in Litres/second (Q = C * I * A / 360)
  double get unmitigatedPeakRunoffLitresPerSec {
    final areaHectares = rooftopAreaSqMeters / 10000.0;
    final dischargeM3PerSec = (runoffCoefficient * peakRainfallIntensityMmPerHour * areaHectares) / 360.0;
    return dischargeM3PerSec * 1000.0;
  }

  /// Total Stormwater Runoff Volume generated during a 2-hour cloudburst storm (m³)
  double get totalStormVolumeCubicMeters {
    final rainfallMeters = (peakRainfallIntensityMmPerHour * 2.0) / 1000.0;
    return rooftopAreaSqMeters * rainfallMeters * runoffCoefficient;
  }

  /// Flash Flood Peak Attenuation Percentage provided by retention cistern
  double get peakHydrographAttenuationPercent {
    if (totalStormVolumeCubicMeters <= 0.0) return 100.0;
    final retentionRatio = cisternStorageCapacityCubicMeters / totalStormVolumeCubicMeters;
    return (retentionRatio * 100.0).clamp(0.0, 100.0);
  }

  /// True if building meets statutory BIS urban flood zero-discharge retention standard (>= 60% attenuation)
  bool get isBisZeroDischargeCompliant => peakHydrographAttenuationPercent >= 60.0;
}
