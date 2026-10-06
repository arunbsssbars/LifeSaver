/// Model representing Indian Railways Bridge & Flood Protection Code
/// Pier Scour & Water Level Stoppage Thresholds.
enum RailBridgeDangerStage {
  allClear('Green - Safe Train Operations at Booked Speed', 0xFF10B981),
  cautionSpeedRestriction('Yellow - Caution Order (Speed Reduced to 20 km/h)', 0xFFFBBF24),
  trainMovementSuspended('Red - Danger Mark Breached! Train Operations Halted', 0xFFEF4444);

  final String action;
  final int colorValue;
  const RailBridgeDangerStage(this.action, this.colorValue);
}

class RailwayBridgeFloodTelemetry {
  final String bridgeNumber;
  final String railwayDivision;
  final String riverName;
  final double dangerLevelMarkMeters;
  final double currentWaterLevelMeters;
  final double pierFoundationScourDepthMeters;
  final double maxPermissibleScourDepthMeters;

  const RailwayBridgeFloodTelemetry({
    required this.bridgeNumber,
    required this.railwayDivision,
    required this.riverName,
    required this.dangerLevelMarkMeters,
    required this.currentWaterLevelMeters,
    required this.pierFoundationScourDepthMeters,
    required this.maxPermissibleScourDepthMeters,
  });

  /// Evaluates statutory railway train movement stage
  RailBridgeDangerStage get operationalStage {
    final isWaterAtDanger = currentWaterLevelMeters >= dangerLevelMarkMeters;
    final isScourCritical = pierFoundationScourDepthMeters >= maxPermissibleScourDepthMeters;

    if (isWaterAtDanger || isScourCritical) {
      return RailBridgeDangerStage.trainMovementSuspended;
    } else if (currentWaterLevelMeters >= (dangerLevelMarkMeters - 0.50) ||
        pierFoundationScourDepthMeters >= (maxPermissibleScourDepthMeters * 0.80)) {
      return RailBridgeDangerStage.cautionSpeedRestriction;
    }
    return RailBridgeDangerStage.allClear;
  }
}
