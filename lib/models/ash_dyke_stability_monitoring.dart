import 'dart:math' as math;

/// Ash dyke safety condition per MoEFCC / CEA / CPCB thermal power plant guidelines.
enum AshDykeSafetyStatus {
  stableEngineeredOperation,
  piezometricSeepageWarning,
  inadequateFreeboardAlert,
  imminentBreachOvertoppingRisk,
}

/// Geotechnical and environmental telemetry for Thermal Power Plant Ash Dyke Lagoons.
///
/// Implements MoEFCC, Central Electricity Authority (CEA), and CPCB fly ash embankment safety guidelines.
/// Formulates:
/// - Freeboard depth: H_freeboard = Embankment Crest Level - Slurry Water Level >= 1.50 meters.
/// - Phreatic line elevation within dyke embankment vs downstream toe filter drain.
/// - Decant well riser capacity: Q_decant = C_d * (pi * D_well) * (2/3) * sqrt(2 * g) * H_weir^(3/2)
/// - Piezometer pore pressure ratio: r_u = u / (gamma * h) <= 0.35 threshold.
class AshDykeStabilityMonitoring {
  final String thermalPowerPlantName;
  final String ashDykeLagoonTag;
  final double embankmentCrestLevelMeters;
  final double currentAshSlurryWaterLevelMeters;
  final double decantWellDiameterMeters;
  final double decantWeirOverflowDepthMeters;
  final double measuredPorePressureRatioRu; // r_u = u / gamma*h (typically 0.15 - 0.45)
  final double downstreamToeSeepageDischargeLps; // Litres per second
  final bool hasRockToeFilterDrainClean;
  final bool hasDedicatedEmergencySlurryDiversionChannel;

  const AshDykeStabilityMonitoring({
    required this.thermalPowerPlantName,
    required this.ashDykeLagoonTag,
    required this.embankmentCrestLevelMeters,
    required this.currentAshSlurryWaterLevelMeters,
    required this.decantWellDiameterMeters,
    required this.decantWeirOverflowDepthMeters,
    required this.measuredPorePressureRatioRu,
    required this.downstreamToeSeepageDischargeLps,
    this.hasRockToeFilterDrainClean = true,
    this.hasDedicatedEmergencySlurryDiversionChannel = true,
  });

  /// Calculates available freeboard depth in meters.
  /// Standard requires H_freeboard >= 1.50 meters during monsoon operations.
  double get currentFreeboardMeters {
    return embankmentCrestLevelMeters - currentAshSlurryWaterLevelMeters;
  }

  /// Calculates decant well riser weir discharge capacity in m^3/s.
  /// Q_decant = 0.60 * (pi * D) * (2/3) * sqrt(2 * g) * H^(3/2)
  double get decantWellDischargeCapacityCubicMetersPerSec {
    const double g = 9.81;
    if (decantWeirOverflowDepthMeters <= 0.0) return 0.0;
    final perimeter = math.pi * decantWellDiameterMeters;
    final discharge = 0.60 * perimeter * (2.0 / 3.0) * math.sqrt(2.0 * g) * math.pow(decantWeirOverflowDepthMeters, 1.5);
    return discharge;
  }

  /// Evaluates whether the freeboard meets statutory MoEFCC / CEA 1.5m standard.
  bool get isFreeboardAdequate {
    return currentFreeboardMeters >= 1.50;
  }

  /// Evaluates whether internal pore pressure ratio is safe from static liquefaction (r_u <= 0.35).
  bool get isPorePressureSafeFromLiquefaction {
    return measuredPorePressureRatioRu <= 0.35;
  }

  /// Evaluates ash dyke safety status.
  AshDykeSafetyStatus get safetyStatus {
    if (currentFreeboardMeters < 0.50 || measuredPorePressureRatioRu >= 0.45) {
      return AshDykeSafetyStatus.imminentBreachOvertoppingRisk;
    }
    if (!isFreeboardAdequate) {
      return AshDykeSafetyStatus.inadequateFreeboardAlert;
    }
    if (!isPorePressureSafeFromLiquefaction || !hasRockToeFilterDrainClean || downstreamToeSeepageDischargeLps > 25.0) {
      return AshDykeSafetyStatus.piezometricSeepageWarning;
    }
    return AshDykeSafetyStatus.stableEngineeredOperation;
  }

  /// Returns true if the ash dyke is operating within safe environmental and geotechnical parameters.
  bool get isAshDykeSafeAndCompliant {
    return safetyStatus == AshDykeSafetyStatus.stableEngineeredOperation;
  }
}
