/// Soil degradation classification per ICAR - Central Soil Salinity Research Institute (CSSRI).
enum SoilSalinitySodicityClass {
  normalArableSoil,
  salineSoilNonSodic,
  sodicAlkaliSoil,
  salineSodicSevereDegradation,
}

/// Agronomic reclamation assessment model for Post-Cyclone Saline Flooded Agricultural Land.
///
/// Implements ICAR (Indian Council of Agricultural Research) & CSSRI Karnal guidelines.
/// Formulates:
/// - Electrical Conductivity of saturated extract: EC_e (dS/m) (Threshold > 4.0 dS/m indicates salinity).
/// - Exchangeable Sodium Percentage: ESP = (Exchangeable Na / Cation Exchange Capacity) * 100 (> 15% indicates sodicity).
/// - Gypsum Requirement (GR) in tonnes/hectare:
///   GR = ((ESP_initial - ESP_target) / 100) * CEC * 0.086 * BulkDensityCorrection
/// - Leaching Water Requirement (LR) depth in cm: D_lw = (EC_iw / EC_dw) * D_irrigation
class SalineSoilReclamation {
  final String farmPlotId;
  final String talukDistrictName;
  final double farmAreaHectares;
  final double soilElectricalConductivityDsPerM; // EC_e in dS/m
  final double exchangeableSodiumPercentage; // ESP %
  final double cationExchangeCapacityMeqPer100g; // CEC in meq/100g (typically 15 - 35)
  final double soilPh; // Typically 7.0 - 10.0
  final double availableFreshWaterLeachingDepthCm;
  final bool hasSubsurfaceTileDrainageNetwork;

  const SalineSoilReclamation({
    required this.farmPlotId,
    required this.talukDistrictName,
    required this.farmAreaHectares,
    required this.soilElectricalConductivityDsPerM,
    required this.exchangeableSodiumPercentage,
    required this.cationExchangeCapacityMeqPer100g,
    required this.soilPh,
    required this.availableFreshWaterLeachingDepthCm,
    this.hasSubsurfaceTileDrainageNetwork = false,
  });

  /// Evaluates soil classification per CSSRI criteria.
  SoilSalinitySodicityClass get soilClass {
    final isSaline = soilElectricalConductivityDsPerM >= 4.0;
    final isSodic = exchangeableSodiumPercentage >= 15.0 || soilPh >= 8.5;

    if (isSaline && isSodic) {
      return SoilSalinitySodicityClass.salineSodicSevereDegradation;
    }
    if (isSaline) {
      return SoilSalinitySodicityClass.salineSoilNonSodic;
    }
    if (isSodic) {
      return SoilSalinitySodicityClass.sodicAlkaliSoil;
    }
    return SoilSalinitySodicityClass.normalArableSoil;
  }

  /// Calculates Agricultural Grade Gypsum Requirement (85% purity) in tonnes per hectare.
  /// Target ESP = 10.0%
  double get gypsumRequirementTonnesPerHectare {
    if (exchangeableSodiumPercentage <= 10.0) return 0.0;
    final deltaEsp = exchangeableSodiumPercentage - 10.0;
    // GR (tonnes/ha) = (delta_ESP / 100) * CEC * 1.72 * (100 / 85)
    final grPure = (deltaEsp / 100.0) * cationExchangeCapacityMeqPer100g * 1.72 * 1.176;
    return grPure.clamp(0.5, 35.0);
  }

  /// Total gypsum required for the entire farm plot in tonnes.
  double get totalGypsumRequiredTonnes {
    return gypsumRequirementTonnesPerHectare * farmAreaHectares;
  }

  /// Calculates minimum leaching freshwater depth (cm) needed to displace excess salt ions below root zone.
  double get requiredFreshWaterLeachingDepthCm {
    if (soilElectricalConductivityDsPerM <= 4.0) return 0.0;
    // Empirical: 1 cm of freshwater per dS/m excess over 4.0 dS/m
    final excessEc = soilElectricalConductivityDsPerM - 4.0;
    return (excessEc * 3.5).clamp(10.0, 60.0);
  }

  /// Evaluates whether current available irrigation water is adequate for full salt leaching.
  bool get isFreshWaterLeachingAdequate {
    return availableFreshWaterLeachingDepthCm >= requiredFreshWaterLeachingDepthCm;
  }

  /// Checks if salt-tolerant crop varieties (e.g. CSR-36, CSR-43, KRL-210) should be planted during reclamation.
  bool get isSaltTolerantCropVarietyRecommended {
    return soilClass != SoilSalinitySodicityClass.normalArableSoil;
  }
}
