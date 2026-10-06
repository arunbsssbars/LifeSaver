/// Model representing Indian Dam Safety Act 2021 & National Dam Safety Authority (NDSA)
/// Emergency Action Plan (EAP) Inflow/Outflow Rule Curve Telemetry.
enum DamRiskCondition {
  conditionBlue(
    status: 'Condition BLUE (Normal Operations)',
    description: 'Reservoir level below Full Reservoir Level (FRL). Controlled seasonal generation.',
    colorValue: 0xFF10B981,
  ),
  conditionYellow(
    status: 'Condition YELLOW (Elevated Inflow Watch)',
    description: 'Rapid catchment inflows approaching Maximum Water Level (MWL). Spillway gates unlocked.',
    colorValue: 0xFFFBBF24,
  ),
  conditionOrange(
    status: 'Condition ORANGE (High Discharge Warning)',
    description: 'Substantial spillway discharge active. Downstream riparian flood sirens sounding.',
    colorValue: 0xFFF97316,
  ),
  conditionRed(
    status: 'Condition RED (Emergency Dam Safety Breach / Peak Gate Discharge)',
    description: 'Extreme peak spillway evacuation in progress! Inundation of downstream floodplains imminent.',
    colorValue: 0xFFEF4444,
  );

  final String status;
  final String description;
  final int colorValue;

  const DamRiskCondition({
    required this.status,
    required this.description,
    required this.colorValue,
  });
}

class IndianMajorDamProfile {
  final String damName;
  final String riverName;
  final String state;
  final double fullReservoirLevelMeters;
  final double currentWaterLevelMeters;
  final double currentInflowCusecs;
  final double currentOutflowCusecs;
  final int openSpillwayGateCount;
  final int totalSpillwayGateCount;

  const IndianMajorDamProfile({
    required this.damName,
    required this.riverName,
    required this.state,
    required this.fullReservoirLevelMeters,
    required this.currentWaterLevelMeters,
    required this.currentInflowCusecs,
    required this.currentOutflowCusecs,
    required this.openSpillwayGateCount,
    required this.totalSpillwayGateCount,
  });

  /// Evaluates Dam Safety Condition based on capacity percentage & outflow rate
  DamRiskCondition get safetyCondition {
    final fillRatio = currentWaterLevelMeters / fullReservoirLevelMeters;
    if (fillRatio >= 0.98 && currentOutflowCusecs >= 100000) {
      return DamRiskCondition.conditionRed;
    } else if (fillRatio >= 0.92 || currentOutflowCusecs >= 50000) {
      return DamRiskCondition.conditionOrange;
    } else if (fillRatio >= 0.85) {
      return DamRiskCondition.conditionYellow;
    }
    return DamRiskCondition.conditionBlue;
  }

  static const List<IndianMajorDamProfile> majorDams = [
    IndianMajorDamProfile(
      damName: 'Hathnikund Barrage (Upstream Yamuna)',
      riverName: 'Yamuna River',
      state: 'Haryana / UP Border',
      fullReservoirLevelMeters: 360.0,
      currentWaterLevelMeters: 295.0,
      currentInflowCusecs: 12000,
      currentOutflowCusecs: 10500,
      openSpillwayGateCount: 2,
      totalSpillwayGateCount: 18,
    ),
    IndianMajorDamProfile(
      damName: 'Tehri High Dam',
      riverName: 'Bhagirathi / Ganga',
      state: 'Uttarakhand',
      fullReservoirLevelMeters: 830.0,
      currentWaterLevelMeters: 818.5,
      currentInflowCusecs: 18500,
      currentOutflowCusecs: 14200,
      openSpillwayGateCount: 2,
      totalSpillwayGateCount: 6,
    ),
    IndianMajorDamProfile(
      damName: 'Idukki Arch Dam',
      riverName: 'Periyar River',
      state: 'Kerala',
      fullReservoirLevelMeters: 2403.0, // in feet
      currentWaterLevelMeters: 2382.0,
      currentInflowCusecs: 12000,
      currentOutflowCusecs: 8500,
      openSpillwayGateCount: 1,
      totalSpillwayGateCount: 5,
    ),
    IndianMajorDamProfile(
      damName: 'Bhakra Nangal Dam',
      riverName: 'Sutlej River',
      state: 'Himachal Pradesh / Punjab',
      fullReservoirLevelMeters: 1680.0, // in feet
      currentWaterLevelMeters: 1650.0,
      currentInflowCusecs: 24000,
      currentOutflowCusecs: 21000,
      openSpillwayGateCount: 3,
      totalSpillwayGateCount: 8,
    ),
  ];
}
