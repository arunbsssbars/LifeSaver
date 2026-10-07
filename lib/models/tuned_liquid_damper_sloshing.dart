import 'dart:math' as math;

/// Tuned liquid damper damping performance per IS 16700:2017 / NBC 2016.
enum TldDampingPerformanceGrade {
  optimalResonantDamping,
  detunedSloshingFrequency,
  shallowWaveBreakingSaturation,
  ineffectiveDampingContribution,
}

/// Structural dynamics model for High-Rise Building Rooftop Tuned Liquid Dampers (TLD).
///
/// Implements IS 16700:2017 (Criteria for Structural Safety of Tall Concrete Buildings) and NBC 2016.
/// Formulates:
/// - Liquid sloshing fundamental frequency:
///   f_w = (1 / (2 * pi)) * sqrt((pi * g / L_tank) * tanh(pi * h_water / L_tank))
/// - Frequency tuning ratio: gamma_tune = f_w / f_building (Optimal ~ 0.98 - 1.02).
/// - Mass ratio: mu = M_water / M_modal (Typically 1.0% - 3.0% of generalized modal mass).
/// - Supplemental equivalent viscous damping addition: Delta_xi_TLD = 0.5 * sqrt(mu / (1 + mu)) * ResonantFactor.
class TunedLiquidDamperSloshing {
  final String tallBuildingName;
  final double buildingFundamentalFrequencyHz; // e.g. 0.20 - 0.50 Hz
  final double generalizedModalMassTonnes;
  final double tankLengthMeters; // L along direction of seismic vibration
  final double tankWidthMeters;
  final double quiescentWaterDepthMeters; // h_water
  final int numberOfIdenticalTldTanks;
  final bool hasInternalPerforatedSloshingBaffles;

  const TunedLiquidDamperSloshing({
    required this.tallBuildingName,
    required this.buildingFundamentalFrequencyHz,
    required this.generalizedModalMassTonnes,
    required this.tankLengthMeters,
    required this.tankWidthMeters,
    required this.quiescentWaterDepthMeters,
    required this.numberOfIdenticalTldTanks,
    this.hasInternalPerforatedSloshingBaffles = true,
  });

  /// Calculates the fundamental liquid sloshing frequency in Hz (Housner / Sun-Sakai formulation).
  /// f_w = (1 / 2pi) * sqrt((pi * g / L) * tanh(pi * h / L))
  double get sloshingNaturalFrequencyHz {
    const double g = 9.81;
    if (tankLengthMeters <= 0.0 || quiescentWaterDepthMeters <= 0.0) return 0.0;
    final term1 = (math.pi * g) / tankLengthMeters;
    final argTanh = (math.pi * quiescentWaterDepthMeters) / tankLengthMeters;
    // Approximating tanh(x) = (exp(2x) - 1) / (exp(2x) + 1)
    final exp2x = math.exp(math.min(20.0, 2.0 * argTanh));
    final tanhVal = (exp2x - 1.0) / (exp2x + 1.0);
    final omega = math.sqrt(term1 * tanhVal);
    return omega / (2.0 * math.pi);
  }

  /// Calculates frequency tuning ratio gamma = f_sloshing / f_building.
  double get frequencyTuningRatio {
    if (buildingFundamentalFrequencyHz <= 0.0) return 0.0;
    return sloshingNaturalFrequencyHz / buildingFundamentalFrequencyHz;
  }

  /// Total active water mass across all TLD tanks in tonnes.
  double get totalWaterMassTonnes {
    final singleVol = tankLengthMeters * tankWidthMeters * quiescentWaterDepthMeters;
    return singleVol * 1.0 * numberOfIdenticalTldTanks; // 1.0 tonne/m^3
  }

  /// Mass ratio mu = M_water / M_modal.
  double get tldMassRatioPercent {
    if (generalizedModalMassTonnes <= 0.0) return 0.0;
    return (totalWaterMassTonnes / generalizedModalMassTonnes) * 100.0;
  }

  /// Additional effective modal damping ratio added to the high-rise structure (in %).
  /// Typically adds 2.0% to 5.0% supplemental damping.
  double get supplementalModalDampingPercent {
    final mu = tldMassRatioPercent / 100.0;
    if (mu <= 0.0) return 0.0;
    final tuningFactor = math.exp(-15.0 * math.pow(frequencyTuningRatio - 1.0, 2));
    final baffleMultiplier = hasInternalPerforatedSloshingBaffles ? 1.40 : 1.0;
    final dampingRatio = 0.5 * math.sqrt(mu / (1.0 + mu)) * tuningFactor * baffleMultiplier;
    return (dampingRatio * 100.0).clamp(0.2, 7.5);
  }

  /// Evaluates TLD performance grade.
  TldDampingPerformanceGrade get performanceGrade {
    if (frequencyTuningRatio < 0.85 || frequencyTuningRatio > 1.15) {
      return TldDampingPerformanceGrade.detunedSloshingFrequency;
    }
    if (supplementalModalDampingPercent >= 2.50) {
      return TldDampingPerformanceGrade.optimalResonantDamping;
    }
    if (supplementalModalDampingPercent >= 1.00) {
      return TldDampingPerformanceGrade.shallowWaveBreakingSaturation;
    }
    return TldDampingPerformanceGrade.ineffectiveDampingContribution;
  }

  /// Returns true if the TLD effectively attenuates wind/earthquake dynamic sway accelerations.
  bool get isTldDampingEffectiveForTallBuilding {
    return performanceGrade == TldDampingPerformanceGrade.optimalResonantDamping;
  }
}
