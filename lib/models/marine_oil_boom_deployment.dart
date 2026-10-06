import 'dart:math' as math;

/// Model representing MoEFCC & Indian Coast Guard NOS-DCP Tier 2
/// Marine Oil Spill Spreading, Containment Boom Sizing, and Skimmer Suction Operations.
class MarineOilBoomDeployment {
  final String portHarborName;
  final double spilledVolumeTonnes;
  final double currentVelocityKnots;
  final double waveHeightMeters;
  final double waterTemperatureCelsius;

  const MarineOilBoomDeployment({
    required this.portHarborName,
    required this.spilledVolumeTonnes,
    required this.currentVelocityKnots,
    required this.waveHeightMeters,
    required this.waterTemperatureCelsius,
  });

  /// Estimated slick spreading radius in meters using Fay's Gravity-Viscous spreading model
  /// R = (Delta * g * V^2 / nu^0.5)^0.25 * t^0.375
  double calculateSlickRadiusMeters(double elapsedHours) {
    if (elapsedHours <= 0.0 || spilledVolumeTonnes <= 0.0) return 0.0;
    // Approximated radial spreading
    final radius = 45.0 * math.pow(spilledVolumeTonnes, 0.33) * math.pow(elapsedHours, 0.375);
    return radius.toDouble().clamp(10.0, 10000.0);
  }

  /// Required containment boom length in meters (perimeter enclosure + 30% safety factor)
  double get requiredBoomLengthMeters {
    final slickPerimeter = 2 * math.pi * calculateSlickRadiusMeters(2.0);
    return slickPerimeter * 1.3;
  }

  /// True if current velocity exceeds boom containment limit (~0.7 knots causes boom planing/drainage failure)
  bool get isBoomDrainageFailureRisk => currentVelocityKnots > 0.7;

  /// Recommended skimmer suction throughput rate in m³/hour
  double get recommendedSkimmerCapacityCubicMetersPerHour {
    return (spilledVolumeTonnes * 1.15 / 12.0).clamp(10.0, 500.0);
  }
}
