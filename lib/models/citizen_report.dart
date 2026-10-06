/// Model representing a crowdsourced citizen disaster report with community verification & credibility score.
enum DisasterHazardType {
  floodedRoad(name: 'Flooded Road / Submerged Culvert', iconCode: 'water'),
  bridgeCollapse(name: 'Damaged / Inundated Bridge', iconCode: 'arch'),
  landslideBlockage(name: 'Landslide / Rockfall Road Blockage', iconCode: 'landslide'),
  fallenTree(name: 'Fallen Tree / Blocked Route', iconCode: 'tree'),
  electricalHazard(name: 'Snaped Live Wire / Substation Spark', iconCode: 'bolt'),
  strandedCivilians(name: 'Trapped Civilians Needing Boat Evacuation', iconCode: 'sos');

  final String name;
  final String iconCode;

  const DisasterHazardType({
    required this.name,
    required this.iconCode,
  });
}

class CitizenHazardReport {
  final String reportId;
  final DisasterHazardType hazardType;
  final String title;
  final String description;
  final double latitude;
  final double longitude;
  final String districtName;
  final DateTime reportedAt;
  final int verificationCount;
  final bool isAuthorityVerified;

  const CitizenHazardReport({
    required this.reportId,
    required this.hazardType,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.districtName,
    required this.reportedAt,
    this.verificationCount = 1,
    this.isAuthorityVerified = false,
  });

  /// Computes report credibility score percentage
  double get credibilityScore {
    if (isAuthorityVerified) return 100.0;
    // 5 community verifications achieve ~90% credibility
    return (verificationCount * 18.0).clamp(18.0, 95.0);
  }
}
