/// Model representing NDDB & MoPNG GOBARdhan / SATAT Guidelines for
/// Village Community Cattle Biogas Digester Pressure Relief, Lightning Earthing & Flaring Safety.
class CattleBiogasDigesterSafety {
  final String villagePlantId;
  final double digesterGasPressureMillibar; // Normal: 15 to 30 mbar; Burst risk > 50 mbar
  final double methaneContentPercentCh4; // Typically 55% to 65%
  final double hydrogenSulfidePpmH2s; // Corrosive limit > 500 ppm
  final bool isFlameArresterMeshCleanAndIntact;
  final double earthingPitResistanceOhms; // Standard <= 5.0 Ohms

  const CattleBiogasDigesterSafety({
    required this.villagePlantId,
    required this.digesterGasPressureMillibar,
    required this.methaneContentPercentCh4,
    required this.hydrogenSulfidePpmH2s,
    required this.isFlameArresterMeshCleanAndIntact,
    required this.earthingPitResistanceOhms,
  });

  /// True if over-pressure emergency water-seal / flare vent must trip (Pressure > 40 mbar)
  bool get isOverPressureFlareTripRequired => digesterGasPressureMillibar >= 40.0;

  /// True if earthing pit satisfies lightning/static spark prevention standards (<= 5.0 Ohms)
  bool get isLightningEarthingCompliant => earthingPitResistanceOhms <= 5.0;

  /// True if hydrogen sulfide scrubber needs bio-media / iron sponge replacement (H2S > 500 ppm)
  bool get isBioScrubberMediaRechargeRequired => hydrogenSulfidePpmH2s >= 500.0;

  /// True if biogas plant operation is completely safe and explosion-protected
  bool get isDigesterOperationSafe {
    return !isOverPressureFlareTripRequired && isLightningEarthingCompliant && isFlameArresterMeshCleanAndIntact;
  }
}
