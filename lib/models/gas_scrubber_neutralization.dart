/// Model representing PESO & CPCB Guidelines for Toxic Gas Leak
/// Emergency Wet Scrubber Neutralization & Caustic (NaOH) Chemical Absorption.
class GasScrubberNeutralization {
  final String scrubberSystemTag;
  final String neutralizedGasType; // Chlorine (Cl2), Ammonia (NH3), Sulfur Dioxide (SO2)
  final double causticSodaConcentrationPercent; // Recommended 10% to 15% NaOH for Cl2
  final double causticRecirculationFlowLpm;
  final double inletGasConcentrationPpm;
  final double outletVentConcentrationPpm;

  const GasScrubberNeutralization({
    required this.scrubberSystemTag,
    required this.neutralizedGasType,
    required this.causticSodaConcentrationPercent,
    required this.causticRecirculationFlowLpm,
    required this.inletGasConcentrationPpm,
    required this.outletVentConcentrationPpm,
  });

  /// Scrubber Neutralization Removal Efficiency Percentage (E = (Cin - Cout) / Cin * 100)
  double get removalEfficiencyPercent {
    if (inletGasConcentrationPpm <= 0.0) return 100.0;
    final efficiency = ((inletGasConcentrationPpm - outletVentConcentrationPpm) / inletGasConcentrationPpm) * 100.0;
    return efficiency.clamp(0.0, 100.0);
  }

  /// True if scrubber meets CPCB / PESO statutory absorption standard (>= 99.9% removal efficiency)
  bool get isScrubberEfficiencyCompliant => removalEfficiencyPercent >= 99.9;

  /// True if outlet exhaust vent concentration breaches statutory TLV-STEL occupational limit (e.g. Cl2 > 0.5 ppm)
  bool get isVentReleaseOverLimit => outletVentConcentrationPpm > 0.5;

  /// True if caustic circulation needs chemical makeup dosing (NaOH < 8.0%)
  bool get isCausticRechargeNeeded => causticSodaConcentrationPercent < 8.0;
}
