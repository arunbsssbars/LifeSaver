/// Model representing Atomic Energy Regulatory Board (AERB) & BARC
/// Indian Environmental Radiation Monitoring Network (IERMON) Gamma Dose Rate Monitoring.
class IermonStationReading {
  final String stationId;
  final String stationLocation;
  final String affiliatedNppFacility; // Narora, Kalpakkam, Kudankulam, Tarapur, Kakrapar, Rawatbhata
  final double currentGammaDoseRateMicroSvPerHour;
  final double baselineAnnualBackgroundMicroSvPerHour;
  final DateTime lastTelemetrySync;

  const IermonStationReading({
    required this.stationId,
    required this.stationLocation,
    required this.affiliatedNppFacility,
    required this.currentGammaDoseRateMicroSvPerHour,
    required this.baselineAnnualBackgroundMicroSvPerHour,
    required this.lastTelemetrySync,
  });

  /// Dose rate status
  bool get isNormalBackground => currentGammaDoseRateMicroSvPerHour <= 0.30;
  bool get isInvestigativeAlert => currentGammaDoseRateMicroSvPerHour > 0.30 && currentGammaDoseRateMicroSvPerHour <= 10.0;
  bool get isEmergencyInterventionLevel => currentGammaDoseRateMicroSvPerHour > 10.0;

  static List<IermonStationReading> getMockNationalReadings() {
    return [
      IermonStationReading(
        stationId: 'IERMON-NR-01',
        stationLocation: 'Narora Atomic Power Station (NAPS) Outer Perimeter',
        affiliatedNppFacility: 'Narora NPP (UP)',
        currentGammaDoseRateMicroSvPerHour: 0.12,
        baselineAnnualBackgroundMicroSvPerHour: 0.11,
        lastTelemetrySync: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      IermonStationReading(
        stationId: 'IERMON-KL-02',
        stationLocation: 'Madras Atomic Power Station (MAPS) Coastal Mast',
        affiliatedNppFacility: 'Kalpakkam NPP (Tamil Nadu)',
        currentGammaDoseRateMicroSvPerHour: 0.14,
        baselineAnnualBackgroundMicroSvPerHour: 0.13,
        lastTelemetrySync: DateTime.now().subtract(const Duration(minutes: 8)),
      ),
    ];
  }
}
