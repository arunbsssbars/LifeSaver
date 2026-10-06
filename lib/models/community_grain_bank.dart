/// Model representing Food Corporation of India (FCI) & NDMA Village Community Grain & Seed Bank Resilience.
class CommunityGrainBankProfile {
  final String villagePanchayatName;
  final int beneficiaryFamiliesCount;
  final double wheatRiceStockMetricTons;
  final double pulsesSeedStockMetricTons;
  final bool hasHermeticMoistureProofSilo;
  final double elevatedPlinthHeightAboveGroundMeters;

  const CommunityGrainBankProfile({
    required this.villagePanchayatName,
    required this.beneficiaryFamiliesCount,
    required this.wheatRiceStockMetricTons,
    required this.pulsesSeedStockMetricTons,
    required this.hasHermeticMoistureProofSilo,
    required this.elevatedPlinthHeightAboveGroundMeters,
  });

  /// Monthly food grain demand (15 kg per family per month)
  double get monthlyDemandMetricTons => (beneficiaryFamiliesCount * 15.0) / 1000.0;

  /// Months of food autonomy provided by stored grain reserves
  double get grainAutonomyMonths {
    if (monthlyDemandMetricTons == 0) return 99.0;
    return wheatRiceStockMetricTons / monthlyDemandMetricTons;
  }

  /// True if village has statutory 3-month disaster emergency buffer stock
  bool get hasStatutory3MonthBuffer => grainAutonomyMonths >= 3.0 && hasHermeticMoistureProofSilo;
}
