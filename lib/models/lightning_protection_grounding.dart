import 'dart:math' as math;

/// Model representing Bureau of Indian Standards (IS/IEC 62305) & NBC 2016
/// Structural Lightning Protection Level (LPL), Rolling Sphere Method & Grounding Grid Resistance.
enum LightningProtectionClass {
  class1('LPL I - High Hazard Facility (Rolling Sphere R = 20m, 98% capture efficiency)', 20.0),
  class2('LPL II - Standard Commercial/Hospital (Rolling Sphere R = 30m, 95% capture efficiency)', 30.0),
  class3('LPL III - Residential/Shelter (Rolling Sphere R = 45m, 90% capture efficiency)', 45.0),
  class4('LPL IV - Non-Critical Structure (Rolling Sphere R = 60m, 80% capture efficiency)', 60.0);

  final String description;
  final double rollingSphereRadiusMeters;
  const LightningProtectionClass(this.description, this.rollingSphereRadiusMeters);
}

class LightningProtectionGroundingAudit {
  final String facilityName;
  final LightningProtectionClass protectionClass;
  final double airTerminalHeightAboveRoofMeters;
  final double measuredEarthElectrodeResistanceOhms; // IS standard <= 10.0 Ohms
  final bool hasType1SurgeProtectiveDeviceSpd;
  final bool hasEquipotentialBondingRing;

  const LightningProtectionGroundingAudit({
    required this.facilityName,
    required this.protectionClass,
    required this.airTerminalHeightAboveRoofMeters,
    required this.measuredEarthElectrodeResistanceOhms,
    required this.hasType1SurgeProtectiveDeviceSpd,
    required this.hasEquipotentialBondingRing,
  });

  /// Protected Zone Radius at ground level using Rolling Sphere method:
  /// Rp = sqrt(h * (2*R - h))
  double get protectedGroundRadiusMeters {
    final r = protectionClass.rollingSphereRadiusMeters;
    final h = airTerminalHeightAboveRoofMeters.clamp(0.0, r);
    return math.sqrt(h * ((2 * r) - h));
  }

  /// True if grounding resistance meets statutory IS/IEC 62305 standard (<= 10 Ohms)
  bool get isGroundingResistanceCompliant => measuredEarthElectrodeResistanceOhms <= 10.0;

  /// Full structural lightning & surge compliance audit status
  bool get isFullFacilityProtectionCertified {
    return isGroundingResistanceCompliant && hasType1SurgeProtectiveDeviceSpd && hasEquipotentialBondingRing;
  }
}
