/// Model representing National Building Code of India (NBC 2016 Part 4) & IS 1644
/// High-Rise Building Fire Escape Staircase Positive Pressurization & Smoke Barrier System.
class StairwellPressurizationAudit {
  final String highRiseTowerName;
  final int totalFloorsCount;
  final double measuredPressureDifferentialPascals; // Statutory standard: 45 Pa to 60 Pa
  final double doorOpeningForceNewtons; // Maximum permissible force <= 133 N (to allow egress of elderly/children)
  final double egressDoorAirVelocityMetersPerSec; // Minimum 1.0 m/s with doors open
  final bool isFireSmokeDamperInterlocked;

  const StairwellPressurizationAudit({
    required this.highRiseTowerName,
    required this.totalFloorsCount,
    required this.measuredPressureDifferentialPascals,
    required this.doorOpeningForceNewtons,
    required this.egressDoorAirVelocityMetersPerSec,
    required this.isFireSmokeDamperInterlocked,
  });

  /// True if stairwell pressure differential is sufficient to block smoke ingress (45 Pa to 60 Pa per NBC)
  bool get isPressureDifferentialCompliant {
    return measuredPressureDifferentialPascals >= 45.0 && measuredPressureDifferentialPascals <= 60.0;
  }

  /// True if escape doors can be pushed open without trapping occupants (Force <= 133 N)
  bool get isDoorOpeningForceSafe => doorOpeningForceNewtons <= 133.0;

  /// True if airflow through opened doors prevents backflow of smoke into the escape core (Velocity >= 1.0 m/s)
  bool get isSmokeBarrierVelocityAdequate => egressDoorAirVelocityMetersPerSec >= 1.0;

  /// Overall Fire Safety Life Certification Status
  bool get isStaircaseSmokeContainmentCertified {
    return isPressureDifferentialCompliant && isDoorOpeningForceSafe && isSmokeBarrierVelocityAdequate && isFireSmokeDamperInterlocked;
  }
}
