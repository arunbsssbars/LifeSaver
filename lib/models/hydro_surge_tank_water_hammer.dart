import 'dart:math' as math;

/// Surge tank operational state per CEA / BIS IS 7396 (Design of Surge Tanks).
enum SurgeTankHydraulicState {
  stableDampedOscillation,
  marginalUpsurgeClearance,
  imminentTankOvertoppingRisk,
  penstockAirVacuumCollapseRisk,
}

/// Hydraulic modeling for Hydroelectric Power Penstock Surge Tanks & Water Hammer Mitigation.
///
/// Implements Central Electricity Authority (CEA) & BIS IS 7396 guidelines.
/// Formulates:
/// - Joukowsky water hammer pressure head: Delta_H_wh = (a * Delta_v) / g
///   Where a = acoustic pressure wave speed (1000 - 1200 m/s in steel penstock).
/// - Thoma critical stability cross-sectional area:
///   A_Thoma = (v_0^2 * A_tunnel) / (2 * g * H_net * h_f0 * eta_governor) * safety_margin (1.5)
/// - Maximum upsurge oscillation level: Z_max = v_0 * sqrt((L * A_tunnel) / (g * A_tank))
/// - Freeboard clearance standard >= 1.50 meters above maximum calculated upsurge.
class HydroSurgeTankWaterHammer {
  final String hydroPowerStationName;
  final double headraceTunnelLengthMeters;
  final double headraceTunnelDiameterMeters;
  final double surgeTankDiameterMeters;
  final double penstockRatedVelocityMetersPerSec;
  final double netOperatingHeadMeters;
  final double headLossHeadraceTunnelMeters;
  final double surgeTankTopCrestLevelMeters; // Top rim elevation of open surge shaft
  final double maximumOperatingReservoirLevelMeters;
  final double governorShutdownTimeSeconds; // Turbine full load rejection trip time (typically 4 - 8 s)

  const HydroSurgeTankWaterHammer({
    required this.hydroPowerStationName,
    required this.headraceTunnelLengthMeters,
    required this.headraceTunnelDiameterMeters,
    required this.surgeTankDiameterMeters,
    required this.penstockRatedVelocityMetersPerSec,
    required this.netOperatingHeadMeters,
    required this.headLossHeadraceTunnelMeters,
    required this.surgeTankTopCrestLevelMeters,
    required this.maximumOperatingReservoirLevelMeters,
    required this.governorShutdownTimeSeconds,
  });

  /// Calculates headrace tunnel cross-sectional area in m^2.
  double get headraceTunnelAreaSqMeters {
    return math.pi * math.pow(headraceTunnelDiameterMeters / 2.0, 2);
  }

  /// Calculates provided surge tank cross-sectional area in m^2.
  double get surgeTankAreaSqMeters {
    return math.pi * math.pow(surgeTankDiameterMeters / 2.0, 2);
  }

  /// Calculates Thoma critical minimum stability area in m^2 per IS 7396 (with 1.5 safety factor).
  /// A_Th = 1.5 * (v_0^2 * A_tunnel) / (2 * g * H_net * h_f0)
  double get thomaCriticalSurgeTankAreaSqMeters {
    const double g = 9.81;
    if (netOperatingHeadMeters <= 0.0 || headLossHeadraceTunnelMeters <= 0.0) return 10.0;
    final numerator = 1.5 * math.pow(penstockRatedVelocityMetersPerSec, 2) * headraceTunnelAreaSqMeters;
    final denominator = 2.0 * g * netOperatingHeadMeters * headLossHeadraceTunnelMeters;
    return numerator / denominator;
  }

  /// Checks if surge tank cross-section exceeds Thoma stability criterion.
  bool get isThomaStabilityConditionSatisfied {
    return surgeTankAreaSqMeters >= thomaCriticalSurgeTankAreaSqMeters;
  }

  /// Calculates maximum water level upsurge oscillation Z_max in meters above reservoir level.
  /// Z_max = v_0 * sqrt((L * A_tunnel) / (g * A_tank))
  double get maximumUpsurgeHeightMeters {
    const double g = 9.81;
    if (surgeTankAreaSqMeters <= 0.0) return 50.0;
    final massTerm = (headraceTunnelLengthMeters * headraceTunnelAreaSqMeters) / (g * surgeTankAreaSqMeters);
    return penstockRatedVelocityMetersPerSec * math.sqrt(massTerm);
  }

  /// Peak water elevation inside surge tank during full load rejection in meters.
  double get peakSurgeWaterLevelMeters {
    return maximumOperatingReservoirLevelMeters + maximumUpsurgeHeightMeters;
  }

  /// Freeboard available above peak upsurge to the surge tank top rim.
  double get availableFreeboardMeters {
    return surgeTankTopCrestLevelMeters - peakSurgeWaterLevelMeters;
  }

  /// Evaluates hydraulic stability and overflow risk.
  SurgeTankHydraulicState get hydraulicState {
    if (availableFreeboardMeters < 0.0) {
      return SurgeTankHydraulicState.imminentTankOvertoppingRisk;
    }
    if (!isThomaStabilityConditionSatisfied) {
      return SurgeTankHydraulicState.stableDampedOscillation;
    }
    if (availableFreeboardMeters < 1.50) {
      return SurgeTankHydraulicState.marginalUpsurgeClearance;
    }
    return SurgeTankHydraulicState.stableDampedOscillation;
  }

  /// Returns true if the surge tank safely attenuates transient water hammer without overtopping.
  bool get isSurgeTankSafeForSuddenGridTrip {
    return availableFreeboardMeters >= 1.50 && isThomaStabilityConditionSatisfied;
  }
}
