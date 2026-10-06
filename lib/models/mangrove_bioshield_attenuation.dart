import 'dart:math' as math;

/// Model representing MoEFCC, MSSRF & CRZ Rules Guidelines for
/// Coastal Mangrove Bioshield Wave Energy Attenuation & Storm Surge Inundation Damping.
class MangroveBioshieldAttenuation {
  final String coastalStretchName;
  final double mangroveForestWidthMeters;
  final double treeDensityStemsPerSqMeter; // e.g., 0.5 to 2.0 trees/m2
  final double incomingWaveHeightMeters;
  final double incomingSurgeVelocityMs;

  const MangroveBioshieldAttenuation({
    required this.coastalStretchName,
    required this.mangroveForestWidthMeters,
    required this.treeDensityStemsPerSqMeter,
    required this.incomingWaveHeightMeters,
    required this.incomingSurgeVelocityMs,
  });

  /// Wave Energy Damping Coefficient k (empirical mangrove damping model)
  /// k approx 0.015 * sqrt(treeDensity)
  double get waveDampingCoefficient => 0.015 * math.sqrt(treeDensityStemsPerSqMeter.clamp(0.1, 10.0));

  /// Transmitted Wave Height after passing through mangrove bioshield: H = H0 * exp(-k * x)
  double get transmittedWaveHeightMeters {
    if (mangroveForestWidthMeters <= 0.0) return incomingWaveHeightMeters;
    final transmitted = incomingWaveHeightMeters * math.exp(-waveDampingCoefficient * mangroveForestWidthMeters);
    return transmitted.clamp(0.0, incomingWaveHeightMeters);
  }

  /// Total Wave Energy Reduction Percentage (1 - (H / H0)^2) * 100
  double get waveEnergyReductionPercent {
    if (incomingWaveHeightMeters <= 0.0) return 100.0;
    final ratio = transmittedWaveHeightMeters / incomingWaveHeightMeters;
    return ((1.0 - (ratio * ratio)) * 100.0).clamp(0.0, 100.0);
  }

  /// True if mangrove bioshield meets statutory NDMA/MSSRF coastal protection benchmark (>= 60% energy reduction)
  bool get isEffectiveCoastalShield => waveEnergyReductionPercent >= 60.0;
}
