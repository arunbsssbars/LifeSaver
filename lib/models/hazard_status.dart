enum ThreatLevel {
  safe,
  advisory,
  warning,
  criticalEmergency,
}

extension ThreatLevelExtension on ThreatLevel {
  String get title {
    switch (this) {
      case ThreatLevel.safe:
        return 'NORMAL / SAFE';
      case ThreatLevel.advisory:
        return 'FLOOD ADVISORY';
      case ThreatLevel.warning:
        return 'FLOOD WARNING';
      case ThreatLevel.criticalEmergency:
        return 'CRITICAL EMERGENCY';
    }
  }

  String get shortLabel {
    switch (this) {
      case ThreatLevel.safe:
        return 'SAFE';
      case ThreatLevel.advisory:
        return 'ADVISORY';
      case ThreatLevel.warning:
        return 'WARNING';
      case ThreatLevel.criticalEmergency:
        return 'EVACUATE';
    }
  }
}

class FloodStatus {
  final double currentDischarge; // m³/s
  final double meanDischarge; // m³/s
  final double maxForecastDischarge; // m³/s
  final double surgeRatio;
  final List<double> forecastDischarges;
  final List<String> forecastDates;

  FloodStatus({
    required this.currentDischarge,
    required this.meanDischarge,
    required this.maxForecastDischarge,
    required this.surgeRatio,
    required this.forecastDischarges,
    required this.forecastDates,
  });
}

class WeatherStatus {
  final double currentRainfall; // mm/h
  final double rainSumToday; // mm
  final double precipitationProbability; // %
  final double windSpeed; // km/h
  final double temperature; // °C

  WeatherStatus({
    required this.currentRainfall,
    required this.rainSumToday,
    required this.precipitationProbability,
    required this.windSpeed,
    required this.temperature,
  });
}

class HazardAssessment {
  final ThreatLevel threatLevel;
  final Duration estimatedResponseTime; // Time remaining before peak flood
  final String primaryRecommendation;
  final FloodStatus floodStatus;
  final WeatherStatus weatherStatus;
  final DateTime evaluatedAt;
  final String nearestBasinName;

  HazardAssessment({
    required this.threatLevel,
    required this.estimatedResponseTime,
    required this.primaryRecommendation,
    required this.floodStatus,
    required this.weatherStatus,
    required this.evaluatedAt,
    required this.nearestBasinName,
  });
}
