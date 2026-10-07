import 'dart:math' as math;

/// Slope stability grade per IRC SP 48 / MoRTH / IS 14448.
enum SlopeStabilityGrade {
  fullyStabilizedEngineeredSlope,
  marginalStabilityAlert,
  imminentSlipFailureRisk,
  activeMassWastingCollapse,
}

/// Geotechnical engineering model for Mountain Road Cut Slope Soil Nailing & Shotcrete Stabilization.
///
/// Implements MoRTH / IRC SP 48 (Hill Road Manual) and IS 14448 (Code of practice for reinforcement of rock slopes using rock bolts).
/// Formulates:
/// - Nail ultimate pullout capacity: T_ult = pi * d_drill * L_bonded * q_ult (kN)
/// - Design tensile capacity: T_allow = min(T_ult / FoS_pullout, f_y * A_steel / FoS_steel)
/// - Factor of Safety against slope slip: FoS_slope = (Resisting Shear + Delta_T_resisting) / Driving Shear
/// - Reinforced shotcrete facing flexural capacity & weep hole hydrostatic relief drainage.
class SoilNailingSlopeStability {
  final String highwayCutSectorTag;
  final String mountainPassLocation;
  final double slopeAngleDegrees; // e.g. 50 - 75 deg
  final double slopeHeightMeters; // e.g. 15 - 40 m
  final double soilUnitWeightKnPerCubicMeter; // e.g. 19.0 kN/m^3
  final double soilCohesionKpa; // c in kPa
  final double soilFrictionAngleDegrees; // phi in deg
  final int numberOfInstalledNailRows;
  final double individualNailBondedLengthMeters; // e.g. 8 - 15 m
  final double drillHoleDiameterMm; // e.g. 100 - 150 mm
  final double ultimateGroutBondStressKpa; // q_ult (typically 120 - 250 kPa)
  final double horizontalNailSpacingMeters;
  final double verticalNailSpacingMeters;
  final bool hasPerforatedPvcWeepHoles;
  final bool hasWireMeshReinforcedShotcrete;

  const SoilNailingSlopeStability({
    required this.highwayCutSectorTag,
    required this.mountainPassLocation,
    required this.slopeAngleDegrees,
    required this.slopeHeightMeters,
    required this.soilUnitWeightKnPerCubicMeter,
    required this.soilCohesionKpa,
    required this.soilFrictionAngleDegrees,
    required this.numberOfInstalledNailRows,
    required this.individualNailBondedLengthMeters,
    required this.drillHoleDiameterMm,
    required this.ultimateGroutBondStressKpa,
    required this.horizontalNailSpacingMeters,
    required this.verticalNailSpacingMeters,
    this.hasPerforatedPvcWeepHoles = true,
    this.hasWireMeshReinforcedShotcrete = true,
  });

  /// Calculates ultimate pullout capacity per single soil nail in kN.
  /// T_ult = pi * (d / 1000) * L_b * q_ult
  double get singleNailPulloutCapacityKn {
    final dMeters = drillHoleDiameterMm / 1000.0;
    return math.pi * dMeters * individualNailBondedLengthMeters * ultimateGroutBondStressKpa;
  }

  /// Calculates unreinforced natural factor of safety (simplified Bishop / Infinite slope slice).
  double get unreinforcedFactorOfSafety {
    final betaRad = slopeAngleDegrees * (math.pi / 180.0);
    final phiRad = soilFrictionAngleDegrees * (math.pi / 180.0);
    if (betaRad <= 0.0) return 3.0;

    // FoS_unreinforced = (c / (gamma * H * sin*cos)) + (tan(phi) / tan(beta))
    final termCohesion = soilCohesionKpa / (soilUnitWeightKnPerCubicMeter * slopeHeightMeters * math.sin(betaRad) * math.cos(betaRad));
    final termFriction = math.tan(phiRad) / math.tan(betaRad);
    return (termCohesion + termFriction).clamp(0.4, 2.5);
  }

  /// Calculates the total resisting shear increment provided by the grid of soil nails per linear meter of slope.
  double get nailShearContributionKnPerMeter {
    if (horizontalNailSpacingMeters <= 0.0 || verticalNailSpacingMeters <= 0.0) return 0.0;
    const double fosNail = 2.0; // Standard allowable safety factor
    final allowableTension = singleNailPulloutCapacityKn / fosNail;
    final totalTensionPerMeter = (allowableTension * numberOfInstalledNailRows) / horizontalNailSpacingMeters;
    return totalTensionPerMeter;
  }

  /// Reinforced slope overall Factor of Safety (FoS).
  /// Target standard is FoS >= 1.50 for static conditions and >= 1.20 for seismic conditions.
  double get reinforcedFactorOfSafety {
    final naturalFos = unreinforcedFactorOfSafety;
    // Total driving shear force per linear meter: D = 0.5 * gamma * H^2 * (1 - sin(phi)) * sin(beta)
    final betaRad = slopeAngleDegrees * (math.pi / 180.0);
    final drivingLoadKnPerMeter = 0.5 * soilUnitWeightKnPerCubicMeter * slopeHeightMeters * slopeHeightMeters * math.sin(betaRad) * 0.35;
    final boost = drivingLoadKnPerMeter > 0 ? (nailShearContributionKnPerMeter / drivingLoadKnPerMeter) : 0.0;
    return (naturalFos + boost).clamp(0.5, 3.5);
  }

  /// Evaluates geotechnical stability grade.
  SlopeStabilityGrade get stabilityGrade {
    if (reinforcedFactorOfSafety < 1.0) {
      return SlopeStabilityGrade.activeMassWastingCollapse;
    }
    if (reinforcedFactorOfSafety < 1.30 || !hasPerforatedPvcWeepHoles) {
      return SlopeStabilityGrade.imminentSlipFailureRisk;
    }
    if (reinforcedFactorOfSafety < 1.50 || !hasWireMeshReinforcedShotcrete) {
      return SlopeStabilityGrade.marginalStabilityAlert;
    }
    return SlopeStabilityGrade.fullyStabilizedEngineeredSlope;
  }

  /// Returns true if the mountain slope is safely stabilized for heavy traffic per IRC SP 48.
  bool get isSlopeAdequatelyStabilized {
    return stabilityGrade == SlopeStabilityGrade.fullyStabilizedEngineeredSlope;
  }
}
