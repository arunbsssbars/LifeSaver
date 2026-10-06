/// Model representing National Cold Chain Management Information System (NCCMIS) & WHO PQS
/// Disaster Vaccine & Anti-Snake Venom (ASV) Solar Direct Drive (SDD) Refrigerator Telemetry.
enum ColdChainExcursionStatus {
  normalColdChain('Normal Potency Storage (+2°C to +8°C)', 0xFF10B981),
  freezeWarning('FREEZE EXCURSION (< +2°C) - Risk of Aluminum Adjuvant Vaccine Freezing', 0xFF3B82F6),
  heatBreach('HEAT EXCURSION (> +8°C) - Potency Degradation Risk - ACTIVATE BACKUP ICE PACKS', 0xFFEF4444);

  final String alert;
  final int colorValue;
  const ColdChainExcursionStatus(this.alert, this.colorValue);
}

class VaccineColdChainTelemetry {
  final String coldChainUnitId;
  final String locationPhcChcName;
  final double internalTemperatureCelsius;
  final double solarBatteryVoltageVolts;
  final double sddHoldoverRemainingHours;
  final int storedAntiSnakeVenomVialsCount;
  final int storedRabiesTetanusDosesCount;

  const VaccineColdChainTelemetry({
    required this.coldChainUnitId,
    required this.locationPhcChcName,
    required this.internalTemperatureCelsius,
    required this.solarBatteryVoltageVolts,
    required this.sddHoldoverRemainingHours,
    required this.storedAntiSnakeVenomVialsCount,
    required this.storedRabiesTetanusDosesCount,
  });

  /// Evaluates cold chain temperature excursion status
  ColdChainExcursionStatus get excursionStatus {
    if (internalTemperatureCelsius < 2.0) {
      return ColdChainExcursionStatus.freezeWarning;
    } else if (internalTemperatureCelsius > 8.0) {
      return ColdChainExcursionStatus.heatBreach;
    }
    return ColdChainExcursionStatus.normalColdChain;
  }

  /// True if cold chain unit is in imminent danger of blackout failure (holdover autonomy < 12 hours)
  bool get isHoldoverDepletionAlert => sddHoldoverRemainingHours < 12.0;

  /// Total critical life-saving doses safely maintained
  int get totalCriticalDosesSecured => storedAntiSnakeVenomVialsCount + storedRabiesTetanusDosesCount;
}
