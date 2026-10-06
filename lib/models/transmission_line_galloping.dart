import 'dart:math' as math;

/// Model representing Central Electricity Authority (CEA) Technical Standards & IS 802
/// High-Voltage (400kV / 765kV) Transmission Tower Wind Loading & Conductor Galloping Instability.
class TransmissionLineGallopingAssessment {
  final String transmissionCorridorTag;
  final double lineOperatingVoltageKv; // e.g. 400 kV, 765 kV
  final double spanLengthMeters; // e.g. 350 to 450 meters
  final double crosswindSpeedKmh;
  final double conductorIceAccretionMm;
  final double phaseToPhaseSpacingMeters;
  final bool hasStockbridgeDampersAndSpacers;

  const TransmissionLineGallopingAssessment({
    required this.transmissionCorridorTag,
    required this.lineOperatingVoltageKv,
    required this.spanLengthMeters,
    required this.crosswindSpeedKmh,
    required this.conductorIceAccretionMm,
    required this.phaseToPhaseSpacingMeters,
    required this.hasStockbridgeDampersAndSpacers,
  });

  /// Peak Galloping Amplitude in meters (approx A = 0.015 * Span * (Wind/40)^0.5 when iced)
  double get estimatedPeakGallopingAmplitudeMeters {
    if (spanLengthMeters <= 0.0 || crosswindSpeedKmh < 20.0) return 0.0;
    final icingFactor = conductorIceAccretionMm > 0 ? 1.5 : 0.6;
    final windRatio = math.sqrt(crosswindSpeedKmh / 40.0);
    return (0.015 * spanLengthMeters * windRatio * icingFactor).clamp(0.0, 15.0);
  }

  /// Minimum Electrical Clearance required to prevent 400kV/765kV flashover (IS 802: ~1 meter per 100kV)
  double get minimumElectricalClearanceMeters => (lineOperatingVoltageKv / 100.0).clamp(2.5, 9.0);

  /// Dynamic Phase-to-Phase Clearance remaining during peak conductor oscillations (meters)
  double get dynamicClearanceRemainingMeters {
    return (phaseToPhaseSpacingMeters - estimatedPeakGallopingAmplitudeMeters).clamp(0.0, 30.0);
  }

  /// True if transmission line is at imminent risk of phase-to-phase flashover / grid trip
  bool get isConductorClashingFlashoverRisk {
    return dynamicClearanceRemainingMeters < minimumElectricalClearanceMeters;
  }
}
