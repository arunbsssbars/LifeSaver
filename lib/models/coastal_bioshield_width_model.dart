import 'dart:math' as math;

/// Coastal bioshield protection adequacy per INCOIS / MoEFCC CRZ standards.
enum CoastalBioshieldRating {
  supremeTsunamiBarrier,
  adequateStormSurgeProtection,
  marginalBufferZone,
  insufficientWaveDampingDeficit,
}

/// Scientific model for Coastal Mangrove Bioshield Width & Tsunami Wave Inundation Damping.
///
/// Implements INCOIS / MoEFCC Coastal Regulation Zone (CRZ) rules and coastal forest hydrodynamic attenuation.
/// Formulates:
/// - Wave height decay across width W: H_x = H_0 * exp(-k_d * W)
/// - Hydrodynamic damping coefficient: k_d = 0.5 * C_D * a_v * (H_0 / h)^(1/2)
/// - Inundation distance reduction factor: Delta_X_inundation % = (1 - exp(-0.012 * W)) * 100
/// - Critical minimum bioshield width standard: W_min = 100 meters for tropical cyclone surge, >= 200m for tsunami.
class CoastalBioshieldWidthModel {
  final String coastalStretchName;
  final double mangroveForestWidthMeters; // e.g. 50 - 500 meters
  final double incidentDeepWaterWaveHeightMeters; // e.g. 3.0 - 10.0 m
  final double meanWaterDepthMeters; // e.g. 1.5 - 4.0 m
  final double vegetationFrontalAreaPerUnitVolume; // a_v in m^2/m^3 (typically 0.15 - 0.40)
  final double mangroveRootDragCoefficient; // C_D (typically 1.2 - 1.8)
  final bool hasMultiSpeciesStratification; // Rhizophora + Avicennia + Sonneratia

  const CoastalBioshieldWidthModel({
    required this.coastalStretchName,
    required this.mangroveForestWidthMeters,
    required this.incidentDeepWaterWaveHeightMeters,
    required this.meanWaterDepthMeters,
    required this.vegetationFrontalAreaPerUnitVolume,
    this.mangroveRootDragCoefficient = 1.5,
    this.hasMultiSpeciesStratification = true,
  });

  /// Calculates the effective spatial damping factor k_d (1/m).
  double get hydrodynamicDampingCoefficient {
    if (meanWaterDepthMeters <= 0.0 || incidentDeepWaterWaveHeightMeters <= 0.0) return 0.01;
    final depthRatio = incidentDeepWaterWaveHeightMeters / meanWaterDepthMeters;
    final stratificationBonus = hasMultiSpeciesStratification ? 1.25 : 1.0;
    return 0.005 * mangroveRootDragCoefficient * vegetationFrontalAreaPerUnitVolume * math.sqrt(depthRatio) * stratificationBonus;
  }

  /// Calculates transmitted wave height (m) exiting the landward side of the bioshield.
  /// H_trans = H_0 * exp(-k_d * W)
  double get transmittedWaveHeightMeters {
    final kd = hydrodynamicDampingCoefficient;
    final hTrans = incidentDeepWaterWaveHeightMeters * math.exp(-kd * mangroveForestWidthMeters);
    return hTrans.clamp(0.05, incidentDeepWaterWaveHeightMeters);
  }

  /// Calculates total wave energy reduction percentage (%).
  /// Energy is proportional to H^2: E_red % = (1 - (H_trans / H_0)^2) * 100
  double get waveEnergyReductionPercent {
    if (incidentDeepWaterWaveHeightMeters <= 0.0) return 100.0;
    final ratio = transmittedWaveHeightMeters / incidentDeepWaterWaveHeightMeters;
    final energyRatio = ratio * ratio;
    return ((1.0 - energyRatio) * 100.0).clamp(0.0, 99.9);
  }

  /// Calculates inland overland flood inundation distance reduction (%).
  double get inlandInundationReductionPercent {
    final reduction = (1.0 - math.exp(-0.015 * mangroveForestWidthMeters)) * 100.0;
    return reduction.clamp(0.0, 99.0);
  }

  /// Evaluates bioshield rating against severe cyclonic surge and tsunami.
  CoastalBioshieldRating get bioshieldRating {
    if (mangroveForestWidthMeters >= 250.0 && waveEnergyReductionPercent >= 80.0) {
      return CoastalBioshieldRating.supremeTsunamiBarrier;
    }
    if (mangroveForestWidthMeters >= 120.0 && waveEnergyReductionPercent >= 60.0) {
      return CoastalBioshieldRating.adequateStormSurgeProtection;
    }
    if (mangroveForestWidthMeters >= 60.0) {
      return CoastalBioshieldRating.marginalBufferZone;
    }
    return CoastalBioshieldRating.insufficientWaveDampingDeficit;
  }

  /// Checks whether bioshield restoration or widening is critically mandated.
  bool get isMangroveAfforestationMandated {
    return bioshieldRating == CoastalBioshieldRating.insufficientWaveDampingDeficit ||
        bioshieldRating == CoastalBioshieldRating.marginalBufferZone;
  }
}
