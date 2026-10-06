import 'dart:math' as math;

/// Model representing Central Water Commission (CWC) Guidelines & IS 12094
/// River Flood Embankment Seepage Piping, Exit Gradient & Sand Boil Disaster Failure.
class RiverEmbankmentPipingAudit {
  final String embankmentReachName;
  final double riverHeadDifferenceMeters; // Height of flood level above landside ground
  final double totalSeepagePathLengthMeters; // Base width + cutoff wall
  final double blighCreepCoefficient; // C = 15 for fine alluvial sand/silt (Ganga/Brahmaputra)
  final double observedSandBoilDiameterCm;
  final bool isDischargingTurbidMuddyWater;

  const RiverEmbankmentPipingAudit({
    required this.embankmentReachName,
    required this.riverHeadDifferenceMeters,
    required this.totalSeepagePathLengthMeters,
    required this.blighCreepCoefficient,
    required this.observedSandBoilDiameterCm,
    required this.isDischargingTurbidMuddyWater,
  });

  /// Bligh's Safe Creep Length required: L_safe = C * H
  double get requiredSafeCreepLengthMeters => blighCreepCoefficient * riverHeadDifferenceMeters;

  /// Hydraulic Exit Gradient i_exit = H / L
  double get calculatedExitGradient {
    if (totalSeepagePathLengthMeters <= 0.0) return 1.0;
    return riverHeadDifferenceMeters / totalSeepagePathLengthMeters;
  }

  /// Critical Piping Gradient for alluvial sand (~1 / C)
  double get criticalPipingGradient => 1.0 / blighCreepCoefficient;

  /// True if exit hydraulic gradient breaches critical piping threshold (i_exit > 0.20 or i_exit > 1/C)
  bool get isSubsurfacePipingFailureImminent {
    return calculatedExitGradient >= criticalPipingGradient || totalSeepagePathLengthMeters < requiredSafeCreepLengthMeters;
  }

  /// True if active internal erosion is eroding dyke core (sand boil with muddy turbidity)
  bool get isCatastrophicBreachAlert => isDischargingTurbidMuddyWater && observedSandBoilDiameterCm >= 15.0;

  /// Sizing of reverse filter sandbag ring in meters diameter required around sand boil (approx 3x boil diameter)
  double get recommendedSandbagRingDiameterMeters => math.max(1.5, (observedSandBoilDiameterCm * 3.0) / 100.0);
}
