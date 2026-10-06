/// Model representing Marine Products Export Development Authority (MPEDA) & NFDB
/// Coastal Brackishwater Aquaculture Pond Storm Surge Dyke Overtopping & Salinity Shock Resilience.
class AquacultureStormSurgeAssessment {
  final String farmLocationTag;
  final double pondDykeCrestHeightMetersAboveMsl;
  final double forecastedStormSurgeWaterLevelMeters;
  final double baselineSalinityPsu; // e.g. 25-30 PSU for Tiger Shrimp (P. monodon)
  final double postRainfallSalinityPsu;
  final double pondDissolvedOxygenMgPerLitre; // Critical limit < 3.0 mg/L

  const AquacultureStormSurgeAssessment({
    required this.farmLocationTag,
    required this.pondDykeCrestHeightMetersAboveMsl,
    required this.forecastedStormSurgeWaterLevelMeters,
    required this.baselineSalinityPsu,
    required this.postRainfallSalinityPsu,
    required this.pondDissolvedOxygenMgPerLitre,
  });

  /// Pond Dyke Freeboard remaining (meters)
  double get remainingDykeFreeboardMeters {
    return pondDykeCrestHeightMetersAboveMsl - forecastedStormSurgeWaterLevelMeters;
  }

  /// True if storm surge overtopping will cause total crop washout
  bool get isPondDykeOvertoppingRisk => remainingDykeFreeboardMeters <= 0.0;

  /// Salinity drop magnitude in Practical Salinity Units (PSU)
  double get salinityDropDeltaPsu => (baselineSalinityPsu - postRainfallSalinityPsu).clamp(0.0, 40.0);

  /// True if rapid freshwater dilution causes osmotic shock & mass shrimp mortality (drop > 10 PSU in 24 hrs)
  bool get isOsmoticShockLethal => salinityDropDeltaPsu > 10.0;

  /// True if emergency paddlewheel aerators must run continuously to prevent anoxic suffocation (DO < 3.5 mg/L)
  bool get isEmergencyAerationMandated => pondDissolvedOxygenMgPerLitre < 3.5;
}
