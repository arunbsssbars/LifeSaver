import 'dart:math' as math;

/// Urban flood attenuation performance state per CPHEEO urban drainage guidelines.
enum DetentionPondPerformance {
  optimalPeakAttenuation,
  marginalCapacityWarning,
  emergencyWeirOvertopping,
  catastrophicSurcharge,
}

/// Hydraulic modeling and routing telemetry for Urban Stormwater Detention Ponds.
///
/// Implements CPHEEO (Central Public Health & Environmental Engineering Organisation) and MoHUA Urban Storm Drainage Manual.
/// Formulates:
/// - Orifice discharge: Q_o = C_d * A_o * sqrt(2 * g * h)
/// - Broad-crested emergency weir discharge: Q_w = 1.705 * C_w * L_w * H_w^(3/2)
/// - Peak inflow attenuation percentage: Attenuation % = ((Q_in_peak - Q_out_peak) / Q_in_peak) * 100
/// - Pond stage storage ratio = S_current / S_total
class UrbanDetentionPondRouting {
  final String pondFacilityTag;
  final String urbanCatchmentZone;
  final double totalPondStorageCapacityCubicMeters;
  final double currentPondWaterVolumeCubicMeters;
  final double bottomOrificeDiameterMeters; // e.g. 0.6 - 1.2 m
  final double emergencyWeirCrestLengthMeters; // e.g. 10.0 - 25.0 m
  final double maximumWaterDepthMeters; // Height from orifice center to spillway crest
  final double currentWaterDepthMeters;
  final double peakStormInflowDischargeCubicMetersPerSec;

  const UrbanDetentionPondRouting({
    required this.pondFacilityTag,
    required this.urbanCatchmentZone,
    required this.totalPondStorageCapacityCubicMeters,
    required this.currentPondWaterVolumeCubicMeters,
    required this.bottomOrificeDiameterMeters,
    required this.emergencyWeirCrestLengthMeters,
    required this.maximumWaterDepthMeters,
    required this.currentWaterDepthMeters,
    required this.peakStormInflowDischargeCubicMetersPerSec,
  });

  /// Calculates the active discharge through the bottom control orifice in m^3/s.
  double get orificeDischargeCubicMetersPerSec {
    const double cd = 0.62;
    const double g = 9.81;
    if (currentWaterDepthMeters <= 0.0) return 0.0;
    final orificeArea = math.pi * math.pow(bottomOrificeDiameterMeters / 2.0, 2);
    return cd * orificeArea * math.sqrt(2.0 * g * currentWaterDepthMeters);
  }

  /// Calculates emergency weir spillway discharge if water depth exceeds max designed depth.
  double get weirDischargeCubicMetersPerSec {
    if (currentWaterDepthMeters <= maximumWaterDepthMeters) return 0.0;
    final headOverWeir = currentWaterDepthMeters - maximumWaterDepthMeters;
    // Q_w = 1.705 * L * H^(3/2)
    return 1.705 * emergencyWeirCrestLengthMeters * math.pow(headOverWeir, 1.5);
  }

  /// Total combined outlet discharge in m^3/s.
  double get totalControlledOutflowDischargeCubicMetersPerSec {
    return orificeDischargeCubicMetersPerSec + weirDischargeCubicMetersPerSec;
  }

  /// Calculates peak hydrograph attenuation percentage (%).
  double get peakAttenuationPercent {
    if (peakStormInflowDischargeCubicMetersPerSec <= 0.0) return 100.0;
    final attenuatedFlow = peakStormInflowDischargeCubicMetersPerSec - totalControlledOutflowDischargeCubicMetersPerSec;
    return ((attenuatedFlow / peakStormInflowDischargeCubicMetersPerSec) * 100.0).clamp(0.0, 100.0);
  }

  /// Percentage of total storage capacity currently utilized.
  double get storageUtilizationPercent {
    if (totalPondStorageCapacityCubicMeters <= 0.0) return 100.0;
    return ((currentPondWaterVolumeCubicMeters / totalPondStorageCapacityCubicMeters) * 100.0).clamp(0.0, 150.0);
  }

  /// Evaluates detention pond performance state.
  DetentionPondPerformance get performanceState {
    if (currentWaterDepthMeters >= (maximumWaterDepthMeters + 0.5) || storageUtilizationPercent >= 120.0) {
      return DetentionPondPerformance.catastrophicSurcharge;
    }
    if (currentWaterDepthMeters > maximumWaterDepthMeters || storageUtilizationPercent >= 95.0) {
      return DetentionPondPerformance.emergencyWeirOvertopping;
    }
    if (storageUtilizationPercent >= 80.0 || peakAttenuationPercent < 40.0) {
      return DetentionPondPerformance.marginalCapacityWarning;
    }
    return DetentionPondPerformance.optimalPeakAttenuation;
  }

  /// Returns true if the pond is actively mitigating downstream urban street flooding safely.
  bool get isSafeDownstreamProtectionMaintained {
    return performanceState == DetentionPondPerformance.optimalPeakAttenuation ||
        performanceState == DetentionPondPerformance.marginalCapacityWarning;
  }
}
