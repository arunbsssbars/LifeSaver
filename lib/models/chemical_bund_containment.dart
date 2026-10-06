/// Model representing Oil Industry Safety Directorate (OISD-STD-118) & PESO
/// Petroleum & Hazardous Chemical Storage Tank Secondary Containment Bund Dyke Capacity.
class ChemicalBundContainmentAudit {
  final String tankFarmFacilityName;
  final double largestSingleTankVolumeKilolitres;
  final double totalEnclosedTanksAggregateVolumeKilolitres;
  final double bundInternalFloorAreaSqMeters;
  final double bundWallHeightMeters;
  final bool isRainwaterDrainageSiphonValveClosed;
  final bool isImperviousPccLiningIntact;

  const ChemicalBundContainmentAudit({
    required this.tankFarmFacilityName,
    required this.largestSingleTankVolumeKilolitres,
    required this.totalEnclosedTanksAggregateVolumeKilolitres,
    required this.bundInternalFloorAreaSqMeters,
    required this.bundWallHeightMeters,
    required this.isRainwaterDrainageSiphonValveClosed,
    required this.isImperviousPccLiningIntact,
  });

  /// Total Effective Net Bund Holding Volume in Kilolitres (excluding other tank displacement)
  double get effectiveBundCapacityKilolitres {
    final rawVolumeM3 = bundInternalFloorAreaSqMeters * bundWallHeightMeters;
    // OISD requires deducting approx 10% volume for other tank foundations/piping inside the bund
    final netVolumeM3 = rawVolumeM3 * 0.90;
    return netVolumeM3; // 1 m3 = 1 kL
  }

  /// Mandatory Minimum Bund Volume required under OISD-STD-118 (110% of largest tank capacity)
  double get mandatoryMinimumBundVolumeKilolitres => largestSingleTankVolumeKilolitres * 1.10;

  /// True if bund volume meets or exceeds statutory 110% catastrophic rupture rule
  bool get isBundCapacityCompliant => effectiveBundCapacityKilolitres >= mandatoryMinimumBundVolumeKilolitres;

  /// True if facility is at risk of uncontained toxic/flammable runoff into public water bodies
  bool get isUncontainedEnvironmentalSpillRisk {
    return !isBundCapacityCompliant || !isRainwaterDrainageSiphonValveClosed || !isImperviousPccLiningIntact;
  }
}
