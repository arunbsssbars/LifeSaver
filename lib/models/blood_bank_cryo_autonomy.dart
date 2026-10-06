/// Model representing MoHFW, NACO & CDSCO Standards for
/// Disaster Emergency Blood Bank Cryopreservation, Packed Red Blood Cells (PRBC) & Cold Holdover Autonomy.
class BloodBankCryoAutonomyTelemetry {
  final String bloodBankFacilityId;
  final int storedPrbcUnitsCount; // Stored at +2°C to +6°C (35–42 days shelf life)
  final int storedFreshFrozenPlasmaUnitsCount; // Stored at -30°C to -80°C
  final int storedPlateletConcentrateUnitsCount; // Stored at +20°C to +24°C with continuous agitation
  final double prbcRefrigeratorTempCelsius;
  final double ffpDeepFreezerTempCelsius;
  final double phaseChangeThermalHoldoverHours;
  final bool isEmergencySolarBatteryBackingActive;

  const BloodBankCryoAutonomyTelemetry({
    required this.bloodBankFacilityId,
    required this.storedPrbcUnitsCount,
    required this.storedFreshFrozenPlasmaUnitsCount,
    required this.storedPlateletConcentrateUnitsCount,
    required this.prbcRefrigeratorTempCelsius,
    required this.ffpDeepFreezerTempCelsius,
    required this.phaseChangeThermalHoldoverHours,
    required this.isEmergencySolarBatteryBackingActive,
  });

  /// Total Life-Saving Blood Component Units Secured
  int get totalBloodComponentsCount => storedPrbcUnitsCount + storedFreshFrozenPlasmaUnitsCount + storedPlateletConcentrateUnitsCount;

  /// True if PRBC refrigerator temperature is compliant with CDSCO (+2°C to +6°C)
  bool get isPrbcTemperatureCompliant => prbcRefrigeratorTempCelsius >= 2.0 && prbcRefrigeratorTempCelsius <= 6.0;

  /// True if FFP deep freezer temperature is compliant (<= -30°C)
  bool get isFfpTemperatureCompliant => ffpDeepFreezerTempCelsius <= -30.0;

  /// True if thermal holdover is in critical depletion (< 6 hours remaining)
  bool get isThermalHoldoverDepletionAlert => phaseChangeThermalHoldoverHours < 6.0;

  /// True if blood bank cold chain is fully secure during grid blackout
  bool get isBloodBankColdChainSecure {
    return isPrbcTemperatureCompliant && isFfpTemperatureCompliant && isEmergencySolarBatteryBackingActive;
  }
}
