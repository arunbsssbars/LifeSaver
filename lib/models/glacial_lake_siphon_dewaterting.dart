import 'dart:math' as math;

/// Siphon operational status for high-altitude GLOF de-watering.
enum SiphonOperationalStatus {
  optimalPrimedFlow,
  lowDischargeVaporLock,
  freezingVulnerability,
  cavitationLoss,
}

/// Assessment model for High-Altitude Glacial Lake Siphon De-Watering.
///
/// Implements NDMA / CWC Glacial Lake Outburst Flood (GLOF) mitigation guidelines.
/// Formulates:
/// - Siphon discharge: Q = n * C_d * A * sqrt(2 * g * Delta_H)
/// - Siphon summit vacuum head: H_s = Delta_H_suction + (v^2 / 2g) + h_friction
/// - Safe vacuum limit to prevent cavitation: H_s <= Patm / rho*g - Pvapor / rho*g
/// - Lake level drawdown duration: t_days = Delta_V / (Q_daily)
class GlacialLakeSiphonDewaterting {
  final String glacialLakeName;
  final double lakeElevationMetersAboveSeaLevel;
  final int numberOfInstalledHdpeSiphonLines;
  final double internalPipeDiameterMm; // e.g. 250 - 400 mm HDPE PN10
  final double netSiphonDrivingHeadMeters; // Height difference between lake intake and discharge outlet
  final double siphonSummitHeightAboveLakeMeters; // Suction lift to the moraine crest
  final double targetLakeWaterVolumeDrawdownMillionM3;
  final double ambientTemperatureCelsius;
  final bool hasSelfPrimingVacuumTank;
  final bool hasThermalInsulationAndHeatTrace;

  const GlacialLakeSiphonDewaterting({
    required this.glacialLakeName,
    required this.lakeElevationMetersAboveSeaLevel,
    required this.numberOfInstalledHdpeSiphonLines,
    required this.internalPipeDiameterMm,
    required this.netSiphonDrivingHeadMeters,
    required this.siphonSummitHeightAboveLakeMeters,
    required this.targetLakeWaterVolumeDrawdownMillionM3,
    required this.ambientTemperatureCelsius,
    this.hasSelfPrimingVacuumTank = true,
    this.hasThermalInsulationAndHeatTrace = true,
  });

  /// Calculates the cross-sectional area (m^2) of a single siphon line.
  double get singlePipeAreaSqMeters {
    final radiusM = (internalPipeDiameterMm / 1000.0) / 2.0;
    return math.pi * radiusM * radiusM;
  }

  /// Calculates discharge per siphon line in m^3/s (using discharge coefficient Cd ~ 0.72 for long HDPE pipe with fittings).
  double get dischargePerLineCubicMetersPerSec {
    const double cd = 0.72;
    const double g = 9.81;
    if (netSiphonDrivingHeadMeters <= 0.0) return 0.0;
    return cd * singlePipeAreaSqMeters * math.sqrt(2.0 * g * netSiphonDrivingHeadMeters);
  }

  /// Total combined discharge across all operational lines in m^3/s.
  double get totalCombinedDischargeCubicMetersPerSec {
    return dischargePerLineCubicMetersPerSec * numberOfInstalledHdpeSiphonLines;
  }

  /// Total combined daily discharge in m^3/day.
  double get dailyDischargeVolumeCubicMeters {
    return totalCombinedDischargeCubicMetersPerSec * 86400.0;
  }

  /// Estimated days required to achieve target lake volume drawdown.
  double get estimatedDrawdownDays {
    final targetVolM3 = targetLakeWaterVolumeDrawdownMillionM3 * 1000000.0;
    if (dailyDischargeVolumeCubicMeters <= 0.0) return 999.0;
    return (targetVolM3 / dailyDischargeVolumeCubicMeters).clamp(0.1, 999.0);
  }

  /// High altitude atmospheric pressure estimation (approx barometric formula).
  /// At 4500m, atmospheric pressure is approx 57 kPa (~5.8 m water head).
  double get atmosphericPressureHeadMetersWater {
    final pAtmKPa = 101.325 * math.pow(1.0 - (2.25577e-5 * lakeElevationMetersAboveSeaLevel), 5.25588);
    return (pAtmKPa * 1000.0) / (1000.0 * 9.81);
  }

  /// Evaluates whether the siphon summit lift exceeds the barometric vapor pressure cavitation threshold.
  bool get isSummitCavitationRisk {
    // Summit height plus velocity and friction allowance (~1.5m) must be <= atmospheric pressure head - 1.5m safety margin
    return (siphonSummitHeightAboveLakeMeters + 1.5) > (atmosphericPressureHeadMetersWater - 1.5);
  }

  /// Evaluates operational health of the siphon system.
  SiphonOperationalStatus get operationalStatus {
    if (ambientTemperatureCelsius < -2.0 && !hasThermalInsulationAndHeatTrace) {
      return SiphonOperationalStatus.freezingVulnerability;
    }
    if (isSummitCavitationRisk) {
      return SiphonOperationalStatus.cavitationLoss;
    }
    if (!hasSelfPrimingVacuumTank) {
      return SiphonOperationalStatus.lowDischargeVaporLock;
    }
    return SiphonOperationalStatus.optimalPrimedFlow;
  }

  /// Mandates freeze mitigation if freezing risk is active.
  bool get isSubZeroFreezeProtectionRequired {
    return ambientTemperatureCelsius <= 0.0 && !hasThermalInsulationAndHeatTrace;
  }
}
