/// Model representing Supreme Grand Master Disaster Management Operating System (DMOS)
/// unifying all 60 multi-hazard disaster dimensions into an integrated state-wide command engine.
class SupremeDmosSummary {
  final String stateName;
  final DateTime syncTimestamp;
  final int totalMonitoredDomainsCount;
  final double stateCompositeResiliencePercent;
  final int activeEmergencyAlertsCount;
  final List<String> highAlertSectors;

  const SupremeDmosSummary({
    required this.stateName,
    required this.syncTimestamp,
    required this.totalMonitoredDomainsCount,
    required this.stateCompositeResiliencePercent,
    required this.activeEmergencyAlertsCount,
    required this.highAlertSectors,
  });

  /// True if state disaster infrastructure meets golden statutory readiness
  bool get isStateFullyPrepared => stateCompositeResiliencePercent >= 85.0 && activeEmergencyAlertsCount == 0;
}
