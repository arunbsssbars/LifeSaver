/// Model representing Central Electricity Authority (CEA) Regulations & NIFPS
/// 400kV/765kV Grid Substation Power Transformer Nitrogen Injection Fire Protection.
class TransformerFireProtectionTelemetry {
  final String substationId;
  final String transformerRatingMva;
  final double oilVolumeKilolitres;
  final bool isBuchholzRelayTripped;
  final bool isDifferentialRelayTripped;
  final bool isPrvPressureReliefTripped;
  final double oilTemperatureCelsius;

  const TransformerFireProtectionTelemetry({
    required this.substationId,
    required this.transformerRatingMva,
    required this.oilVolumeKilolitres,
    required this.isBuchholzRelayTripped,
    required this.isDifferentialRelayTripped,
    required this.isPrvPressureReliefTripped,
    required this.oilTemperatureCelsius,
  });

  /// True if 2 out of 3 statutory fire detection triggers are active (CEA mandate for NIFPS actuation)
  bool get isNifpsActuationConditionSatisfied {
    int triggers = 0;
    if (isBuchholzRelayTripped) triggers++;
    if (isDifferentialRelayTripped) triggers++;
    if (isPrvPressureReliefTripped) triggers++;
    return triggers >= 2 || oilTemperatureCelsius >= 110.0;
  }

  /// Required Nitrogen Gas purging cylinder capacity in m³ (approx 0.05 m³ N2 per kL of transformer oil)
  double get requiredNitrogenGasVolumeCubicMeters => oilVolumeKilolitres * 0.05;

  /// Transformer oil soak pit containment capacity required in kL (must hold 100% of oil volume per CEA)
  double get mandatoryOilSoakPitCapacityKilolitres => oilVolumeKilolitres * 1.10;
}
