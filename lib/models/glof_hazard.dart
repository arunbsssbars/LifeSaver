/// Model representing Glacial Lake Outburst Flood (GLOF) & High Altitude Flash Flood Monitoring
/// conforming to NDMA Guidelines on Management of Glacial Lake Outburst Floods (GLOFs) and ISRO NRSC Atlas.
enum GlofThreatLevel {
  normal(
    code: 'GLOF ALL CLEAR',
    description: 'Glacial moraine dams stable; standard lake expansion monitoring active.',
    colorValue: 0xFF10B981,
  ),
  advisory(
    code: 'GLOF ELEVATED WATCH',
    description: 'High melt rates / heavy convective precipitation recorded near proglacial lake.',
    colorValue: 0xFFFBBF24,
  ),
  warning(
    code: 'GLOF HIGH ALERT',
    description: 'Moraine instability, avalanche impact into lake, or rapid water level surge observed.',
    colorValue: 0xFFF97316,
  ),
  emergencyBreach(
    code: 'GLOF DAM BREACH / IMMINENT SURGE',
    description: 'Glacial lake breach in progress! Catastrophic high-velocity debris flood traveling downstream.',
    colorValue: 0xFFEF4444,
  );

  final String code;
  final String description;
  final int colorValue;

  const GlofThreatLevel({
    required this.code,
    required this.description,
    required this.colorValue,
  });
}

class GlacialLakeProfile {
  final String lakeName;
  final String riverBasin;
  final String stateOrTerritory;
  final double elevationMeters;
  final double lakeAreaHectares;
  final double estimatedVolumeMillionCubicMeters;
  final double downstreamDistanceToInhabitedKm;
  final double estimatedWaveTravelMinutes;

  const GlacialLakeProfile({
    required this.lakeName,
    required this.riverBasin,
    required this.stateOrTerritory,
    required this.elevationMeters,
    required this.lakeAreaHectares,
    required this.estimatedVolumeMillionCubicMeters,
    required this.downstreamDistanceToInhabitedKm,
    required this.estimatedWaveTravelMinutes,
  });

  static const List<GlacialLakeProfile> highRiskHimalayanLakes = [
    GlacialLakeProfile(
      lakeName: 'South Lhonak Glacial Lake',
      riverBasin: 'Teesta River Basin',
      stateOrTerritory: 'Sikkim',
      elevationMeters: 5200,
      lakeAreaHectares: 168.0,
      estimatedVolumeMillionCubicMeters: 65.0,
      downstreamDistanceToInhabitedKm: 42.0,
      estimatedWaveTravelMinutes: 35.0,
    ),
    GlacialLakeProfile(
      lakeName: 'Chorabari Glacial Lake (Kedarnath Valley)',
      riverBasin: 'Mandakini River Basin',
      stateOrTerritory: 'Uttarakhand',
      elevationMeters: 3960,
      lakeAreaHectares: 14.5,
      estimatedVolumeMillionCubicMeters: 8.5,
      downstreamDistanceToInhabitedKm: 4.5,
      estimatedWaveTravelMinutes: 12.0,
    ),
    GlacialLakeProfile(
      lakeName: 'Rishiganga - Nanda Devi High Altitude Basin',
      riverBasin: 'Alaknanda / Rishiganga Basin',
      stateOrTerritory: 'Uttarakhand',
      elevationMeters: 4600,
      lakeAreaHectares: 28.0,
      estimatedVolumeMillionCubicMeters: 18.0,
      downstreamDistanceToInhabitedKm: 16.0,
      estimatedWaveTravelMinutes: 20.0,
    ),
    GlacialLakeProfile(
      lakeName: 'Gepang Gath Glacial Lake',
      riverBasin: 'Chandra / Chenab Basin',
      stateOrTerritory: 'Himachal Pradesh',
      elevationMeters: 4060,
      lakeAreaHectares: 75.0,
      estimatedVolumeMillionCubicMeters: 32.0,
      downstreamDistanceToInhabitedKm: 28.0,
      estimatedWaveTravelMinutes: 25.0,
    ),
    GlacialLakeProfile(
      lakeName: 'Imja Tsho Proglacial Lake',
      riverBasin: 'Koshi River Basin',
      stateOrTerritory: 'Nepal / Cross-border',
      elevationMeters: 5010,
      lakeAreaHectares: 128.0,
      estimatedVolumeMillionCubicMeters: 75.0,
      downstreamDistanceToInhabitedKm: 38.0,
      estimatedWaveTravelMinutes: 30.0,
    ),
  ];
}

