import 'dart:math' as math;

/// Model representing Indian Roads Congress (IRC:78 / MoRTH SP 13) & Indian Railways
/// Bridge Pier Scour Depth Calculation and Emergency Hydrodynamic Closure Protocol.
class BridgeScourHydrodynamics {
  final String bridgeIdentifier;
  final double riverDesignDischargeCusecs;
  final double siltFactorLacey; // e.g. 1.0 to 1.5 for alluvial sand/gravel
  final double pierWidthMeters;
  final double foundationDepthMeters;
  final double measuredScourDepthMeters;

  const BridgeScourHydrodynamics({
    required this.bridgeIdentifier,
    required this.riverDesignDischargeCusecs,
    required this.siltFactorLacey,
    required this.pierWidthMeters,
    required this.foundationDepthMeters,
    required this.measuredScourDepthMeters,
  });

  /// Lacey's Mean Regime Scour Depth (D_sm = 1.34 * (q^2 / f)^(1/3))
  double calculateLaceyRegimeScourDepthMeters(double dischargeIntensityPerMeter) {
    if (siltFactorLacey <= 0.0 || dischargeIntensityPerMeter <= 0.0) return 1.0;
    final term = (dischargeIntensityPerMeter * dischargeIntensityPerMeter) / siltFactorLacey;
    return 1.34 * math.pow(term, 1.0 / 3.0);
  }

  /// Maximum permissible pier scour depth with IRC 2.0x safety multiplier
  double get maxPermissiblePierScourMeters {
    final regimeDepth = calculateLaceyRegimeScourDepthMeters(12.0);
    return (2.0 * regimeDepth).clamp(4.0, 30.0);
  }

  /// Pier Scour Safety Factor = (Foundation Depth - Measured Scour) / Foundation Depth
  double get foundationGripFactor {
    if (foundationDepthMeters <= 0.0) return 0.0;
    return ((foundationDepthMeters - measuredScourDepthMeters) / foundationDepthMeters).clamp(0.0, 1.0);
  }

  /// True if bridge must be closed to rail/road traffic immediately due to scour undermining
  bool get isEmergencyBridgeClosureMandated => measuredScourDepthMeters >= (foundationDepthMeters * 0.75);
}
