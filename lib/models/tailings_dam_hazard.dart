/// Model representing CPCB & MoEFCC Thermal Power Plant Ash Dyke & Tailings Dam Breach Safety.
class AshDykeBreachAssessment {
  final String plantName;
  final double ashDykeCrestHeightMeters;
  final double currentSlurryLevelMeters;
  final double freeboardMarginMeters; // minimum 1.5m required
  final bool hasPiezometerPorePressureAnomaly;
  final double downstreamDistanceToNearestVillageKm;

  const AshDykeBreachAssessment({
    required this.plantName,
    required this.ashDykeCrestHeightMeters,
    required this.currentSlurryLevelMeters,
    required this.freeboardMarginMeters,
    required this.hasPiezometerPorePressureAnomaly,
    required this.downstreamDistanceToNearestVillageKm,
  });

  /// True if ash dyke overtopping or structural piping breach is imminent
  bool get isBreachImminent => freeboardMarginMeters < 0.50 || hasPiezometerPorePressureAnomaly;

  /// Estimated toxic ash slurry flow velocity in km/h
  double get estimatedSlurryVelocityKmh => isBreachImminent ? 18.0 : 0.0;

  /// Estimated wave travel time to downstream village in minutes
  double get evacuationTimeWindowMinutes {
    if (!isBreachImminent) return 999.0;
    return (downstreamDistanceToNearestVillageKm / estimatedSlurryVelocityKmh) * 60.0;
  }
}