class GlofRiskAssessment {
  final GlofThreatLevel threatLevel;
  final GlacialLakeProfile? closestLake;
  final double distanceToLakeKm;
  final double estimatedBreachWaveArrivalMinutes;
  final List<String> earlyWarningProtocols;

  const GlofRiskAssessment({
    required this.threatLevel,
    this.closestLake,
    required this.distanceToLakeKm,
    required this.estimatedBreachWaveArrivalMinutes,
    required this.earlyWarningProtocols,
  });

  /// Evaluates GLOF risk for given coordinates
  static GlofRiskAssessment evaluateLocation({
    required double latitude,
    required double longitude,
    required String regionName,
    required double rainfallSumToday,
    required double currentDischargeSurgeRatio,
  }) {
    // Find closest monitored glacial lake
    GlacialLakeProfile? nearest;
    double minDistance = 9999.0;

    for (final lake in GlacialLakeProfile.highRiskHimalayanLakes) {
      if (regionName.toLowerCase().contains(lake.stateOrTerritory.toLowerCase()) ||
          regionName.toLowerCase().contains(lake.riverBasin.toLowerCase().split(' ').first)) {
        nearest = lake;
        minDistance = lake.downstreamDistanceToInhabitedKm;
        break;
      }
    }

    if (nearest == null) {
      // In non-glacial plains
      return const GlofRiskAssessment(
        threatLevel: GlofThreatLevel.normal,
        distanceToLakeKm: 999.0,
        estimatedBreachWaveArrivalMinutes: 999.0,
        earlyWarningProtocols: [
          'No vulnerable proglacial lakes in this geographical quadrant.',
          'Downstream flood telemetry monitored via standard CWC gauge network.',
        ],
      );
    }

    GlofThreatLevel level = GlofThreatLevel.normal;
    if (rainfallSumToday > 150.0 && currentDischargeSurgeRatio > 3.0) {
      level = GlofThreatLevel.emergencyBreach;
    } else if (rainfallSumToday > 80.0 || currentDischargeSurgeRatio > 2.0) {
      level = GlofThreatLevel.warning;
    } else if (rainfallSumToday > 40.0) {
      level = GlofThreatLevel.advisory;
    }

    final protocols = <String>[];
    if (level == GlofThreatLevel.emergencyBreach) {
      protocols.add('🚨 GLOF DAM BREACH ALERT: High velocity boulder-laden flood wave advancing.');
      protocols.add('EVACUATE IMMEDIATELY to valley slopes at least 50 meters above river bed.');
      protocols.add('Do not attempt to cross bridges, culverts, or valley floor access roads.');
    } else if (level == GlofThreatLevel.warning) {
      protocols.add('GLOF HIGH ALERT: Automated water-level sensor trigger recorded upstream.');
      protocols.add('Aapda Mitra and SDRF mountain rescue teams placed on standby.');
      protocols.add('Move all livestock and critical assets away from riparian corridors.');
    } else {
      protocols.add('Regular satellite and automated water-level sensor telemetry nominal.');
      protocols.add('Maintain awareness of local siren and horn stations along river channel.');
    }

    return GlofRiskAssessment(
      threatLevel: level,
      closestLake: nearest,
      distanceToLakeKm: minDistance,
      estimatedBreachWaveArrivalMinutes: nearest.estimatedWaveTravelMinutes,
      earlyWarningProtocols: protocols,
    );
  }
}
