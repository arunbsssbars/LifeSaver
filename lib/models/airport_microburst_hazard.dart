/// Model representing DGCA & IMD Aerodrome Low-Level Wind Shear Alert System (LLWAS)
/// and Runway Microburst Detection for Airport Disaster & Aviation Safety.
enum WindShearAlertLevel {
  nominal('Normal Wind Profile - Safe Operations', 0xFF10B981),
  windShearAdvisory('Wind Shear Advisory (15-29 kt airspeed variance)', 0xFFFBBF24),
  microburstWarning('CRITICAL MICROBURST WARNING (>= 30 kt airspeed loss) - IMMEDIATE GO-AROUND', 0xFFEF4444);

  final String description;
  final int colorValue;
  const WindShearAlertLevel(this.description, this.colorValue);
}

class AirportMicroburstHazard {
  final String airportIcaoCode;
  final String runwayDesignator;
  final double headwindToTailwindLossKnots;
  final double downdraftVelocityFeetPerMinute;
  final double fFactorHazardIndex; // FAA/DGCA F-Factor: F >= 0.13 is hazardous to aviation

  const AirportMicroburstHazard({
    required this.airportIcaoCode,
    required this.runwayDesignator,
    required this.headwindToTailwindLossKnots,
    required this.downdraftVelocityFeetPerMinute,
    required this.fFactorHazardIndex,
  });

  /// Evaluates aerodrome wind shear alert level
  WindShearAlertLevel get alertLevel {
    if (headwindToTailwindLossKnots >= 30.0 || fFactorHazardIndex >= 0.13) {
      return WindShearAlertLevel.microburstWarning;
    } else if (headwindToTailwindLossKnots >= 15.0 || fFactorHazardIndex >= 0.08) {
      return WindShearAlertLevel.windShearAdvisory;
    }
    return WindShearAlertLevel.nominal;
  }

  /// True if runway approach must be aborted immediately (Go-Around)
  bool get isGoAroundMandated => alertLevel == WindShearAlertLevel.microburstWarning;
}
