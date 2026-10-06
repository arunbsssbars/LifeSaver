/// Model representing Food Corporation of India (FCI), ICAR & BIS IS 6399
/// Rural Hermetic Grain Storage Silo Post-Harvest Food Preservation & Bio-Deterioration Defense.
enum GrainStoragePreservationQuality {
  primeNutritionalGrade('Prime Storage Grade (Moisture <= 12%, O2 < 3%) - Free of Weevils & Aflatoxins', 0xFF10B981),
  moderatePestRisk('Moderate Quality (Moisture 12-14%, O2 3-8%) - Aeration Purge Recommended', 0xFFFBBF24),
  fungalAflatoxinDanger('SPOILED / FUNGAL CONTAMINATION DANGER (Moisture > 14%, O2 > 8%) - IMMEDIATE DRYING', 0xFFEF4444);

  final String status;
  final int colorValue;
  const GrainStoragePreservationQuality(this.status, this.colorValue);
}

class HermeticGrainSiloTelemetry {
  final String siloUnitId;
  final String villagePanchayatName;
  final double storedGrainMassTonnes;
  final double grainMoisturePercentage; // Standard safe limit <= 12.0%
  final double internalOxygenConcentrationPercent; // Hermetic target < 3.0% O2 to asphyxiate insect pests
  final double grainCoreTemperatureCelsius;
  final bool isHermeticGasketSealIntact;

  const HermeticGrainSiloTelemetry({
    required this.siloUnitId,
    required this.villagePanchayatName,
    required this.storedGrainMassTonnes,
    required this.grainMoisturePercentage,
    required this.internalOxygenConcentrationPercent,
    required this.grainCoreTemperatureCelsius,
    required this.isHermeticGasketSealIntact,
  });

  /// Evaluates grain preservation quality status
  GrainStoragePreservationQuality get storageQuality {
    if (grainMoisturePercentage > 14.0 || grainCoreTemperatureCelsius > 38.0 || !isHermeticGasketSealIntact) {
      return GrainStoragePreservationQuality.fungalAflatoxinDanger;
    } else if (grainMoisturePercentage > 12.0 || internalOxygenConcentrationPercent > 3.0) {
      return GrainStoragePreservationQuality.moderatePestRisk;
    }
    return GrainStoragePreservationQuality.primeNutritionalGrade;
  }

  /// Estimated insect mortality percentage from hermetic bio-asphyxiation
  double get insectMortalityRatePercent {
    if (internalOxygenConcentrationPercent <= 2.0) return 99.9;
    if (internalOxygenConcentrationPercent <= 5.0) return 85.0;
    return 20.0;
  }

  /// True if grain must be solar-dried immediately to prevent Aspergillus flavus / Aflatoxin B1 contamination
  bool get isEmergencyGrainDryingMandated => grainMoisturePercentage > 13.5;
}
