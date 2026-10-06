/// Model representing Petroleum & Natural Gas Regulatory Board (PNGRB) & OISD-STD-141
/// Cross-Country Hydrocarbon Gas/Oil Pipeline Cathodic Protection & Corrosion Rupture Safety.
enum CathodicProtectionStatus {
  adequateProtection('Optimal Cathodic Protection (-850 mV to -1200 mV CSE)', 0xFF10B981),
  underProtected('Under-Protected Corrosion Hazard (> -850 mV) - Galvanic Pitting Risk', 0xFFFBBF24),
  overProtected('Over-Protected (> -1200 mV) - Cathodic Disbondment & Hydrogen Embrittlement Risk', 0xFFEF4444);

  final String description;
  final int colorValue;
  const CathodicProtectionStatus(this.description, this.colorValue);
}

class PipelineCathodicProtectionTelemetry {
  final String pipelineSectionTag;
  final double pipeToSoilPotentialInstantOffMilliVolts; // -850 mV CSE criterion
  final double soilResistivityOhmCm;
  final double acInducedInterferenceVoltageVolts;
  final double wallThicknessRemainingPercent;

  const PipelineCathodicProtectionTelemetry({
    required this.pipelineSectionTag,
    required this.pipeToSoilPotentialInstantOffMilliVolts,
    required this.soilResistivityOhmCm,
    required this.acInducedInterferenceVoltageVolts,
    required this.wallThicknessRemainingPercent,
  });

  /// Evaluates cathodic polarization status
  CathodicProtectionStatus get protectionStatus {
    if (pipeToSoilPotentialInstantOffMilliVolts > -850.0) {
      return CathodicProtectionStatus.underProtected;
    } else if (pipeToSoilPotentialInstantOffMilliVolts < -1200.0) {
      return CathodicProtectionStatus.overProtected;
    }
    return CathodicProtectionStatus.adequateProtection;
  }

  /// True if pipeline is in highly corrosive soil (< 2000 Ohm-cm per NACE standard)
  bool get isAggressiveCorrosiveSoil => soilResistivityOhmCm < 2000.0;

  /// True if AC mitigation decoupling device must trigger to prevent electrical shock/arcing puncture (> 15 V AC per PNGRB)
  bool get isAcInterferenceShockHazard => acInducedInterferenceVoltageVolts >= 15.0;

  /// True if pipeline segment requires immediate derating or emergency sleeve repair (loss > 20% wall thickness)
  bool get isCriticalRuptureIntegrityThreat => wallThicknessRemainingPercent <= 80.0;
}
