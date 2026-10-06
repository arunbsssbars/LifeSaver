/// Model representing NDMA National School Safety Policy (NSSP 2016)
/// and School Disaster Management Plan (SDMP) compliance metrics.
class SchoolSafetyComplianceAudit {
  final String schoolName;
  final int totalStudentCount;
  final int totalStaffCount;
  final bool hasStructuralSafetyNoc;
  final bool hasUnobstructedFireStairwells;
  final bool hasTrainedAapdaPrabandhanTeacherTeam;
  final int mockDrillsConductedThisYear;
  final bool hasFirstAidStationsOnEveryFloor;
  final bool hasDesignatedSafeOpenGroundAssemblyZone;

  const SchoolSafetyComplianceAudit({
    required this.schoolName,
    required this.totalStudentCount,
    required this.staffCount,
    required this.hasStructuralSafetyNoc,
    required this.hasUnobstructedFireStairwells,
    required this.hasTrainedAapdaPrabandhanTeacherTeam,
    required this.mockDrillsConductedThisYear,
    required this.hasFirstAidStationsOnEveryFloor,
    required this.hasDesignatedSafeOpenGroundAssemblyZone,
  }) : totalStaffCount = staffCount;

  final int staffCount;

  /// Total compliance percentage score based on NSSP standards
  double get complianceScorePercent {
    int points = 0;
    if (hasStructuralSafetyNoc) points += 20;
    if (hasUnobstructedFireStairwells) points += 20;
    if (hasTrainedAapdaPrabandhanTeacherTeam) points += 20;
    if (mockDrillsConductedThisYear >= 2) points += 20;
    if (hasFirstAidStationsOnEveryFloor) points += 10;
    if (hasDesignatedSafeOpenGroundAssemblyZone) points += 10;
    return points.toDouble();
  }

  /// True if school meets statutory safety guidelines
  bool get isStatutoryCompliant => complianceScorePercent >= 80.0;
}
