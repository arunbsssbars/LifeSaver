import 'dart:math' as math;

/// Liquefaction uplift safety condition per IS 1893 / CPHEEO water & gas pipeline code.
enum PipelineBuoyancySafetyClass {
  fullyAnchoredSafe,
  marginalHoldDownFactor,
  imminentFloatationRuptureRisk,
  pipeBucklingDisplacement,
}

/// Geotechnical engineering model for Buried Pipelines in Liquefiable Soil & Buoyancy Uplift Anchorage.
///
/// Implements BIS IS 1893 (Seismic Design) and CPHEEO / PNGRB Lifeline Engineering Standards.
/// Formulates:
/// - Liquefied soil buoyant uplift force per meter: F_b = (pi * D^2 / 4) * gamma_liquefied (kN/m)
///   Where gamma_liquefied = saturated unit weight of soil slurry (18.5 - 20.0 kN/m^3).
/// - Submerged pipe and contents downward dead weight: W_down = W_pipe + W_content (kN/m)
/// - Net upward flotation force: F_net_up = max(0, F_b - W_down)
/// - Required concrete saddle anchor block mass & anchor strap spacing:
///   Anchor Factor of Safety FoS = (W_anchor_submerged + Soil Cover Shear) / F_net_up >= 1.50
class PipelineBuoyancyAnchorage {
  final String pipelineSectorTag;
  final String riverBankOrCoastalLocation;
  final double pipeOuterDiameterMeters; // e.g. 0.80 - 1.60 m
  final double pipeWallThicknessMm;
  final double liquefiedSoilSaturatedUnitWeightKnPerM3; // e.g. 19.5 kN/m^3
  final double emptyPipeSelfWeightKnPerMeter;
  final double pipeContentUnitWeightKnPerMeter; // 0 for gas pipe, 9.81 * Area for water
  final double concreteAnchorBlockMassTonnes; // Mass of individual saddle block
  final double concreteAnchorSpacingMeters; // Distance between anchor saddles
  final double soilBurialCoverDepthMeters;
  final bool isInHighSeismicLiquefactionZone;

  const PipelineBuoyancyAnchorage({
    required this.pipelineSectorTag,
    required this.riverBankOrCoastalLocation,
    required this.pipeOuterDiameterMeters,
    required this.pipeWallThicknessMm,
    required this.liquefiedSoilSaturatedUnitWeightKnPerM3,
    required this.emptyPipeSelfWeightKnPerMeter,
    required this.pipeContentUnitWeightKnPerMeter,
    required this.concreteAnchorBlockMassTonnes,
    required this.concreteAnchorSpacingMeters,
    required this.soilBurialCoverDepthMeters,
    this.isInHighSeismicLiquefactionZone = true,
  });

  /// Calculates gross buoyant upward force per linear meter of pipeline in kN/m.
  /// F_b = (pi * D^2 / 4) * gamma_liq
  double get buoyantUpwardForceKnPerMeter {
    final area = math.pi * math.pow(pipeOuterDiameterMeters / 2.0, 2);
    return area * liquefiedSoilSaturatedUnitWeightKnPerM3;
  }

  /// Total downward dead load of empty pipe and fluid contents in kN/m.
  double get downwardDeadLoadKnPerMeter {
    return emptyPipeSelfWeightKnPerMeter + pipeContentUnitWeightKnPerMeter;
  }

  /// Net upward flotation force per linear meter (kN/m) requiring mechanical anchorage.
  double get netUpwardFlotationForceKnPerMeter {
    final net = buoyantUpwardForceKnPerMeter - downwardDeadLoadKnPerMeter;
    return math.max(0.0, net);
  }

  /// Calculates submerged effective downward anchor weight per linear meter in kN/m.
  /// Concrete in soil/water loses ~40% effective weight: gamma_eff ~ (24 - 10) = 14 kN/m^3.
  double get submergedAnchorWeightKnPerMeter {
    if (concreteAnchorSpacingMeters <= 0.0) return 0.0;
    const double concreteSubmergedWeightFactor = 0.583; // (2400 - 1000) / 2400
    final blockWeightKn = concreteAnchorBlockMassTonnes * 9.81 * concreteSubmergedWeightFactor;
    return blockWeightKn / concreteAnchorSpacingMeters;
  }

  /// Calculates soil cover wedge resistance in kN/m during upward displacement.
  double get soilCoverWedgeResistanceKnPerMeter {
    if (soilBurialCoverDepthMeters <= 0.0) return 0.0;
    // Wedge resistance in liquefaction is reduced, conservatively ~ 15% of static overburden
    return 0.15 * (liquefiedSoilSaturatedUnitWeightKnPerM3 * soilBurialCoverDepthMeters * pipeOuterDiameterMeters);
  }

  /// Factor of Safety against pipeline floatation rupture during soil liquefaction.
  /// FoS = (Submerged Anchor + Soil Wedge Resistance) / Net Upward Force
  double get floatationFactorOfSafety {
    final netUp = netUpwardFlotationForceKnPerMeter;
    if (netUp <= 0.0) return 10.0; // Naturally negatively buoyant
    final totalRestoringForce = submergedAnchorWeightKnPerMeter + soilCoverWedgeResistanceKnPerMeter;
    return (totalRestoringForce / netUp).clamp(0.1, 10.0);
  }

  /// Evaluates pipeline buoyancy safety classification.
  PipelineBuoyancySafetyClass get safetyClass {
    if (floatationFactorOfSafety < 1.0) {
      return PipelineBuoyancySafetyClass.imminentFloatationRuptureRisk;
    }
    if (floatationFactorOfSafety < 1.30) {
      return PipelineBuoyancySafetyClass.marginalHoldDownFactor;
    }
    if (floatationFactorOfSafety >= 1.50) {
      return PipelineBuoyancySafetyClass.fullyAnchoredSafe;
    }
    return PipelineBuoyancySafetyClass.marginalHoldDownFactor;
  }

  /// Returns true if the buried pipeline is safely anchored against seismic soil liquefaction uplift.
  bool get isPipelineSafelyAnchored {
    return safetyClass == PipelineBuoyancySafetyClass.fullyAnchoredSafe;
  }
}
