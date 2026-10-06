/// Model representing Research Designs and Standards Organisation (RDSO) Indian Railways
/// Continuous Welded Rail (CWR) Track Buckling, Hot Weather Patrolling & Thermal Stress Speed Restrictions.
enum RailThermalActionLevel {
  nominalSpeed('Normal Train Operations - Nominal Track Thermal Profile', 0xFF10B981),
  hotWeatherPatrol('Hot Weather Patrolling Active (Tp + 20°C to Tp + 25°C)', 0xFFFBBF24),
  emergencySpeedRestriction('CRITICAL BUCKLING HAZARD (> Tp + 25°C) - IMPOSE 30 KM/H SPEED RESTRICTION', 0xFFEF4444);

  final String description;
  final int colorValue;
  const RailThermalActionLevel(this.description, this.colorValue);
}

class RailTrackBucklingAssessment {
  final String railwayBlockSection;
  final double stressFreeTemperatureTpCelsius; // Typically 35°C to 40°C in Northern India
  final double currentRailTemperatureTmCelsius;
  final double trackCurvatureDegrees;
  final double ballastCushionDeficiencyMm; // Deficit in 300mm standard ballast cushion
  final bool hasMissingTrackFastenersOrElasticClips;

  const RailTrackBucklingAssessment({
    required this.railwayBlockSection,
    required this.stressFreeTemperatureTpCelsius,
    required this.currentRailTemperatureTmCelsius,
    required this.trackCurvatureDegrees,
    required this.ballastCushionDeficiencyMm,
    required this.hasMissingTrackFastenersOrElasticClips,
  });

  /// Longitudinal Thermal Stress Rise Delta T (°C)
  double get thermalRiseDeltaTCelsius => (currentRailTemperatureTmCelsius - stressFreeTemperatureTpCelsius).clamp(0.0, 50.0);

  /// Longitudinal Thermal Compressive Force in Tonnes (P = E * alpha * A * DeltaT)
  /// For 60 kg/m rail: P approx 1.7 Tonnes per °C per rail
  double get longitudinalThermalCompressiveForceTonnes => thermalRiseDeltaTCelsius * 1.70;

  /// Evaluates RDSO rail track thermal safety level
  RailThermalActionLevel get thermalSafetyLevel {
    if (thermalRiseDeltaTCelsius >= 25.0 || (thermalRiseDeltaTCelsius >= 20.0 && hasMissingTrackFastenersOrElasticClips)) {
      return RailThermalActionLevel.emergencySpeedRestriction;
    } else if (thermalRiseDeltaTCelsius >= 15.0) {
      return RailThermalActionLevel.hotWeatherPatrol;
    }
    return RailThermalActionLevel.nominalSpeed;
  }

  /// True if speed restriction caution order (30 km/h) is statutory mandated to prevent train derailment
  bool get isSpeedRestrictionCautionOrderMandated => thermalSafetyLevel == RailThermalActionLevel.emergencySpeedRestriction;
}
