/// Model representing Oil Industry Safety Directorate (OISD-STD-189) & DGH
/// Offshore Petroleum Drilling & Production Platform Emergency Shutdown (ESD) & Flare Blowdown.
class OffshoreEsdBlowdownTelemetry {
  final String platformId;
  final double operatingPressureBar;
  final double hydrocarbonGasInventoryTonnes;
  final bool isSubseaSafetyValveSssvClosed;
  final bool isEmergencyBlowdownValveEbdvOpened;
  final double blowdownElapsedTimeMinutes;
  final double currentPlatformPressureBar;

  const OffshoreEsdBlowdownTelemetry({
    required this.platformId,
    required this.operatingPressureBar,
    required this.hydrocarbonGasInventoryTonnes,
    required this.isSubseaSafetyValveSssvClosed,
    required this.isEmergencyBlowdownValveEbdvOpened,
    required this.blowdownElapsedTimeMinutes,
    required this.currentPlatformPressureBar,
  });

  /// Blowdown Pressure Reduction Percentage achieved
  double get pressureReductionPercent {
    if (operatingPressureBar <= 0.0) return 100.0;
    return (((operatingPressureBar - currentPlatformPressureBar) / operatingPressureBar) * 100.0).clamp(0.0, 100.0);
  }

  /// True if 50% depressurization is achieved within statutory 15 minutes (API 521 / OISD benchmark)
  bool get isDepressurizationBenchmarkMet {
    return pressureReductionPercent >= 50.0 && blowdownElapsedTimeMinutes <= 15.0;
  }

  /// True if ESD Level 1 platform total electrical isolation and muster alarm are active
  bool get isPlatformIsolationComplete => isSubseaSafetyValveSssvClosed && isEmergencyBlowdownValveEbdvOpened;

  /// True if flare stack acoustic/thermal radiation hazard requires immediate life-raft muster
  bool get isFlareOverloadThermalAlert => hydrocarbonGasInventoryTonnes > 25.0 && !isDepressurizationBenchmarkMet;
}
