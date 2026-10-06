/// Model representing MoHFW & Indian Society of Nephrology Guidelines for
/// Hospital Hemodialysis Unit Emergency Ultrapure RO Water Buffer & Critical Power Autonomy.
class HospitalDialysisAutonomyTelemetry {
  final String hospitalHemodialysisUnitName;
  final int activeDialysisStationsCount;
  final double ultrapureRoWaterStorageLitres;
  final double feedWaterConsumptionPerStationLph; // Typically 30 to 50 Litres/hour/station
  final double backupDgGeneratorFuelLitres;
  final double fuelBurnRateLitresPerHour;

  const HospitalDialysisAutonomyTelemetry({
    required this.hospitalHemodialysisUnitName,
    required this.activeDialysisStationsCount,
    required this.ultrapureRoWaterStorageLitres,
    required this.feedWaterConsumptionPerStationLph,
    required this.backupDgGeneratorFuelLitres,
    required this.fuelBurnRateLitresPerHour,
  });

  /// Total RO Water Consumption Rate in Litres/hour
  double get totalWaterConsumptionLph => activeDialysisStationsCount * feedWaterConsumptionPerStationLph;

  /// Pure Water Operating Autonomy in Hours
  double get waterOperatingAutonomyHours {
    if (totalWaterConsumptionLph <= 0.0) return 99.0;
    return ultrapureRoWaterStorageLitres / totalWaterConsumptionLph;
  }

  /// Emergency Power Generator Autonomy in Hours
  double get powerGeneratorAutonomyHours {
    if (fuelBurnRateLitresPerHour <= 0.0) return 99.0;
    return backupDgGeneratorFuelLitres / fuelBurnRateLitresPerHour;
  }

  /// Effective Disaster Dialysis Autonomy in Hours (limited by water or power, whichever is lower)
  double get effectiveDialysisAutonomyHours {
    return mathMinDouble(waterOperatingAutonomyHours, powerGeneratorAutonomyHours);
  }

  /// Helper for min value
  static double mathMinDouble(double a, double b) => a < b ? a : b;

  /// True if dialysis unit meets statutory disaster resilience benchmark (>= 48 hours continuous autonomy)
  bool get isDisasterDialysisCompliant => effectiveDialysisAutonomyHours >= 48.0;

  /// True if acute water/power depletion warning is triggered (< 12 hours remaining)
  bool get isCriticalDialysisDepletionAlert => effectiveDialysisAutonomyHours < 12.0;
}
