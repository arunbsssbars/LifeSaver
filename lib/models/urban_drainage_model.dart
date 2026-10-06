/// Model representing CPHEEO (Central Public Health and Environmental Engineering Organisation)
/// Urban Stormwater Drainage Capacity & Rational Method Runoff Calculation ($Q = \frac{C \cdot I \cdot A}{360}$).
class UrbanDrainageAssessment {
  final String urbanWardName;
  final double catchmentAreaHectares;
  final double runoffCoefficient; // 0.70 to 0.90 for dense paved urban areas
  final double rainfallIntensityMmPerHour;
  final double stormwaterDrainCapacityCubicMetersPerSec;
  final int activeDewateringPumpsCount;

  const UrbanDrainageAssessment({
    required this.urbanWardName,
    required this.catchmentAreaHectares,
    required this.runoffCoefficient,
    required this.rainfallIntensityMmPerHour,
    required this.stormwaterDrainCapacityCubicMetersPerSec,
    required this.activeDewateringPumpsCount,
  });

  /// Peak Runoff Rate Q in cubic meters per second (m³/s) via Rational Method
  /// Q = (C * I * A) / 360
  double get peakRunoffCubicMetersPerSec {
    return (runoffCoefficient * rainfallIntensityMmPerHour * catchmentAreaHectares) / 360.0;
  }

  /// Total drainage capacity including active pumping stations (each 50 HP pump ~ 0.35 m³/s)
  double get totalDrainageCapacityCubicMetersPerSec {
    return stormwaterDrainCapacityCubicMetersPerSec + (activeDewateringPumpsCount * 0.35);
  }

  /// Drainage overload deficit in m³/s
  double get drainageDeficitRate => (peakRunoffCubicMetersPerSec - totalDrainageCapacityCubicMetersPerSec).clamp(0.0, 500.0);

  /// True if stormwater drains are overflowing
  bool get isDrainageOverwhelmed => peakRunoffCubicMetersPerSec > totalDrainageCapacityCubicMetersPerSec;

  /// Estimated waterlogging rise rate in cm per hour over low-lying road surface
  double get waterloggingRiseRateCmPerHour {
    if (!isDrainageOverwhelmed) return 0.0;
    // Assuming 20% of ward is low-lying depression
    final depressionAreaSqM = catchmentAreaHectares * 10000.0 * 0.20;
    final surplusVolumePerHour = drainageDeficitRate * 3600.0;
    return ((surplusVolumePerHour / depressionAreaSqM) * 100.0).clamp(0.0, 100.0);
  }
}
