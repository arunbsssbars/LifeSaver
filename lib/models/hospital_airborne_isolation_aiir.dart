/// AIIR containment grade per MoHFW / CDC / ISHRAE hospital ventilation standards.
enum AiirContainmentGrade {
  certifiedBiologicalContainment,
  marginalAirflowCompliance,
  positivePressureEscapeBreach,
  criticalFiltrationFailure,
}

/// Engineering model for Hospital Negative Pressure Airborne Infection Isolation Rooms (AIIR).
///
/// Implements MoHFW (Ministry of Health and Family Welfare), CDC, and ISHRAE HVAC biological disaster standards.
/// Formulates:
/// - Room differential pressure head: P_diff <= -2.5 Pa minimum (recommended -8.0 Pa)
/// - Air Changes per Hour (ACH): ACH = (Exhaust Airflow CFM * 60) / Room Volume Cu.Ft >= 12 ACH
/// - HEPA filter retention efficiency: >= 99.97% at 0.3 micron particle diameter
/// - Anteroom differential air lock cascade protection
class HospitalAirborneIsolationAiir {
  final String hospitalIsolationWardId;
  final String patientRoomNumber;
  final double roomVolumeCubicMeters;
  final double measuredExhaustFlowRateCmh; // Cubic meters per hour
  final double measuredDifferentialPressurePascals; // e.g. -8.5 Pa (negative relative to corridor)
  final double hepaFilterEfficiencyPercent; // e.g. 99.97%
  final double anteroomDifferentialPressurePascals; // e.g. -4.0 Pa
  final bool hasSelfClosingSealedDoors;
  final bool isUvgiGermicidalDisinfectionActive;

  const HospitalAirborneIsolationAiir({
    required this.hospitalIsolationWardId,
    required this.patientRoomNumber,
    required this.roomVolumeCubicMeters,
    required this.measuredExhaustFlowRateCmh,
    required this.measuredDifferentialPressurePascals,
    required this.hepaFilterEfficiencyPercent,
    required this.anteroomDifferentialPressurePascals,
    required this.hasSelfClosingSealedDoors,
    this.isUvgiGermicidalDisinfectionActive = true,
  });

  /// Calculates actual Air Changes per Hour (ACH).
  /// Standard requires ACH >= 12.0 for epidemic biological isolation.
  double get airChangesPerHour {
    if (roomVolumeCubicMeters <= 0.0) return 0.0;
    return measuredExhaustFlowRateCmh / roomVolumeCubicMeters;
  }

  /// Evaluates whether the negative pressure differential is adequate (P <= -2.5 Pa).
  bool get isNegativePressureAdequate {
    return measuredDifferentialPressurePascals <= -2.5;
  }

  /// Evaluates whether ACH meets or exceeds the mandatory 12 ACH standard.
  bool get isVentilationRateAdequate {
    return airChangesPerHour >= 12.0;
  }

  /// Evaluates whether HEPA filtration satisfies medical 99.97% standard.
  bool get isHepaFiltrationCertified {
    return hepaFilterEfficiencyPercent >= 99.97;
  }

  /// Checks if proper anteroom airlock cascade is maintained (Corridor > Anteroom > Isolation Room).
  bool get isPressureCascadeSequential {
    return 0.0 > anteroomDifferentialPressurePascals &&
        anteroomDifferentialPressurePascals > measuredDifferentialPressurePascals;
  }

  /// Evaluates comprehensive biological containment grade.
  AiirContainmentGrade get containmentGrade {
    if (measuredDifferentialPressurePascals >= 0.0 || !hasSelfClosingSealedDoors) {
      return AiirContainmentGrade.positivePressureEscapeBreach;
    }
    if (!isHepaFiltrationCertified) {
      return AiirContainmentGrade.criticalFiltrationFailure;
    }
    if (!isNegativePressureAdequate || !isVentilationRateAdequate || !isPressureCascadeSequential) {
      return AiirContainmentGrade.marginalAirflowCompliance;
    }
    return AiirContainmentGrade.certifiedBiologicalContainment;
  }

  /// Evaluates whether the isolation room is safe to admit high-consequence airborne infectious patients.
  bool get isReadyForAirbornePatientAdmission {
    return containmentGrade == AiirContainmentGrade.certifiedBiologicalContainment;
  }
}
