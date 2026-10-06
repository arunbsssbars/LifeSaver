/// Model representing MoRTH & Indian Roads Congress (IRC SP:90)
/// Mountain Ghat Highway Runaway Truck Escape Ramp & Aggregate Arrester Bed Sizing.
class RunawayEscapeRampDesign {
  final String highwayGhatPassName;
  final double entryRunawaySpeedKmh; // e.g., 100 to 140 km/h for brake-failed heavy truck
  final double escapeRampGradePercent; // e.g. +15% positive upgrade
  final double aggregateRollingResistanceCoeff; // R = 0.25 for uncompacted pea gravel (AASHTO/IRC)
  final double availableArresterBedLengthMeters;

  const RunawayEscapeRampDesign({
    required this.highwayGhatPassName,
    required this.entryRunawaySpeedKmh,
    required this.escapeRampGradePercent,
    required this.aggregateRollingResistanceCoeff,
    required this.availableArresterBedLengthMeters,
  });

  /// Entry velocity converted to m/s
  double get entrySpeedMs => (entryRunawaySpeedKmh * 1000.0) / 3600.0;

  /// Required Arrester Bed Stopping Distance in meters
  /// L = V^2 / (2 * g * (R +/- G))
  double get requiredStoppingLengthMeters {
    const g = 9.81;
    final gradeDecimal = escapeRampGradePercent / 100.0;
    final totalDeceleration = aggregateRollingResistanceCoeff + gradeDecimal;
    if (totalDeceleration <= 0.0) return 999.0;
    final length = (entrySpeedMs * entrySpeedMs) / (2 * g * totalDeceleration);
    return length.clamp(10.0, 500.0);
  }

  /// True if ramp length is sufficient to arrest a runaway truck with 20% safety margin
  bool get isEscapeRampAdequate => availableArresterBedLengthMeters >= (requiredStoppingLengthMeters * 1.2);

  /// True if water-filled crash attenuators / energy dissipation barrels are mandatory at ramp terminus
  bool get isTerminalCrashAttenuatorMandated => availableArresterBedLengthMeters < (requiredStoppingLengthMeters * 1.3);
}
