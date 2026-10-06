import '../models/hazard_status.dart';
import '../models/lightning_alert.dart';

class LightningService {
  /// Evaluates convective lightning risk from real-time meteorological conditions
  static LightningRiskAssessment evaluateLightningRisk(WeatherStatus weather) {
    final double rainRate = weather.currentRainfall;
    final double prob = weather.precipitationProbability;
    final double wind = weather.windSpeed;

    // Severe thunderstorm & convective activity
    if (rainRate >= 25.0 && prob >= 80.0 && wind >= 40.0) {
      return const LightningRiskAssessment(
        threatLevel: LightningThreatLevel.extremeImminent,
        convectiveInstabilityScore: 92.0,
        safetyDirective:
            'IMMINENT LIGHTNING HAZARD: Move inside a concrete building or fully enclosed metal vehicle immediately. Stay away from doors, windows, and plumbing.',
        thirtyThirtyRuleStatus:
            '30-30 Rule Active: If thunder is heard, strike is within 10 km. Stay indoors for 30 min after last thunder.',
        isOutdoorUnsafe: true,
      );
    } else if (prob >= 70.0 || (rainRate >= 10.0 && wind >= 30.0)) {
      return const LightningRiskAssessment(
        threatLevel: LightningThreatLevel.highDanger,
        convectiveInstabilityScore: 74.0,
        safetyDirective:
            'HIGH LIGHTNING DANGER: Avoid open farm fields, water bodies, high ground ridges, and solitary trees (side-flash risk).',
        thirtyThirtyRuleStatus:
            'High convective cloud build-up. Prepare to seek shelter at first sound of thunder.',
        isOutdoorUnsafe: true,
      );
    } else if (prob >= 40.0) {
      return const LightningRiskAssessment(
        threatLevel: LightningThreatLevel.moderateWatch,
        convectiveInstabilityScore: 45.0,
        safetyDirective:
            'MODERATE THUNDERSTORM WATCH: Isolated lightning possible. Monitor sky for dark towering cumulonimbus clouds.',
        thirtyThirtyRuleStatus: 'Normal thunderstorm watch.',
        isOutdoorUnsafe: false,
      );
    }

    return const LightningRiskAssessment(
      threatLevel: LightningThreatLevel.low,
      convectiveInstabilityScore: 12.0,
      safetyDirective: 'Low atmospheric electrical activity. Safe for outdoor activities.',
      thirtyThirtyRuleStatus: 'No lightning activity detected.',
      isOutdoorUnsafe: false,
    );
  }
}
