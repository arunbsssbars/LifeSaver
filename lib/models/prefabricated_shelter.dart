/// Model representing Building Materials & Technology Promotion Council (BMTPC) & NDMA
/// Rapid Assembly Transitional Shelters and Thermal Insulation Standards.
class PrefabricatedShelterUnit {
  final String unitId;
  final double internalFloorAreaSqMeters;
  final int intendedOccupantCount;
  final double assemblyTimeHours;
  final bool hasPufInsulatedSandwichPanels;
  final bool isWindResistantUpTo180Kmh;

  const PrefabricatedShelterUnit({
    required this.unitId,
    required this.internalFloorAreaSqMeters,
    required this.intendedOccupantCount,
    required this.assemblyTimeHours,
    required this.hasPufInsulatedSandwichPanels,
    required this.isWindResistantUpTo180Kmh,
  });

  /// Floor area per occupant in sq meters (SPHERE/NDMA standard: minimum 3.5 m² per person)
  double get floorAreaPerOccupant => internalFloorAreaSqMeters / intendedOccupantCount;

  /// True if shelter meets SPHERE and BMTPC statutory space norms
  bool get meetsSphereSpaceNorms => floorAreaPerOccupant >= 3.5;
}
