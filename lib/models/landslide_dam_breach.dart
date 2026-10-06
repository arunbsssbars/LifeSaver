import 'dart:math' as math;

/// Model representing Geological Survey of India (GSI) & CWC
/// Landslide Dammed Lake Outburst Flood (LDOF) Overtopping Incision & River Blockage Breach.
class LandslideDamBreachAssessment {
  final String riverValleyName;
  final double debrisBlockageHeightMeters;
  final double impoundedLakeVolumeMillionM3;
  final double inflowDischargeCusecs;
  final double distanceToDownstreamSettlementKm;
  final bool isEmergencySpillwayChannelConstructed;

  const LandslideDamBreachAssessment({
    required this.riverValleyName,
    required this.debrisBlockageHeightMeters,
    required this.impoundedLakeVolumeMillionM3,
    required this.inflowDischargeCusecs,
    required this.distanceToDownstreamSettlementKm,
    required this.isEmergencySpillwayChannelConstructed,
  });

  /// Peak Breach Outflow (Q_peak in m³/s) using Costa & Schuster (1988) empirical landslide dam formula:
  /// Q_p = 0.0158 * (V_lake * 10^6)^0.42 * (H_dam)^0.77
  double get estimatedPeakBreachOutflowCubicMetersPerSec {
    if (impoundedLakeVolumeMillionM3 <= 0.0 || debrisBlockageHeightMeters <= 0.0) return 0.0;
    final totalVol = impoundedLakeVolumeMillionM3 * 1000000.0;
    final term1 = math.pow(totalVol, 0.42);
    final term2 = math.pow(debrisBlockageHeightMeters, 0.77);
    return (0.0158 * term1 * term2).clamp(100.0, 50000.0);
  }

  /// Estimated Breach Flood Wave Travel Time in minutes to downstream settlement (velocity approx 20-30 km/h)
  double get waveArrivalTimeMinutes {
    const averageWaveVelocityKmh = 24.0;
    return (distanceToDownstreamSettlementKm / averageWaveVelocityKmh) * 60.0;
  }

  /// True if lake is filling rapidly and overtopping breach will occur within 24 hours without bypass channel
  bool get isImminentBreachOvertoppingRisk => !isEmergencySpillwayChannelConstructed && impoundedLakeVolumeMillionM3 > 5.0;

  /// True if downstream valley requires immediate Stage-3 Red Evacuation Order (< 45 minutes travel time)
  bool get isUrgentDownstreamEvacuationMandated => waveArrivalTimeMinutes < 45.0;
}
