/// Model representing Forest Survey of India (FSI) & National Action Plan on Forest Fires (NAPFF)
/// Van Agni 3.0 Real-time Forest Fire Danger Rating & Active Fire Point Telemetry.
enum ForestFireDangerIndex {
  low(
    rating: 'Low Fire Danger',
    description: 'High fuel moisture. Fire spread unlikely without continuous external flame source.',
    colorValue: 0xFF10B981,
  ),
  moderate(
    rating: 'Moderate Fire Danger',
    description: 'Dry surface leaf litter (*Pines/Sal*). Ground creeping fires possible.',
    colorValue: 0xFFFBBF24,
  ),
  veryHigh(
    rating: 'Very High Fire Danger',
    description: 'Dry deciduous conditions, high ambient temperature, gusty slope winds. Fast spreading surface fires.',
    colorValue: 0xFFF97316,
  ),
  extreme(
    rating: 'Extreme / Catastrophic Wildfire Alert',
    description: 'Severe canopy crowning, spot fires jumping fire lines, dense smoke plumes.',
    colorValue: 0xFFEF4444,
  );

  final String rating;
  final String description;
  final int colorValue;

  const ForestFireDangerIndex({
    required this.rating,
    required this.description,
    required this.colorValue,
  });
}

class ForestFireAssessment {
  final ForestFireDangerIndex dangerIndex;
  final double temperatureC;
  final double relativeHumidityPercent;
  final double windSpeedKmh;
  final int activeSnppViirsFirePointsCount;
  final double minimumFirelineClearanceMeters;
  final List<String> forestProtectionDirectives;

  const ForestFireAssessment({
    required this.dangerIndex,
    required this.temperatureC,
    required this.relativeHumidityPercent,
    required this.windSpeedKmh,
    required this.activeSnppViirsFirePointsCount,
    required this.minimumFirelineClearanceMeters,
    required this.forestProtectionDirectives,
  });

  /// Evaluates FSI Forest Fire Danger based on weather indicators and active satellite thermal anomalies
  static ForestFireAssessment evaluate({
    required double temperatureC,
    required double relativeHumidity,
    required double windSpeedKmh,
    required int activeFirePointsNear10Km,
  }) {
    ForestFireDangerIndex index = ForestFireDangerIndex.low;
    double clearanceMeters = 10.0;

    if (temperatureC >= 40.0 && relativeHumidity <= 20.0 && windSpeedKmh >= 30.0) {
      index = ForestFireDangerIndex.extreme;
      clearanceMeters = 50.0;
    } else if (temperatureC >= 35.0 && relativeHumidity <= 30.0) {
      index = ForestFireDangerIndex.veryHigh;
      clearanceMeters = 30.0;
    } else if (temperatureC >= 30.0 && relativeHumidity <= 45.0) {
      index = ForestFireDangerIndex.moderate;
      clearanceMeters = 15.0;
    }

    if (activeFirePointsNear10Km >= 5 && index != ForestFireDangerIndex.extreme) {
      index = ForestFireDangerIndex.veryHigh;
    }

    final directives = <String>[];
    if (index == ForestFireDangerIndex.extreme || index == ForestFireDangerIndex.veryHigh) {
      directives.add('🚨 FOREST FIRE ALERT: Active crown fire threat in pine/deciduous ridge belts.');
      directives.add('Create minimum $clearanceMeters-meter fuel-free firebreaks around forest edge settlements.');
      directives.add('Deploy Van Suraksha Samiti & forest beat guards with leaf blowers and water bowsers.');
      directives.add('Evacuate uphill settlements: Forest fires travel uphill rapidly due to preheated rising air.');
    } else {
      directives.add('Enforce strict ban on throwing glowing matchsticks, bidis, or lighting campfires in forest reserves.');
      directives.add('Maintain cleared control lines along agricultural boundaries.');
    }

    return ForestFireAssessment(
      dangerIndex: index,
      temperatureC: temperatureC,
      relativeHumidityPercent: relativeHumidity,
      windSpeedKmh: windSpeedKmh,
      activeSnppViirsFirePointsCount: activeFirePointsNear10Km,
      minimumFirelineClearanceMeters: clearanceMeters,
      forestProtectionDirectives: directives,
    );
  }
}
