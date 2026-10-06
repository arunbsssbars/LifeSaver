import 'dart:math' as math;

/// Model representing Forest Survey of India (FSI) & MoEFCC
/// Wildfire Containment Line Width, Byram's Fireline Intensity, and Backfire Planning.
class WildfireContainmentLine {
  final String forestDivisionName;
  final double flameLengthMeters;
  final double fuelLoadTonnesPerHectare;
  final double ambientWindSpeedKmh;
  final double terrainSlopeDegrees;

  const WildfireContainmentLine({
    required this.forestDivisionName,
    required this.flameLengthMeters,
    required this.fuelLoadTonnesPerHectare,
    required this.ambientWindSpeedKmh,
    required this.terrainSlopeDegrees,
  });

  /// Byram's Fireline Intensity I = 259.83 * (L^2.174) in kW/m
  double get byramsFirelineIntensityKwPerMeter {
    if (flameLengthMeters <= 0.0) return 0.0;
    return 259.83 * math.pow(flameLengthMeters, 2.174);
  }

  /// Minimum defensible firebreak width in meters (rule of thumb: 1.5 to 2.0x flame length + wind allowance)
  double get recommendedFirebreakWidthMeters {
    final baseWidth = flameLengthMeters * 2.0;
    final windSlopeMultiplier = 1.0 + (ambientWindSpeedKmh * 0.02) + (terrainSlopeDegrees * 0.015);
    return (baseWidth * windSlopeMultiplier).clamp(5.0, 100.0);
  }

  /// True if direct hand-crew attack is unsafe and aerial retardant drop/backfire is mandated (Flame > 2.5m or I > 2000 kW/m)
  bool get isDirectAttackUnsafe => flameLengthMeters > 2.5 || byramsFirelineIntensityKwPerMeter > 2000.0;
}
