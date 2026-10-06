/// Model representing CPHEEO Manual on Sewerage & Prohibition of Employment as Manual Scavengers Act 2013
/// Underground Sewer & Manhole Confined Space Multi-Gas Toxicity & Rescue Trolley Safety.
enum ConfinedSpaceSafetyStatus {
  safeToEnterMechanical('Safe for Mechanized Entry with Tripod & Continuous Air Monitoring', 0xFF10B981),
  hazardousToxicAlert('Hazardous Toxic Gas Concentration - Pre-Entry Mechanical Blowers Required (min 30 min)', 0xFFFBBF24),
  lethalAsphyxiationDanger('LETHAL ASPHYXIATION & EXPLOSIVE DANGER - ENTRY STRICTLY FORBIDDEN', 0xFFEF4444);

  final String guidance;
  final int colorValue;
  const ConfinedSpaceSafetyStatus(this.guidance, this.colorValue);
}

class ConfinedSpaceSewerGasTelemetry {
  final String manholeChamberId;
  final double oxygenPercentageO2; // Safe range: 19.5% to 23.5%
  final double hydrogenSulfidePpmH2s; // OSHA/CPHEEO ceiling limit >= 10 ppm
  final double carbonMonoxidePpmCo; // Safe limit <= 25 ppm
  final double methanePercentLelCh4; // Explosive threshold >= 10% LEL
  final bool hasPositivePressureAirlineTrolley;
  final bool hasSafetyHarnessAndRescueTripod;

  const ConfinedSpaceSewerGasTelemetry({
    required this.manholeChamberId,
    required this.oxygenPercentageO2,
    required this.hydrogenSulfidePpmH2s,
    required this.carbonMonoxidePpmCo,
    required this.methanePercentLelCh4,
    required this.hasPositivePressureAirlineTrolley,
    required this.hasSafetyHarnessAndRescueTripod,
  });

  /// Evaluates confined space multi-gas safety status
  ConfinedSpaceSafetyStatus get spaceSafetyStatus {
    if (oxygenPercentageO2 < 19.5 || hydrogenSulfidePpmH2s >= 20.0 || methanePercentLelCh4 >= 10.0 || carbonMonoxidePpmCo >= 50.0) {
      return ConfinedSpaceSafetyStatus.lethalAsphyxiationDanger;
    } else if (hydrogenSulfidePpmH2s >= 10.0 || carbonMonoxidePpmCo >= 25.0 || oxygenPercentageO2 > 23.5) {
      return ConfinedSpaceSafetyStatus.hazardousToxicAlert;
    }
    return ConfinedSpaceSafetyStatus.safeToEnterMechanical;
  }

  /// True if entry is completely prohibited under the MS Act 2013
  bool get isEntryProhibited => spaceSafetyStatus != ConfinedSpaceSafetyStatus.safeToEnterMechanical || !hasSafetyHarnessAndRescueTripod;

  /// True if immediate forced ventilation air-purge is mandated
  bool get isForcedAirPurgingMandated => hydrogenSulfidePpmH2s > 0.0 || methanePercentLelCh4 > 0.0 || oxygenPercentageO2 < 20.0;
}
