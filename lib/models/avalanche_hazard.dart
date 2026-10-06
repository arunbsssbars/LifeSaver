/// Model representing Defence Geoinformatics Research Establishment (DGRE / DRDO)
/// Himalayan Avalanche Danger Scale (Stages 1 to 5) & High-Altitude Snowpack Stability.
enum AvalancheDangerLevel {
  stage1Low(
    stageNumber: 1,
    label: 'Stage 1 (Low Danger)',
    description: 'Snowpack generally well bonded and stable. Avalanches unlikely except on extreme slopes.',
    colorValue: 0xFF10B981,
  ),
  stage2Moderate(
    stageNumber: 2,
    label: 'Stage 2 (Moderate Danger)',
    description: 'Snowpack moderately stable. Natural avalanches unlikely; human triggering possible on steep test slopes.',
    colorValue: 0xFFFBBF24,
  ),
  stage3Considerable(
    stageNumber: 3,
    label: 'Stage 3 (Considerable Danger)',
    description: 'Snowpack moderately to poorly bonded on many steep slopes. Natural small/medium avalanches possible.',
    colorValue: 0xFFF97316,
  ),
  stage4High(
    stageNumber: 4,
    label: 'Stage 4 (High Danger)',
    description: 'Snowpack poorly bonded. Heavy natural avalanches likely on slopes > 30°. Movement strictly restricted.',
    colorValue: 0xFFEF4444,
  ),
  stage5VeryHigh(
    stageNumber: 5,
    label: 'Stage 5 (Very High / Catastrophic Avalanche Risk)',
    description: 'Snowpack universally unstable. Massive catastrophic avalanches expected reaching valley bottoms.',
    colorValue: 0xFF7F1D1D,
  );

  final int stageNumber;
  final String label;
  final String description;
  final int colorValue;

  const AvalancheDangerLevel({
    required this.stageNumber,
    required this.label,
    required this.description,
    required this.colorValue,
  });
}

class AvalancheRiskAssessment {
  final AvalancheDangerLevel dangerLevel;
  final double slopeAngleDegrees;
  final double freshSnowfallDepthCm24h;
  final double ambientTemperatureC;
  final double windSpeedKmh;
  final bool isSlabAvalancheProne;
  final List<String> highAltitudeSafetyDirectives;

  const AvalancheRiskAssessment({
    required this.dangerLevel,
    required this.slopeAngleDegrees,
    required this.freshSnowfallDepthCm24h,
    required this.ambientTemperatureC,
    required this.windSpeedKmh,
    required this.isSlabAvalancheProne,
    required this.highAltitudeSafetyDirectives,
  });

  /// Evaluates DGRE Avalanche Risk for Himalayan roads and high-altitude posts
  static AvalancheRiskAssessment evaluate({
    required double slopeDegrees,
    required double freshSnowCm24h,
    required double temperatureC,
    required double windKmh,
  }) {
    // 30° to 45° slopes represent prime shear failure trigger zones
    final isPrimeAngle = slopeDegrees >= 30.0 && slopeDegrees <= 45.0;
    final isSlabProne = isPrimeAngle && (freshSnowCm24h >= 25.0 || windKmh >= 35.0);

    AvalancheDangerLevel level = AvalancheDangerLevel.stage1Low;
    if (freshSnowCm24h >= 60.0 || (freshSnowCm24h >= 40.0 && windKmh >= 50.0)) {
      level = AvalancheDangerLevel.stage5VeryHigh;
    } else if (freshSnowCm24h >= 35.0 || (isSlabProne && temperatureC >= -2.0)) {
      level = AvalancheDangerLevel.stage4High;
    } else if (freshSnowCm24h >= 20.0 || isPrimeAngle) {
      level = AvalancheDangerLevel.stage3Considerable;
    } else if (freshSnowCm24h >= 10.0) {
      level = AvalancheDangerLevel.stage2Moderate;
    }

    final directives = <String>[];
    if (level.stageNumber >= 4) {
      directives.add('🚨 AVALANCHE RED ALERT: Total suspension of all civilian and convoy movement along mountain passes.');
      directives.add('Wear active 457 kHz Avalanche Transceivers (Beacons), carry probe poles, and snow shovels.');
      directives.add('Stay inside blast-reinforced mountain shelters; avoid open valley runout zones.');
    } else if (level.stageNumber == 3) {
      directives.add('Cross steep avalanche chutes one person at a time while others watch from safe rocky spurs.');
      directives.add('Avoid leeward slopes where wind-blown snow slabs build up over weak hoar frost layers.');
    } else {
      directives.add('Standard winter mountain safety precautions. Monitor DGRE bulletins.');
    }

    return AvalancheRiskAssessment(
      dangerLevel: level,
      slopeAngleDegrees: slopeDegrees,
      freshSnowfallDepthCm24h: freshSnowCm24h,
      ambientTemperatureC: temperatureC,
      windSpeedKmh: windKmh,
      isSlabAvalancheProne: isSlabProne,
      highAltitudeSafetyDirectives: directives,
    );
  }
}
