import 'dart:math' as math;

/// Atmospheric stability class per Pasquill-Gifford Gaussian dispersion models.
enum AtmosphericStabilityClass {
  classAExtremelyUnstable,
  classBModeratelyUnstable,
  classCSlightlyUnstable,
  classDNeutral,
  classESlightlyStableNight,
  classFModeratelyStableNight,
}

/// Chemical hazardous gas classification.
enum ToxicGasType {
  chlorine,
  ammonia,
  sulfurDioxide,
  phosgene,
  hydrogenSulfide,
}

/// Dispersion modeling and Protective Action Distance for Toxic Inhalation Hazard (TIH) releases.
///
/// Implements ERPG (Emergency Response Planning Guidelines), ALOHA, and NDMA Chemical Disaster Guidelines.
/// Formulates:
/// - Initial Isolation Distance (IID): Mandatory 360-degree evacuation radius around source.
/// - Downwind Protective Action Distance (PAD):
///   PAD_km = C_gas * (ReleaseRate_kg_s / WindSpeed_m_s)^p * StabilityFactor
/// - Day vs Night atmospheric boundary layer dispersion corrections.
class TihProtectiveActionDistance {
  final String chemicalReleaseSiteTag;
  final ToxicGasType gasType;
  final double releaseRateKgPerSec;
  final double ambientWindSpeedMetersPerSec;
  final AtmosphericStabilityClass stabilityClass;
  final bool isNightTimeRelease;
  final double providedPublicEvacuationRadiusKm;

  const TihProtectiveActionDistance({
    required this.chemicalReleaseSiteTag,
    required this.gasType,
    required this.releaseRateKgPerSec,
    required this.ambientWindSpeedMetersPerSec,
    required this.stabilityClass,
    required this.isNightTimeRelease,
    required this.providedPublicEvacuationRadiusKm,
  });

  /// Base ERPG-2 toxicity coefficient C_gas for downwind dispersion.
  double get gasToxicityConstant {
    switch (gasType) {
      case ToxicGasType.phosgene:
        return 4.2; // Extremely lethal (ERPG-2 = 0.2 ppm)
      case ToxicGasType.chlorine:
        return 2.8; // High toxicity (ERPG-2 = 3.0 ppm)
      case ToxicGasType.hydrogenSulfide:
        return 2.1; // (ERPG-2 = 30.0 ppm)
      case ToxicGasType.sulfurDioxide:
        return 1.6; // (ERPG-2 = 3.0 ppm)
      case ToxicGasType.ammonia:
        return 1.1; // Lower density gas (ERPG-2 = 150.0 ppm)
    }
  }

  /// Calculates mandatory 360-degree Initial Isolation Distance (IID) in meters.
  double get initialIsolationDistanceMeters {
    if (releaseRateKgPerSec <= 0.0) return 30.0;
    // Base IID ~ 100m for small spills, up to 1000m for catastrophic tank rupture
    final iid = 150.0 * math.pow(releaseRateKgPerSec, 0.40);
    return iid.clamp(50.0, 1500.0);
  }

  /// Atmospheric dispersion multiplier based on Pasquill-Gifford stability class.
  double get stabilityDispersionFactor {
    switch (stabilityClass) {
      case AtmosphericStabilityClass.classAExtremelyUnstable:
        return 0.60; // Rapid vertical dispersion
      case AtmosphericStabilityClass.classBModeratelyUnstable:
        return 0.80;
      case AtmosphericStabilityClass.classCSlightlyUnstable:
        return 1.00;
      case AtmosphericStabilityClass.classDNeutral:
        return 1.35;
      case AtmosphericStabilityClass.classESlightlyStableNight:
        return 1.80; // Trapped near ground
      case AtmosphericStabilityClass.classFModeratelyStableNight:
        return 2.40; // Severe nocturnal inversion channeling
    }
  }

  /// Calculates Downwind Protective Action Distance (PAD) in kilometers.
  /// PAD = C_gas * (Q / u)^0.55 * F_stability
  double get requiredProtectiveActionDistanceKm {
    final windSpeed = math.max(0.5, ambientWindSpeedMetersPerSec);
    final fluxRatio = releaseRateKgPerSec / windSpeed;
    final basePad = gasToxicityConstant * math.pow(fluxRatio, 0.55) * stabilityDispersionFactor;
    return basePad.clamp(0.2, 25.0);
  }

  /// Checks if the established public evacuation perimeter covers the calculated PAD.
  bool get isEvacuationPerimeterAdequate {
    return providedPublicEvacuationRadiusKm >= requiredProtectiveActionDistanceKm;
  }

  /// Emergency sheltering-in-place vs immediate evacuation recommendation.
  String get publicProtectionStrategy {
    if (isNightTimeRelease && (stabilityClass == AtmosphericStabilityClass.classFModeratelyStableNight || stabilityClass == AtmosphericStabilityClass.classESlightlyStableNight)) {
      return 'Immediate Shelter-in-Place: Seal doors/windows with wet cloths, shut HVAC intakes until plume passes.';
    }
    return 'Immediate Upwind / Crosswind Evacuation: Move perpendicular to wind direction to designated assembly points.';
  }
}
