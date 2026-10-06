import 'dart:math' as math;

/// Model representing IMD & Central Water Commission (CWC)
/// Himalayan Cloudburst Catchment Runoff, Kirpich Time of Concentration & Flash Flood Hydrograph Surge.
class CloudburstRunoffModel {
  final String mountainCatchmentName;
  final double streamLengthKilometers;
  final double elevationDropMeters;
  final double watershedAreaSqKm;
  final double cloudburstRainfallIntensityMmPerHour; // e.g., >= 100 mm/hr per IMD definition
  final double catchmentRunoffCoefficient; // e.g., 0.65 to 0.85 for steep rocky Himalayan terrain

  const CloudburstRunoffModel({
    required this.mountainCatchmentName,
    required this.streamLengthKilometers,
    required this.elevationDropMeters,
    required this.watershedAreaSqKm,
    required this.cloudburstRainfallIntensityMmPerHour,
    required this.catchmentRunoffCoefficient,
  });

  /// Catchment Slope S = H / L
  double get catchmentSlope => (elevationDropMeters / (streamLengthKilometers * 1000.0)).clamp(0.001, 1.0);

  /// Kirpich Time of Concentration (Tc in minutes)
  /// Tc = 0.0195 * (L^0.77) * (S^-0.385), where L is in meters
  double get timeOfConcentrationMinutes {
    if (streamLengthKilometers <= 0.0 || elevationDropMeters <= 0.0) return 10.0;
    final lengthMeters = streamLengthKilometers * 1000.0;
    final term1 = math.pow(lengthMeters, 0.77);
    final term2 = math.pow(catchmentSlope, -0.385);
    final tc = 0.0195 * term1 * term2;
    return tc.clamp(5.0, 360.0);
  }

  /// Estimated Peak Flood Discharge (Qp in m³/s) using the Rational Method
  /// Qp = (C * I * A) / 3.6
  double get peakDischargeCubicMetersPerSec {
    return (catchmentRunoffCoefficient * cloudburstRainfallIntensityMmPerHour * watershedAreaSqKm) / 3.6;
  }

  /// True if cloudburst threshold (>= 100 mm/hr over a small catchment) is officially breached
  bool get isImdCloudburstCriterionSatisfied => cloudburstRainfallIntensityMmPerHour >= 100.0;

  /// True if downstream mountain settlements have under 20 minutes of evacuation lead time
  bool get isImminentFlashFloodDanger => isImdCloudburstCriterionSatisfied && timeOfConcentrationMinutes < 20.0;
}
