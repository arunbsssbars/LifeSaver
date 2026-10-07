/// Loop 150: High-Rise Elevator Shaft Entrapment & Emergency Landing Brake Model
/// Aligned with Bureau of Indian Standards IS 14665 & NBC 2016 Part 4.

class ElevatorShaftRescue {
  final int stalledFloorLevel;
  final int totalBuildingFloors;
  final int trappedOccupantCount;
  final bool isSmokePresentInShaft;
  final bool isGovernorSafetyBrakeEngaged;
  final bool isLandingDoorInterlockAligned;

  const ElevatorShaftRescue({
    required this.stalledFloorLevel,
    required this.totalBuildingFloors,
    required this.trappedOccupantCount,
    required this.isSmokePresentInShaft,
    required this.isGovernorSafetyBrakeEngaged,
    required this.isLandingDoorInterlockAligned,
  });

  /// Recommended Passenger Posture during emergency stall / rapid descent
  /// (Debunks dangerous myth of jumping or lying flat on back)
  String get passengerSurvivalPosture {
    return 'SURVIVAL POSTURE: Stand in center of elevator car, keep knees bent, hold handrails firmly, and crouch slightly to let leg muscles act as natural shock absorbers.';
  }

  /// Tactical Extraction Protocol for Fire Brigade / NDRF
  String get tacticalExtractionProtocol {
    if (isSmokePresentInShaft) {
      return 'FIRE IN SHAFT: Lock out main electrical power, use drop-key on nearest upper landing door, deploy rescue rope ladder and extract occupants immediately before toxic smoke buildup.';
    } else if (isLandingDoorInterlockAligned) {
      return 'CAR LEVEL: Use lunar key / release rod on outer landing door interlock, mechanically open car doors, and assist occupants onto landing floor.';
    } else {
      return 'MISALIGNED STALL: Engage car top emergency brake, manually hand-wind traction motor brake to level car with nearest floor, or evacuate through car roof escape hatch with safety harnesses.';
    }
  }

  /// Critical Prohibition for Trapped Passengers
  String get trappedPassengerProhibition =>
      'STRICT WARNING: Never attempt to climb out through half-opened doors or pry elevator shaft doors alone; sudden releveling or car motion causes fatal crush shears!';
}
