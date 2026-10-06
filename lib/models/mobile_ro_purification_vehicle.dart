/// Model representing Jal Jeevan Mission & CSIR-CSMCRI
/// Mobile Vehicle-Mounted Disaster Emergency Reverse Osmosis (RO) Purification & Water ATM Logistics.
class MobileRoPurificationVehicle {
  final String vehicleRegistrationNumber;
  final String activeDisasterZone;
  final double feedWaterTdsMgPerLitre;
  final double rawWaterTurbidityNtu;
  final double permeateProductionRateLitresPerHour; // Typically 1000 to 3000 LPH
  final double dieselGeneratorFuelRemainingLitres;
  final double fuelConsumptionLitresPerHour;

  const MobileRoPurificationVehicle({
    required this.vehicleRegistrationNumber,
    required this.activeDisasterZone,
    required this.feedWaterTdsMgPerLitre,
    required this.rawWaterTurbidityNtu,
    required this.permeateProductionRateLitresPerHour,
    required this.dieselGeneratorFuelRemainingLitres,
    required this.fuelConsumptionLitresPerHour,
  });

  /// Operating Autonomy in Hours with on-board fuel
  double get generatorOperatingAutonomyHours {
    if (fuelConsumptionLitresPerHour <= 0.0) return 99.0;
    return dieselGeneratorFuelRemainingLitres / fuelConsumptionLitresPerHour;
  }

  /// Total Potable Water Production Capability (Litres) before refuel
  double get totalPotableWaterCapacityLitres {
    return generatorOperatingAutonomyHours * permeateProductionRateLitresPerHour;
  }

  /// Total Population Servable per day (Sphere Standard: 15 Litres/person/day for drinking & cooking)
  int get servablePopulationPerDay {
    const dailyWaterPerPerson = 15.0;
    final dailyProduction = permeateProductionRateLitresPerHour * 20.0; // 20 operating hours/day
    return (dailyProduction / dailyWaterPerPerson).floor();
  }

  /// True if vehicle can treat high-salinity brackish/flood water (TDS up to 5000 mg/L)
  bool get isHighSalinityFeedCapable => feedWaterTdsMgPerLitre <= 5000.0;
}
