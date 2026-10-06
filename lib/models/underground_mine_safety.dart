/// Model representing Directorate General of Mines Safety (DGMS)
/// Coal Mines Regulations (CMR 2017) Underground Explosive Gas & Inrush Safety.
class UndergroundMineSafetyTelemetry {
  final String mineSectionName;
  final double methanePercentCh4; // statutory trigger >= 1.25%
  final double carbonMonoxidePpmCo; // statutory trigger >= 50 ppm
  final double oxygenPercentO2; // statutory trigger < 19.0%
  final double waterInrushSeepageRateLpm;
  final int activeMinersUndergroundCount;

  const UndergroundMineSafetyTelemetry({
    required this.mineSectionName,
    required this.methanePercentCh4,
    required this.carbonMonoxidePpmCo,
    required this.oxygenPercentO2,
    required this.waterInrushSeepageRateLpm,
    required this.activeMinersUndergroundCount,
  });

  /// True if explosive methane gas limit is breached (DGMS CMR 2017 mandate)
  bool get isMethaneExplosiveAlert => methanePercentCh4 >= 1.25;

  /// True if spontaneous combustion mine fire / toxic CO gas is detected
  bool get isToxicCoFireAlert => carbonMonoxidePpmCo >= 50.0;

  /// True if asphyxiation oxygen deficiency exists
  bool get isOxygenDeficient => oxygenPercentO2 < 19.0;

  /// True if emergency withdrawal of all miners is mandatory
  bool get isEmergencyEvacuationMandated => isMethaneExplosiveAlert || isToxicCoFireAlert || isOxygenDeficient || waterInrushSeepageRateLpm > 500.0;
}
