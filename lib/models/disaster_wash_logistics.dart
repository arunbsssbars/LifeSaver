/// Model representing NDMA Relief Camp Standards & SPHERE Humanitarian WASH Standards.
class DisasterWashLogistics {
  final int affectedPopulationCount;
  final int durationDays;

  const DisasterWashLogistics({
    required this.affectedPopulationCount,
    required this.durationDays,
  });

  /// Total potable drinking and basic survival water requirement in Liters
  /// SPHERE standard: 15 Liters / person / day (3L drinking + 12L hygiene/cooking)
  double get totalWaterRequirementLiters => affectedPopulationCount * 15.0 * durationDays;

  /// Daily drinking-only water requirement (3L/person/day)
  double get dailyDrinkingWaterLiters => affectedPopulationCount * 3.0;

  /// Emergency latrine requirement (SPHERE standard: 1 toilet per 20 persons, segregated 3:1 for females)
  int get totalToiletsRequired => (affectedPopulationCount / 20.0).ceil();
  int get femaleToiletsRequired => ((affectedPopulationCount / 20.0) * 0.6).ceil();
  int get maleToiletsRequired => totalToiletsRequired - femaleToiletsRequired;

  /// Monthly soap distribution in bars (250g soap per person per month)
  int get soapBarsPerMonth => (affectedPopulationCount * 1.5).ceil();

  /// Solid waste bin requirement (1 100-liter bin per 10 families / ~50 persons)
  int get wasteBinsRequired => (affectedPopulationCount / 50.0).ceil();

  /// Chlorine disinfection dosage (0.5 mg/L free residual chlorine at point of delivery)
  double get totalBleachingPowderKg => (totalWaterRequirementLiters * 0.0025) / 1000.0;
}
