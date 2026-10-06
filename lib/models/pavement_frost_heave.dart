import 'dart:math' as math;

/// Model representing Central Road Research Institute (CRRI) & IRC SP:89
/// High-Altitude Border Highway Subgrade Frost Heave, Freezing Index & Thaw-Weakening Derailment.
class PavementFrostHeaveAssessment {
  final String highwaySectorPassName;
  final double airFreezingIndexDegreeDaysCelsius; // F_c in °C-days (e.g. 500 to 1200 °C-days in Ladakh/Sikkim)
  final double subgradeFinesPercentagePassing75Micron; // Frost susceptible if fines > 10%
  final double groundwaterDepthBelowPavementMeters;
  final double measuredFrostHeaveDisplacementMm;
  final bool hasGeotextileCapillaryBreakLayer;

  const PavementFrostHeaveAssessment({
    required this.highwaySectorPassName,
    required this.airFreezingIndexDegreeDaysCelsius,
    required this.subgradeFinesPercentagePassing75Micron,
    required this.groundwaterDepthBelowPavementMeters,
    required this.measuredFrostHeaveDisplacementMm,
    required this.hasGeotextileCapillaryBreakLayer,
  });

  /// Theoretical Depth of Frost Penetration (Z_f in meters) using Modified Berggren Formula:
  /// Z_f approx 0.045 * sqrt(Air Freezing Index)
  double get estimatedFrostPenetrationDepthMeters {
    if (airFreezingIndexDegreeDaysCelsius <= 0.0) return 0.0;
    return (0.045 * math.sqrt(airFreezingIndexDegreeDaysCelsius)).clamp(0.2, 3.5);
  }

  /// True if subgrade soil is classified as highly frost-susceptible (fines > 15% and shallow water table < 2.0m)
  bool get isHighlyFrostSusceptibleSoil {
    return subgradeFinesPercentagePassing75Micron > 15.0 && groundwaterDepthBelowPavementMeters < 2.0 && !hasGeotextileCapillaryBreakLayer;
  }

  /// True if heave displacement causes severe vehicular steering deflection & road breakup (> 50 mm)
  bool get isSevereFrostHeaveDisruption => measuredFrostHeaveDisplacementMm >= 50.0;

  /// True if springtime thaw-weakening axle load restriction (50% reduction) is mandatory
  bool get isSpringThawAxleLoadRestrictionMandated => isHighlyFrostSusceptibleSoil && estimatedFrostPenetrationDepthMeters > 0.8;
}
