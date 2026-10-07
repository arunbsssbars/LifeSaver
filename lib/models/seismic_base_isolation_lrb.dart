import 'dart:math' as math;

/// Seismic base isolation performance per IS 1893 Part 1 / IS 13920.
enum BaseIsolationSafetyGrade {
  excellentBaseShearReduction,
  adequateIsolationDamping,
  excessiveMoatDisplacementRisk,
  isolatorInstabilityPDelta,
}

/// Engineering model for Seismic Base Isolation Lead-Rubber Bearings (LRB).
///
/// Implements BIS IS 1893 (Criteria for Earthquake Resistant Design of Structures) & international base isolation standards.
/// Formulates:
/// - Isolated fundamental time period: T_D = 2 * pi * sqrt(M / K_eff)
/// - Damping reduction factor: B_D = (beta_eff / 0.05)^0.3
/// - Maximum design displacement: D_M = (g * S_a * T_D^2) / (4 * pi^2 * B_D)
/// - Seismic base shear reduction ratio: V_b_isolated / V_b_fixed
class SeismicBaseIsolationLrb {
  final String buildingComplexName;
  final double totalSuperstructureMassTonnes;
  final int numberOfBaseIsolators;
  final double singleBearingEffectiveStiffnessKnPerM;
  final double effectiveEquivalentDampingRatio; // Typically 0.15 - 0.25 (15% - 25%)
  final double seismicZoneFactorZ; // Zone V = 0.36, Zone IV = 0.24, Zone III = 0.16
  final double providedMoatClearanceGapMm;
  final double fixedBaseSpectralAccelerationG;

  const SeismicBaseIsolationLrb({
    required this.buildingComplexName,
    required this.totalSuperstructureMassTonnes,
    required this.numberOfBaseIsolators,
    required this.singleBearingEffectiveStiffnessKnPerM,
    required this.effectiveEquivalentDampingRatio,
    required this.seismicZoneFactorZ,
    required this.providedMoatClearanceGapMm,
    required this.fixedBaseSpectralAccelerationG,
  });

  /// Total combined lateral stiffness across all isolators in kN/m.
  double get totalIsolationStiffnessKnPerM {
    return singleBearingEffectiveStiffnessKnPerM * numberOfBaseIsolators;
  }

  /// Calculates the isolated structure fundamental natural time period T_D (seconds).
  /// T_D = 2 * pi * sqrt(M_kg / K_total_N_per_m)
  double get isolatedFundamentalPeriodSeconds {
    final massKg = totalSuperstructureMassTonnes * 1000.0;
    final stiffnessNPerM = totalIsolationStiffnessKnPerM * 1000.0;
    if (stiffnessNPerM <= 0.0) return 0.0;
    return 2.0 * math.pi * math.sqrt(massKg / stiffnessNPerM);
  }

  /// Calculates damping reduction coefficient B_D.
  /// B_D = (beta_eff / 0.05)^0.30
  double get dampingReductionFactor {
    if (effectiveEquivalentDampingRatio <= 0.0) return 1.0;
    return math.pow(effectiveEquivalentDampingRatio / 0.05, 0.30).toDouble();
  }

  /// Calculates maximum design displacement at isolation interface D_M in millimeters.
  /// D_M = (g * S_a * T_D^2) / (4 * pi^2 * B_D)
  double get maximumDesignDisplacementMm {
    const double g = 9.81;
    final tD = isolatedFundamentalPeriodSeconds;
    final bD = dampingReductionFactor;
    if (tD <= 0.0 || bD <= 0.0) return 0.0;
    // S_a in isolated range approx 1.0 / T_D for medium soil per IS 1893
    final isolatedSa = (1.0 / tD) * seismicZoneFactorZ;
    final dmMeters = (g * isolatedSa * tD * tD) / (4.0 * math.pi * math.pi * bD);
    return (dmMeters * 1000.0).clamp(10.0, 1500.0);
  }

  /// Calculates percentage base shear reduction compared to fixed base building.
  double get baseShearReductionPercent {
    final tD = isolatedFundamentalPeriodSeconds;
    if (tD < 1.0) return 20.0;
    // Base shear roughly scales inversely with time period and damping
    final reduction = (1.0 - (1.0 / (tD * dampingReductionFactor))) * 100.0;
    return reduction.clamp(30.0, 85.0);
  }

  /// Evaluates isolation performance against moat clearance and structural stability.
  BaseIsolationSafetyGrade get safetyGrade {
    if (maximumDesignDisplacementMm > providedMoatClearanceGapMm) {
      return BaseIsolationSafetyGrade.excessiveMoatDisplacementRisk;
    }
    if (maximumDesignDisplacementMm > (0.80 * providedMoatClearanceGapMm)) {
      return BaseIsolationSafetyGrade.isolatorInstabilityPDelta;
    }
    if (baseShearReductionPercent >= 60.0 && isolatedFundamentalPeriodSeconds >= 2.0) {
      return BaseIsolationSafetyGrade.excellentBaseShearReduction;
    }
    return BaseIsolationSafetyGrade.adequateIsolationDamping;
  }

  /// Evaluates whether the isolation design provides safe clearance without moat pounding.
  bool get isPoundingSafeAndCompliant {
    return safetyGrade == BaseIsolationSafetyGrade.excellentBaseShearReduction ||
        safetyGrade == BaseIsolationSafetyGrade.adequateIsolationDamping;
  }
}
