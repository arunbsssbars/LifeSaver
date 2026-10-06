/// Model representing ISHRAE & ASHRAE 62.1
/// Disaster Relief Shelter Indoor Air Quality (IAQ) & Airborne Pathogen Ventilation Safety.
enum AirQualityVentilationGrade {
  excellent('Optimal Fresh Air Exchange (CO2 < 800 ppm, ACH >= 6)', 0xFF10B981),
  moderateCaution('Adequate Ventilation (CO2 800-1200 ppm) - Monitor Occupancy', 0xFFFBBF24),
  hazardousAirborne('Stagnant Air & High Infection Risk (CO2 > 1500 ppm, ACH < 3) - ACTIVATE PURIFIERS', 0xFFEF4444);

  final String guidance;
  final int colorValue;
  const AirQualityVentilationGrade(this.guidance, this.colorValue);
}

class ShelterIndoorAirQualityTelemetry {
  final String shelterHallId;
  final int currentOccupantCount;
  final double roomVolumeCubicMeters;
  final double measuredCo2ConcentrationPpm;
  final double mechanicalFreshAirSupplyLps; // Litres per second
  final double hepaAirPurifierCadrCfm; // Clean Air Delivery Rate in CFM

  const ShelterIndoorAirQualityTelemetry({
    required this.shelterHallId,
    required this.currentOccupantCount,
    required this.roomVolumeCubicMeters,
    required this.measuredCo2ConcentrationPpm,
    required this.mechanicalFreshAirSupplyLps,
    required this.hepaAirPurifierCadrCfm,
  });

  /// Outdoor Fresh Air Flow Rate per Occupant (Litres/second/person)
  double get freshAirPerPersonLps {
    if (currentOccupantCount <= 0) return 100.0;
    return mechanicalFreshAirSupplyLps / currentOccupantCount;
  }

  /// Air Changes per Hour (ACH = (Q_m3h + Q_hepa_m3h) / Room Volume)
  double get effectiveAirChangesPerHour {
    if (roomVolumeCubicMeters <= 0.0) return 0.0;
    final freshAirM3PerHour = (mechanicalFreshAirSupplyLps * 3.6);
    final hepaM3PerHour = (hepaAirPurifierCadrCfm * 1.699);
    return ((freshAirM3PerHour + hepaM3PerHour) / roomVolumeCubicMeters).clamp(0.0, 30.0);
  }

  /// Evaluates IAQ safety grade
  AirQualityVentilationGrade get ventilationGrade {
    if (measuredCo2ConcentrationPpm >= 1500.0 || effectiveAirChangesPerHour < 3.0) {
      return AirQualityVentilationGrade.hazardousAirborne;
    } else if (measuredCo2ConcentrationPpm >= 800.0 || effectiveAirChangesPerHour < 6.0) {
      return AirQualityVentilationGrade.moderateCaution;
    }
    return AirQualityVentilationGrade.excellent;
  }

  /// True if cross-ventilation exhaust fans and UVGI/HEPA units must be immediately energized
  bool get isEmergencyVentilationBoostMandated => ventilationGrade == AirQualityVentilationGrade.hazardousAirborne;
}
