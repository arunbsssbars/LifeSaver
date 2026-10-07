import 'dart:math' as math;

/// Spontaneous combustion risk categories in coal mines per DGMS CMR 2017.
enum CoalSpontaneousCombustionRisk {
  negligible,
  moderateAlert,
  highVulnerability,
  activeSpontaneousFire,
}

/// Telemetry model for underground coal mine spontaneous combustion monitoring.
///
/// Implements DGMS (Directorate General of Mines Safety) standards and Coal Mines Regulations 2017.
/// Formulates:
/// - Crossing Point Temperature (CPT) margin: Delta T = T_seam - CPT.
/// - Graham's Ratio: R_G = (CO produced / Oxygen consumed) * 100
///   Where CO produced is in ppm, O2 consumed = (0.265 * N2 - O2) in %.
/// - Carbon Monoxide to Carbon Dioxide Ratio: (CO / CO2)
class CoalMineSpontaneousCombustionTelemetry {
  final String mineCollieryName;
  final String seamPanelTag;
  final double coalSeamTemperatureCelsius;
  final double crossingPointTemperatureCelsius; // Typical Indian coal: 120 - 150 C
  final double carbonMonoxidePpm;
  final double oxygenPercentage;
  final double nitrogenPercentage;
  final double carbonDioxidePercentage;
  final double ventilationAirVelocityMetersPerSec;
  final bool isNitrogenFlushingActive;

  const CoalMineSpontaneousCombustionTelemetry({
    required this.mineCollieryName,
    required this.seamPanelTag,
    required this.coalSeamTemperatureCelsius,
    required this.crossingPointTemperatureCelsius,
    required this.carbonMonoxidePpm,
    required this.oxygenPercentage,
    required this.nitrogenPercentage,
    required this.carbonDioxidePercentage,
    required this.ventilationAirVelocityMetersPerSec,
    this.isNitrogenFlushingActive = false,
  });

  /// Calculates oxygen deficiency (%) in return airway: (0.265 * N2) - O2
  double get oxygenDeficiencyPercent {
    final theoreticalO2 = 0.265 * nitrogenPercentage;
    final deficit = theoreticalO2 - oxygenPercentage;
    return math.max(0.001, deficit);
  }

  /// Calculates Graham's Ratio (R_G) = (CO ppm / (O2 deficiency % * 100)) * 100
  /// Simplified: CO_ppm / (theoreticalO2 - actualO2) / 100
  /// In mining practice: Graham's Ratio < 0.4 (Normal), 0.5-1.0 (Heating), > 2.0 (Active Fire).
  double get grahamsRatio {
    if (oxygenDeficiencyPercent <= 0.001) return 0.0;
    return (carbonMonoxidePpm / (oxygenDeficiencyPercent * 100.0)).clamp(0.0, 10.0);
  }

  /// Evaluates risk classification based on Graham's ratio, CO levels, and CPT proximity.
  CoalSpontaneousCombustionRisk get combustionRisk {
    if (grahamsRatio >= 2.0 || carbonMonoxidePpm >= 50.0 || coalSeamTemperatureCelsius >= crossingPointTemperatureCelsius) {
      return CoalSpontaneousCombustionRisk.activeSpontaneousFire;
    }
    if (grahamsRatio >= 0.8 || carbonMonoxidePpm >= 20.0 || (crossingPointTemperatureCelsius - coalSeamTemperatureCelsius) <= 15.0) {
      return CoalSpontaneousCombustionRisk.highVulnerability;
    }
    if (grahamsRatio >= 0.4 || carbonMonoxidePpm >= 10.0) {
      return CoalSpontaneousCombustionRisk.moderateAlert;
    }
    return CoalSpontaneousCombustionRisk.negligible;
  }

  /// Mandates inertization if heating or active fire is detected and nitrogen flushing is inactive.
  bool get isEmergencyNitrogenInertizationMandated {
    return (combustionRisk == CoalSpontaneousCombustionRisk.highVulnerability ||
            combustionRisk == CoalSpontaneousCombustionRisk.activeSpontaneousFire) &&
        !isNitrogenFlushingActive;
  }

  /// Mandates immediate evacuation of mine panel under active heating/fire conditions.
  bool get isImmediatePanelEvacuationRequired {
    return combustionRisk == CoalSpontaneousCombustionRisk.activeSpontaneousFire;
  }
}
