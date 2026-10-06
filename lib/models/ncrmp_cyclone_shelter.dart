/// Model representing National Cyclone Risk Mitigation Project (NCRMP - World Bank/NDMA)
/// Multipurpose Cyclone Shelter (MPCS) structural telemetry and capacity tracking.
class MultipurposeCycloneShelter {
  final String shelterId;
  final String shelterName;
  final String coastalDistrict;
  final double distanceToCoastlineKm;
  final int humanCapacity;
  final int currentHumanOccupancy;
  final int groundFloorLivestockCapacity;
  final double plinthHeightAboveHighTideMeters;
  final bool hasSolarPowerWithBattery;
  final bool hasDesalinationRoUnit;
  final String nodalContact;

  const MultipurposeCycloneShelter({
    required this.shelterId,
    required this.shelterName,
    required this.coastalDistrict,
    required this.distanceToCoastlineKm,
    required this.humanCapacity,
    required this.currentHumanOccupancy,
    required this.groundFloorLivestockCapacity,
    required this.plinthHeightAboveHighTideMeters,
    required this.hasSolarPowerWithBattery,
    required this.hasDesalinationRoUnit,
    required this.nodalContact,
  });

  /// Available capacity remaining
  int get remainingCapacity => (humanCapacity - currentHumanOccupancy).clamp(0, humanCapacity);

  /// Occupancy percentage
  double get occupancyRatePercent => (currentHumanOccupancy / humanCapacity) * 100;

  /// True if shelter has space available
  bool get hasAvailableSpace => currentHumanOccupancy < humanCapacity;

  static List<MultipurposeCycloneShelter> getMockCoastalShelters(String coastalDistrict) {
    return [
      MultipurposeCycloneShelter(
        shelterId: 'MPCS-OD-01',
        shelterName: 'Puri Coastal MPCS Shelter #12',
        coastalDistrict: coastalDistrict,
        distanceToCoastlineKm: 1.2,
        humanCapacity: 1500,
        currentHumanOccupancy: 420,
        groundFloorLivestockCapacity: 200,
        plinthHeightAboveHighTideMeters: 4.8,
        hasSolarPowerWithBattery: true,
        hasDesalinationRoUnit: true,
        nodalContact: '+91 94370 12345',
      ),
      MultipurposeCycloneShelter(
        shelterId: 'MPCS-OD-02',
        shelterName: 'Astaranga Elevated Cyclone Safe Haven',
        coastalDistrict: coastalDistrict,
        distanceToCoastlineKm: 0.8,
        humanCapacity: 2000,
        currentHumanOccupancy: 850,
        groundFloorLivestockCapacity: 350,
        plinthHeightAboveHighTideMeters: 5.5,
        hasSolarPowerWithBattery: true,
        hasDesalinationRoUnit: true,
        nodalContact: '+91 94370 67890',
      ),
    ];
  }
}
