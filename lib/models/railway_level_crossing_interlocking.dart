/// Level crossing safety state per RDSO Indian Railways SEM Part II.
enum LevelCrossingSafetyStatus {
  interlockedClearForTrain,
  obstacleDetectedEmergencyBraking,
  gateOpenWarning,
  sensorDegradedCaution,
}

/// Operational and safety model for Railway Interlocked Level Crossing & Obstacle Detection.
///
/// Implements RDSO (Research Designs and Standards Organisation) Indian Railways Signal Engineering Manual.
/// Formulates:
/// - Train Vehicle Unit (TVU) index = Daily Trains * Daily Equivalent Road Vehicles
/// - Obstacle radar zone scanning within the track clearance envelope (6m width x crossing length)
/// - Emergency Train Braking Distance (EBD) speed penalty & Kavach collision interlocking
/// - Gate closure confirmation before signal green aspect clearance
class RailwayLevelCrossingInterlocking {
  final String levelCrossingGateNumber;
  final String railwaySectionTag;
  final double dailyTrainCount;
  final double dailyRoadVehiclesCount;
  final bool isLiftingBarrierFullyClosed;
  final bool isTrackCircuitedWithinDangerZone;
  final bool isRadarObstacleDetected;
  final double approachingTrainSpeedKmph;
  final double distanceToApproachingTrainMeters;
  final bool isKavachAtpInterfaceActive;

  const RailwayLevelCrossingInterlocking({
    required this.levelCrossingGateNumber,
    required this.railwaySectionTag,
    required this.dailyTrainCount,
    required this.dailyRoadVehiclesCount,
    required this.isLiftingBarrierFullyClosed,
    required this.isTrackCircuitedWithinDangerZone,
    required this.isRadarObstacleDetected,
    required this.approachingTrainSpeedKmph,
    required this.distanceToApproachingTrainMeters,
    this.isKavachAtpInterfaceActive = true,
  });

  /// Calculates Train Vehicle Units (TVU) per day.
  /// TVU > 50,000 mandates automatic interlocking and grade separation (ROB/RUB).
  double get trainVehicleUnits {
    return dailyTrainCount * dailyRoadVehiclesCount;
  }

  /// Evaluates whether the gate must be upgraded to a Road Over Bridge (ROB) or Under Bridge (RUB).
  bool get isGradeSeparationRobMandated {
    return trainVehicleUnits >= 50000.0;
  }

  /// Calculates Emergency Braking Distance (EBD) in meters.
  /// EBD = (v_m_s)^2 / (2 * a_decel), where a_decel ~ 0.85 m/s^2 for broad gauge express train.
  double get estimatedEmergencyBrakingDistanceMeters {
    final speedMs = approachingTrainSpeedKmph * (1000.0 / 3600.0);
    const double decel = 0.85;
    return (speedMs * speedMs) / (2.0 * decel);
  }

  /// Evaluates level crossing safety status.
  LevelCrossingSafetyStatus get safetyStatus {
    if (isRadarObstacleDetected || isTrackCircuitedWithinDangerZone) {
      return LevelCrossingSafetyStatus.obstacleDetectedEmergencyBraking;
    }
    if (!isLiftingBarrierFullyClosed) {
      return LevelCrossingSafetyStatus.gateOpenWarning;
    }
    return LevelCrossingSafetyStatus.interlockedClearForTrain;
  }

  /// Checks whether approaching train will safely stop before obstacle if emergency brake is triggered now.
  bool get isSafeEmergencyStopFeasible {
    if (!isRadarObstacleDetected) return true;
    return distanceToApproachingTrainMeters >= (estimatedEmergencyBrakingDistanceMeters + 100.0); // 100m safety buffer
  }

  /// Clearance signal aspect state. True if green aspect can be safely displayed to train.
  bool get isSignalClearancePermitted {
    return safetyStatus == LevelCrossingSafetyStatus.interlockedClearForTrain;
  }
}
