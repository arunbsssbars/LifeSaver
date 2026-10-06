/// Model representing National Institute of Ocean Technology (NIOT) & MoES
/// Lakshadweep / Andaman Island Low-Temperature Thermal Desalination (LTTD) Emergency Fresh Water Autonomy.
class IslandDesalinationPlantTelemetry {
  final String islandLocationName;
  final double surfaceSeaWaterTemperatureCelsius; // ~28°C to 30°C
  final double deepSeaWaterTemperatureCelsius; // ~7°C to 10°C drawn from 350m depth
  final double plantDesignCapacityLitresPerDay; // e.g., 100,000 LPD
  final double currentIslandPopulation;
  final double islandFreshwaterStorageLitres;

  const IslandDesalinationPlantTelemetry({
    required this.islandLocationName,
    required this.surfaceSeaWaterTemperatureCelsius,
    required this.deepSeaWaterTemperatureCelsius,
    required this.plantDesignCapacityLitresPerDay,
    required this.currentIslandPopulation,
    required this.islandFreshwaterStorageLitres,
  });

  /// Thermal Temperature Differential Delta T (°C) driving flash evaporation in vacuum
  double get thermalGradientDeltaTCelsius => surfaceSeaWaterTemperatureCelsius - deepSeaWaterTemperatureCelsius;

  /// True if thermal gradient is sufficient for LTTD vacuum condensation (Delta T >= 15°C)
  bool get isThermalGradientOptimal => thermalGradientDeltaTCelsius >= 15.0;

  /// Effective daily freshwater production (LPD) adjusted for thermal gradient
  double get effectiveDailyFreshwaterOutputLitres {
    if (!isThermalGradientOptimal) return plantDesignCapacityLitresPerDay * 0.60;
    return plantDesignCapacityLitresPerDay;
  }

  /// Island Community Water Autonomy in Days (based on 20 Litres/person/day)
  double get islandDrinkingWaterAutonomyDays {
    final dailyDemand = currentIslandPopulation * 20.0;
    if (dailyDemand <= 0.0) return 999.0;
    return islandFreshwaterStorageLitres / dailyDemand;
  }

  /// True if island water reserve is critically low (< 3 days autonomy during cyclone storm surge)
  bool get isIslandWaterCrisisAlert => islandDrinkingWaterAutonomyDays < 3.0;
}
