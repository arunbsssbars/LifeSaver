/// Loop 153: Toxic Ammonia (NH3) Plume Dispersion & Water Fog Scrubbing Model
/// Aligned with PESO Cold Storage Ammonia Rules, CPCB Guidelines & ERPG-3 Exposure Limits.

class AmmoniaLeakScrubbing {
  final double leakRateKgPerSec;
  final double windSpeedMps;
  final double distanceDownwindMeters;
  final bool isWaterCurtainActivated;
  final double waterFogFlowLpm;

  const AmmoniaLeakScrubbing({
    required this.leakRateKgPerSec,
    required this.windSpeedMps,
    required this.distanceDownwindMeters,
    required this.isWaterCurtainActivated,
    required this.waterFogFlowLpm,
  });

  /// Ammonia is highly soluble in water (1 liter of water absorbs over 700 liters of NH3 gas)
  /// An effective wide-angle water fog curtain (> 500 LPM) knocks down over 85% of vapor plume!
  double get estimatedVaporKnockdownEfficiencyPercent {
    if (!isWaterCurtainActivated) return 0.0;
    if (waterFogFlowLpm >= 1000.0) return 92.0;
    if (waterFogFlowLpm >= 500.0) return 85.0;
    return 60.0;
  }

  /// Downwind Concentration in PPM (without scrubbing)
  double get rawConcentrationPpm {
    final d = distanceDownwindMeters > 10.0 ? distanceDownwindMeters : 10.0;
    final w = windSpeedMps > 0.5 ? windSpeedMps : 0.5;
    return (leakRateKgPerSec * 1e6) / (0.15 * d * d * w);
  }

  /// Net ambient concentration taking water scrubbing into account
  double get netAmbientPpm =>
      rawConcentrationPpm * (1.0 - (estimatedVaporKnockdownEfficiencyPercent / 100.0));

  /// ERPG-3 / IDLH for Ammonia is 300 PPM (Immediately Dangerous to Life & Health)
  bool get isIdlhThresholdExceeded => netAmbientPpm >= 300.0;

  /// Tactical Evacuation Direction
  String get evacuationDirectionDirective =>
      'CROSSWIND EVACUATION: Evacuate PERPENDICULAR (90 degrees) to wind direction. DO NOT run downwind with the plume!';

  /// Emergency Citizen Protection Directive
  String get citizenProtectionDirective {
    return 'Cover nose and mouth with a thick cloth/towel soaked in plain water or dilute vinegar (acid neutralizes basic NH3). Keep eyes closed or shielded; move to upper floors if liquid NH3 is pooling.';
  }
}
