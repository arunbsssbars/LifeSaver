/// Model representing CPCB (Solid Waste Management Rules 2016) & MoEFCC
/// Municipal Landfill Subsurface Smoldering Fire, Methane Migration & Toxic Smog Hazard.
enum LandfillFireSubsurfaceRisk {
  nominalAerobic('Normal Anaerobic Digestion - No Subsurface Fire', 0xFF10B981),
  subsurfaceSmoldering('Deep Subsurface Smoldering Combustion (> 65°C) - Inject Nitrogen/CO2', 0xFFFBBF24),
  surfaceMethaneFlare('CRITICAL LANDFILL FIRE - Methane Flare & Toxic Dioxin Emission - ACTIVATE FOAM/SOIL BLANKET', 0xFFEF4444);

  final String description;
  final int colorValue;
  const LandfillFireSubsurfaceRisk(this.description, this.colorValue);
}

class LandfillFireMethaneTelemetry {
  final String landfillSiteName;
  final double deepCoreTemperatureCelsius;
  final double methaneConcentrationPercentVol; // LEL is 5%, UEL is 15%
  final double carbonMonoxideConcentrationPpm; // CO > 100 ppm indicates deep smoldering
  final double surfacePerimeterMethaneDistanceMeters;
  final bool isPerimeterCutoffTrenchInstalled;

  const LandfillFireMethaneTelemetry({
    required this.landfillSiteName,
    required this.deepCoreTemperatureCelsius,
    required this.methaneConcentrationPercentVol,
    required this.carbonMonoxideConcentrationPpm,
    required this.surfacePerimeterMethaneDistanceMeters,
    required this.isPerimeterCutoffTrenchInstalled,
  });

  /// Evaluates landfill fire risk status
  LandfillFireSubsurfaceRisk get fireRiskStatus {
    if (deepCoreTemperatureCelsius >= 80.0 || (methaneConcentrationPercentVol >= 5.0 && methaneConcentrationPercentVol <= 15.0)) {
      return LandfillFireSubsurfaceRisk.surfaceMethaneFlare;
    } else if (deepCoreTemperatureCelsius >= 65.0 || carbonMonoxideConcentrationPpm >= 100.0) {
      return LandfillFireSubsurfaceRisk.subsurfaceSmoldering;
    }
    return LandfillFireSubsurfaceRisk.nominalAerobic;
  }

  /// True if subsurface methane is migrating off-site towards nearby residential colonies (> 20m from slope toe without cutoff trench)
  bool get isSubsurfaceMethaneMigrationHazard {
    return surfacePerimeterMethaneDistanceMeters > 20.0 && !isPerimeterCutoffTrenchInstalled;
  }

  /// True if soil capping layer of at least 30 cm thickness must be placed to starve oxygen
  bool get isSoilSmotheringBlanketMandated => fireRiskStatus != LandfillFireSubsurfaceRisk.nominalAerobic;
}
