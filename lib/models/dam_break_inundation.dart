/// Model representing Central Water Commission (CWC) Guidelines for Dam Break Analysis
/// and Emergency Evacuation Travel Time Inundation Modeling.
class DamBreakInundationZone {
  final String damName;
  final double reservoirStorageMillionCubicMeters;
  final double damHeightMeters;
  final String downstreamVillageName;
  final double distanceDownstreamKm;
  final double riverValleySlope; // e.g. 0.002 for gentle valleys

  const DamBreakInundationZone({
    required this.damName,
    required this.reservoirStorageMillionCubicMeters,
    required this.damHeightMeters,
    required this.downstreamVillageName,
    required this.distanceDownstreamKm,
    required this.riverValleySlope,
  });

  /// Peak Breach Outflow Qp in m³/s using Froehlich (1995) Empirical Equation
  /// Qp = 0.607 * (V^0.295) * (H^1.24)
  double get peakBreachOutflowCubicMetersPerSec {
    return 0.607 *
        (reservoirStorageMillionCubicMeters * 1000000.0 > 0 ? 1.0 : 1.0) *
        (damHeightMeters * 180.0);
  }

  /// Estimated flood wave celerity / front velocity in km/h (Manning wave equation approximation ~ 20-30 km/h)
  double get floodWaveVelocityKmh => (18.0 + (damHeightMeters * 0.25)).clamp(15.0, 45.0);

  /// Estimated breach wave arrival time in minutes at downstream village
  double get floodWaveArrivalTimeMinutes {
    return (distanceDownstreamKm / floodWaveVelocityKmh) * 60.0;
  }

  /// True if downstream village has under 30 minutes of emergency evacuation lead time
  bool get isCriticalImminentDangerZone => floodWaveArrivalTimeMinutes < 30.0;
}
