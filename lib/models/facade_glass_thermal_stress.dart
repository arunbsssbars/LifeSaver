/// Model representing Bureau of Indian Standards (IS 16700:2017) & NBC 2016
/// High-Rise Glazed Facade Earthquake Inter-Story Drift & Fire Thermal Fallout Pedestrian Safety.
class FacadeGlassSafetyAudit {
  final String buildingTowerName;
  final double measuredInterStoryDriftRatio; // Statutory limit theta <= 0.004 in seismic zones
  final double glassThermalStressTempGradientC; // Critical breaking gradient >= 40°C in annealed glass
  final bool isTemperedLaminatedSafetyGlass; // Mandated to prevent falling shards
  final double pedestrianCanopyProjectionMeters; // Egress overhead protection

  const FacadeGlassSafetyAudit({
    required this.buildingTowerName,
    required this.measuredInterStoryDriftRatio,
    required this.glassThermalStressTempGradientC,
    required this.isTemperedLaminatedSafetyGlass,
    required this.pedestrianCanopyProjectionMeters,
  });

  /// True if seismic racking drift threatens facade panel pop-out & glass fracture (theta > 0.004)
  bool get isSeismicDriftExceedanceRisk => measuredInterStoryDriftRatio > 0.004;

  /// True if thermal shock from post-earthquake fire or solar heating will induce spontaneous glass breakage
  bool get isThermalStressSpallingRisk {
    return !isTemperedLaminatedSafetyGlass && glassThermalStressTempGradientC >= 40.0;
  }

  /// True if overhead pedestrian crash canopy meets statutory street protection standards (>= 3.0 meters)
  bool get isPedestrianProtectionCanopyAdequate => pedestrianCanopyProjectionMeters >= 3.0;

  /// Overall High-Rise Glazing Safety Compliance
  bool get isFacadeGlassFalloutCertified {
    return !isSeismicDriftExceedanceRisk && isTemperedLaminatedSafetyGlass && isPedestrianProtectionCanopyAdequate;
  }
}
