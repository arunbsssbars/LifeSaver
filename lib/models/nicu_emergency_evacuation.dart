/// Model representing MoHFW & National Neonatology Forum (NNF) India Guidelines for
/// Neonatal Intensive Care Unit (NICU) Emergency Evacuation & Transport Incubator Autonomy.
enum NeonatalEvacuationTier {
  tier1Level3TransportIncubator('Tier 1: High-Risk Ventilated Preterm - Battery Transport Incubator + Micro-O2', 0xFFEF4444),
  tier2Level2ThermalWrap('Tier 2: Intermediate Care / CPAP - Portable Pulse Oximeter + Phase Change Material Wrap', 0xFFFBBF24),
  tier3Level1KmcDirectMother('Tier 3: Stable Neonates - Continuous Kangaroo Mother Care (KMC) Evacuation', 0xFF10B981);

  final String description;
  final int colorValue;
  const NeonatalEvacuationTier(this.description, this.colorValue);
}

class NicuEmergencyEvacuationAssessment {
  final String neonateId;
  final double birthWeightGrams;
  final double gestationalAgeWeeks;
  final bool requiresMechanicalVentilation;
  final double transportIncubatorBatteryMinutes;
  final double microOxygenCylinderLitres;
  final double ambientEvacuationTempCelsius;

  const NicuEmergencyEvacuationAssessment({
    required this.neonateId,
    required this.birthWeightGrams,
    required this.gestationalAgeWeeks,
    required this.requiresMechanicalVentilation,
    required this.transportIncubatorBatteryMinutes,
    required this.microOxygenCylinderLitres,
    required this.ambientEvacuationTempCelsius,
  });

  /// Evaluates neonatal evacuation tier
  NeonatalEvacuationTier get evacuationTier {
    if (requiresMechanicalVentilation || birthWeightGrams < 1000.0 || gestationalAgeWeeks < 28.0) {
      return NeonatalEvacuationTier.tier1Level3TransportIncubator;
    } else if (birthWeightGrams < 1800.0) {
      return NeonatalEvacuationTier.tier2Level2ThermalWrap;
    }
    return NeonatalEvacuationTier.tier3Level1KmcDirectMother;
  }

  /// Oxygen autonomy in minutes for transport (assuming 2.0 L/min neonatal flow)
  double get oxygenTransportAutonomyMinutes {
    if (microOxygenCylinderLitres <= 0.0) return 0.0;
    return microOxygenCylinderLitres / 2.0;
  }

  /// True if incubator battery autonomy is sufficient for hospital-to-hospital transfer (>= 60 minutes)
  bool get hasSufficientTransportBatteryAutonomy => transportIncubatorBatteryMinutes >= 60.0;

  /// True if cold stress hypothermia risk is acute (< 25°C ambient)
  bool get isNeonatalHypothermiaThreat => ambientEvacuationTempCelsius < 25.0;
}
