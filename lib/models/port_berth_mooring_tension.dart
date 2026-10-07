import 'dart:math' as math;

/// Mooring safety rating per DG Shipping / PIANC harbour mooring guidelines.
enum MooringSafetyRating {
  secureBerthing,
  highTensionAlert,
  imminentSnapbackRisk,
  emergencyCastOffMandated,
}

/// Dynamic hydrodynamic and wind aerodynamic load model for Vessel Mooring Lines during Cyclones.
///
/// Implements Directorate General of Shipping, Ministry of Ports, Shipping and Waterways, and PIANC guidelines.
/// Formulates:
/// - Wind transverse lateral force: F_w = 0.5 * C_w * rho_air * A_wind * V_wind^2
/// - Current lateral force: F_c = 0.5 * C_c * rho_water * A_current * V_current^2
/// - Line tension load sharing: T_line = (F_total_lateral) / (N_lines * cos(theta_lead))
/// - Safety factor against Minimum Breaking Load (MBL): FoS = MBL / T_line (Standard requires FoS >= 2.0).
class PortBerthMooringTension {
  final String portBerthTag;
  final String vesselIdentificationName;
  final double vesselDeadweightTonnes;
  final double windExposedTransverseAreaSqMeters;
  final double submergedLateralCurrentAreaSqMeters;
  final double cycloneGustSpeedKnots;
  final double tidalCurrentVelocityKnots;
  final int numberOfActiveMooringLines;
  final double singleLineMinimumBreakingLoadTonnes; // MBL in tonnes
  final double averageLineLeadAngleDegrees; // Angle to perpendicular (typically 20 - 45 deg)
  final bool hasTugAssistanceOnStandby;

  const PortBerthMooringTension({
    required this.portBerthTag,
    required this.vesselIdentificationName,
    required this.vesselDeadweightTonnes,
    required this.windExposedTransverseAreaSqMeters,
    required this.submergedLateralCurrentAreaSqMeters,
    required this.cycloneGustSpeedKnots,
    required this.tidalCurrentVelocityKnots,
    required this.numberOfActiveMooringLines,
    required this.singleLineMinimumBreakingLoadTonnes,
    this.averageLineLeadAngleDegrees = 30.0,
    this.hasTugAssistanceOnStandby = true,
  });

  /// Calculates lateral aerodynamic wind force in metric tonnes.
  /// F_w = 0.5 * C_w * rho_air * A * V^2
  double get windLateralForceTonnes {
    const double cw = 1.30;
    const double rhoAir = 1.225; // kg/m^3
    final speedMs = cycloneGustSpeedKnots * 0.514444;
    final forceNewtons = 0.5 * cw * rhoAir * windExposedTransverseAreaSqMeters * math.pow(speedMs, 2);
    return forceNewtons / 9806.65; // Convert N to metric tonnes-force
  }

  /// Calculates lateral hydrodynamic current drag force in metric tonnes.
  double get currentLateralForceTonnes {
    const double cc = 1.05;
    const double rhoWater = 1025.0; // kg/m^3 sea water
    final speedMs = tidalCurrentVelocityKnots * 0.514444;
    final forceNewtons = 0.5 * cc * rhoWater * submergedLateralCurrentAreaSqMeters * math.pow(speedMs, 2);
    return forceNewtons / 9806.65;
  }

  /// Total combined lateral environmental force in tonnes.
  double get totalLateralForceTonnes {
    return windLateralForceTonnes + currentLateralForceTonnes;
  }

  /// Calculates tension per individual mooring line in tonnes.
  double get peakLineTensionTonnes {
    if (numberOfActiveMooringLines <= 0) return totalLateralForceTonnes;
    final rad = averageLineLeadAngleDegrees * (math.pi / 180.0);
    final cosTheta = math.max(0.2, math.cos(rad));
    return totalLateralForceTonnes / (numberOfActiveMooringLines * cosTheta);
  }

  /// Factor of Safety (FoS) relative to Minimum Breaking Load.
  double get factorOfSafetyMbl {
    if (peakLineTensionTonnes <= 0.0) return 99.0;
    return singleLineMinimumBreakingLoadTonnes / peakLineTensionTonnes;
  }

  /// Percentage of MBL utilized on the most loaded lines.
  double get mblUtilizationPercent {
    if (singleLineMinimumBreakingLoadTonnes <= 0.0) return 100.0;
    return (peakLineTensionTonnes / singleLineMinimumBreakingLoadTonnes) * 100.0;
  }

  /// Evaluates mooring safety rating during cyclonic surge.
  MooringSafetyRating get safetyRating {
    if (factorOfSafetyMbl < 1.10 || mblUtilizationPercent >= 90.0) {
      return MooringSafetyRating.emergencyCastOffMandated;
    }
    if (factorOfSafetyMbl < 1.50 || mblUtilizationPercent >= 65.0) {
      return MooringSafetyRating.imminentSnapbackRisk;
    }
    if (factorOfSafetyMbl < 2.0) {
      return MooringSafetyRating.highTensionAlert;
    }
    return MooringSafetyRating.secureBerthing;
  }

  /// Returns true if vessel must be disconnected and steered to outer deep-water anchorage.
  bool get isEmergencyAnchorOffshoreRequired {
    return safetyRating == MooringSafetyRating.emergencyCastOffMandated;
  }
}
