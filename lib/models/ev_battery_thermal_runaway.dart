/// Loop 156: Electric Vehicle (EV) Lithium-ion Battery Thermal Runaway & Deluge Model
/// Aligned with ARAI AIS 038 (Rev 2), NFPA 855 & Fire Services Emergency Response Guides.

class EvBatteryThermalRunaway {
  final double batteryTemperatureCelsius;
  final double temperatureRateOfRiseCPerMin;
  final bool isVentingWhiteToxicSmoke; // Releasing toxic HF, CO, H2 gases
  final bool isHighVoltageDisconnectPulled; // Manual Service Disconnect (MSD)
  final double continuousDelugeWaterAvailableLiters;

  const EvBatteryThermalRunaway({
    required this.batteryTemperatureCelsius,
    required this.temperatureRateOfRiseCPerMin,
    required this.isVentingWhiteToxicSmoke,
    required this.isHighVoltageDisconnectPulled,
    required this.continuousDelugeWaterAvailableLiters,
  });

  /// Thermal runaway trigger point (typically > 80°C with > 10°C/min rate of rise)
  bool get isThermalRunawayActive =>
      batteryTemperatureCelsius >= 80.0 && temperatureRateOfRiseCPerMin >= 10.0;

  /// Required water volume for complete cell core cooling (Typically 8,000 to 15,000 Liters)
  /// Attempting to use a standard small 2kg ABC dry powder extinguisher fails as heat remains inside pack.
  double get minimumRequiredDelugeWaterLiters => 10000.0;

  /// Deluge adequacy assessment
  bool get isDelugeWaterSupplyAdequate =>
      continuousDelugeWaterAvailableLiters >= minimumRequiredDelugeWaterLiters;

  /// Safety Standoff Perimeter (Meters)
  double get safetyStandoffPerimeterMeters => isVentingWhiteToxicSmoke ? 25.0 : 15.0;

  /// Tactical Firefighting & Public Action Protocol
  String get tacticalResponseProtocol {
    if (isThermalRunawayActive || isVentingWhiteToxicSmoke) {
      return 'CRITICAL EV THERMAL RUNAWAY: EVACUATE ${safetyStandoffPerimeterMeters.toStringAsFixed(0)}M UPWIND! White gas is flammable & toxic Hydrofluoric Acid (HF). Apply continuous high-volume water deluge (> 10,000L) directly to undercarriage battery enclosure for at least 60 mins to prevent cell propagation.';
    } else {
      return 'EARLY THERMAL WARNING: Pull High-Voltage Emergency Disconnect loop (MSD / Emergency Cut Loop) with insulated gloves, isolate vehicle outdoors in open area 15m away from structures.';
    }
  }

  /// Post-Fire Re-Ignition Warning
  String get postFireReignitionWarning =>
      'CRITICAL RE-IGNITION HAZARD: Stranded electrical energy in damaged Li-ion cells can re-ignite hours or days later. Quarantine vehicle in open yard for minimum 48 hours.';
}
