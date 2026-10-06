/// Model representing AERB & BARC Nuclear Safety Guidelines for
/// Nuclear Power Plant Spent Fuel Pool (SFP) & Passive Containment Cooling System (PCCS).
class NuclearContainmentCoolingTelemetry {
  final String reactorFacilityName;
  final double spentFuelPoolWaterLevelMeters;
  final double spentFuelPoolWaterTemperatureCelsius;
  final double decayHeatGenerationMegaWatts;
  final double boronConcentrationPpm; // Statutory shutdown reserve >= 2200 ppm
  final double emergencyMakeupWaterReservoirVolumeM3;

  const NuclearContainmentCoolingTelemetry({
    required this.reactorFacilityName,
    required this.spentFuelPoolWaterLevelMeters,
    required this.spentFuelPoolWaterTemperatureCelsius,
    required this.decayHeatGenerationMegaWatts,
    required this.boronConcentrationPpm,
    required this.emergencyMakeupWaterReservoirVolumeM3,
  });

  /// True if spent fuel pool water level is below statutory AERB safety datum (< 7.0 meters above fuel assemblies)
  bool get isSpentFuelUncoveryRisk => spentFuelPoolWaterLevelMeters < 7.0;

  /// True if spent fuel pool cooling is degrading towards boiling condition (> 65°C)
  bool get isPoolThermalOverheatAlert => spentFuelPoolWaterTemperatureCelsius >= 65.0;

  /// True if subcriticality margin is compromised (Boron < 2200 ppm)
  bool get isBoronDilutionRisk => boronConcentrationPpm < 2200.0;

  /// Passive water boil-off autonomy hours remaining without active AC power (Station Blackout / Fukushima resilience)
  double get passiveBoilOffAutonomyHours {
    if (decayHeatGenerationMegaWatts <= 0.0) return 999.0;
    // Latent heat of vaporization of water = 2.26 MJ/kg (~0.627 kWh/kg). 1 MW = 3600 MJ/hr.
    // Water boil-off rate in m3/hr = (MW * 3600) / 2260 = ~1.59 m3/hr per MW
    final boilOffRateM3PerHour = decayHeatGenerationMegaWatts * 1.59;
    return (emergencyMakeupWaterReservoirVolumeM3 / boilOffRateM3PerHour).clamp(0.0, 720.0);
  }

  /// True if external mobile diesel-driven water injection (Ultimate Heat Sink) is mandatory
  bool get isUltimateHeatSinkInjectionMandated => isSpentFuelUncoveryRisk || isPoolThermalOverheatAlert;
}
