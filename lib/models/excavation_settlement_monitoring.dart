import 'dart:math' as math;

/// Model representing Bureau of Indian Standards (IS 16700) & DMRC
/// Urban Deep Excavation & Metro Tunnel Ground Settlement Trough (Peck's Model).
class ExcavationSettlementMonitoring {
  final String metroSectionName;
  final double excavationDepthMeters;
  final double distanceToAdjacentBuildingMeters;
  final double measuredGroundSettlementMm;
  final double groundwaterDrawdownMeters;

  const ExcavationSettlementMonitoring({
    required this.metroSectionName,
    required this.excavationDepthMeters,
    required this.distanceToAdjacentBuildingMeters,
    required this.measuredGroundSettlementMm,
    required this.groundwaterDrawdownMeters,
  });

  /// Maximum theoretical ground surface settlement Smax (approx 0.5% of excavation depth in soft alluvial soils)
  double get maxTheoreticalSettlementMm => (excavationDepthMeters * 1000.0) * 0.005;

  /// Peck's empirical settlement trough index at distance x
  /// S(x) = Smax * exp(-x^2 / (2 * i^2)), where i = 0.5 * H
  double calculateTheoreticalSettlementAtDistanceMm(double distanceMeters) {
    final troughWidthParameter = 0.5 * excavationDepthMeters;
    if (troughWidthParameter <= 0.0) return 0.0;
    final exponent = -(distanceMeters * distanceMeters) / (2.0 * troughWidthParameter * troughWidthParameter);
    return maxTheoreticalSettlementMm * math.exp(exponent);
  }

  /// True if settlement breaches statutory DMRC Red Stop-Work Threshold (25 mm)
  bool get isStopWorkRedThresholdBreached => measuredGroundSettlementMm >= 25.0;

  /// True if recharge wells must be activated to prevent adjacent building foundation collapse
  bool get isGroundwaterRechargeMandated => groundwaterDrawdownMeters > 3.0;
}
