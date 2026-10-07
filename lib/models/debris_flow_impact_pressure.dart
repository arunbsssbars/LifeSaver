import 'dart:math' as math;

/// Debris flow hazard severity per GSI / MoRTH IRC SP 106 mountain bridge standards.
enum DebrisFlowImpactSeverity {
  lowErosiveFlow,
  moderateHydrodynamicThrust,
  severeStructuralDamageRisk,
  catastrophicPierShearOverturning,
}

/// Engineering model for Mountain Debris Flow Hydrodynamic & Boulder Impact Pressure.
///
/// Implements GSI (Geological Survey of India) and MoRTH / IRC SP 106 (Engineering Guidelines for Mountain Road Bridges).
/// Formulates:
/// - Hydrodynamic continuous impact pressure: P_dyn = alpha * rho_debris * v_flow^2
///   Where alpha = dynamic coefficient (2.0 - 3.0), rho_debris = slurry bulk density (1800 - 2200 kg/m^3).
/// - Point boulder impact force: F_boulder = (m_boulder * v_boulder) / Delta_t_impact
///   Where Delta_t_impact ~ 0.05 - 0.10 seconds for elastoplastic concrete collision.
/// - Pier overturning moment: M_overturning = (P_dyn * A_submerged * (h_flow / 2)) + (F_boulder * h_boulder_contact)
class DebrisFlowImpactPressure {
  final String mountainBridgeOrRetainingWallTag;
  final String riverGorgeLocation;
  final double debrisFlowVelocityMetersPerSec; // e.g. 4.0 - 12.0 m/s
  final double debrisSlurryDensityKgPerCubicMeter; // e.g. 1950 kg/m^3
  final double flowDepthMeters; // e.g. 2.5 - 6.0 m
  final double structureFrontalWidthMeters; // e.g. 2.0 - 5.0 m
  final double largestIndividualBoulderMassKg; // e.g. 3500 kg
  final double concretePierDesignCapacityKiloNewtons;
  final bool hasUpstreamDebrisDeflectorNose;

  const DebrisFlowImpactPressure({
    required this.mountainBridgeOrRetainingWallTag,
    required this.riverGorgeLocation,
    required this.debrisFlowVelocityMetersPerSec,
    required this.debrisSlurryDensityKgPerCubicMeter,
    required this.flowDepthMeters,
    required this.structureFrontalWidthMeters,
    required this.largestIndividualBoulderMassKg,
    required this.concretePierDesignCapacityKiloNewtons,
    this.hasUpstreamDebrisDeflectorNose = true,
  });

  /// Dynamic coefficient alpha (2.0 with deflector nose, 3.0 for blunt flat surface).
  double get dynamicPressureCoefficient {
    return hasUpstreamDebrisDeflectorNose ? 2.0 : 3.0;
  }

  /// Calculates hydrodynamic continuous pressure in kPa (kN/m^2).
  /// P_dyn = (alpha * rho * v^2) / 1000
  double get hydrodynamicImpactPressureKpa {
    final pressurePa = dynamicPressureCoefficient * debrisSlurryDensityKgPerCubicMeter * math.pow(debrisFlowVelocityMetersPerSec, 2);
    return pressurePa / 1000.0;
  }

  /// Calculates total continuous thrust force on structure in kN.
  /// F_thrust = P_dyn * (W * H)
  double get totalContinuousThrustForceKiloNewtons {
    final contactArea = structureFrontalWidthMeters * flowDepthMeters;
    return hydrodynamicImpactPressureKpa * contactArea;
  }

  /// Calculates point boulder instantaneous impact force in kN (assuming collision contact dt = 0.08 s).
  double get boulderPointImpactForceKiloNewtons {
    if (largestIndividualBoulderMassKg <= 0.0 || debrisFlowVelocityMetersPerSec <= 0.0) return 0.0;
    const double dtCollisionSec = 0.08;
    final forceNewtons = (largestIndividualBoulderMassKg * debrisFlowVelocityMetersPerSec) / dtCollisionSec;
    return forceNewtons / 1000.0;
  }

  /// Total combined peak impact load (Continuous Thrust + Boulder Collision) in kN.
  double get peakCombinedImpactLoadKiloNewtons {
    return totalContinuousThrustForceKiloNewtons + boulderPointImpactForceKiloNewtons;
  }

  /// Structural safety factor against pier shear/overturning = Capacity / Peak Load.
  double get structuralFactorOfSafety {
    if (peakCombinedImpactLoadKiloNewtons <= 0.0) return 99.0;
    return concretePierDesignCapacityKiloNewtons / peakCombinedImpactLoadKiloNewtons;
  }

  /// Evaluates severity classification of the debris impact.
  DebrisFlowImpactSeverity get impactSeverity {
    if (structuralFactorOfSafety < 1.0) {
      return DebrisFlowImpactSeverity.catastrophicPierShearOverturning;
    }
    if (structuralFactorOfSafety < 1.5 || hydrodynamicImpactPressureKpa >= 150.0) {
      return DebrisFlowImpactSeverity.severeStructuralDamageRisk;
    }
    if (hydrodynamicImpactPressureKpa >= 50.0) {
      return DebrisFlowImpactSeverity.moderateHydrodynamicThrust;
    }
    return DebrisFlowImpactSeverity.lowErosiveFlow;
  }

  /// Mandates immediate highway/bridge closure if structural safety factor < 1.5.
  bool get isImmediateBridgeClosureMandated {
    return structuralFactorOfSafety < 1.5;
  }
}
