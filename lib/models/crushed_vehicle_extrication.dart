/// Loop 144: Tree Fall & Crushed Vehicle Extrication Protocol
/// Aligned with NDRF USAR Vehicle Rescue SOP & MoRTH IRC SP 106 Highway Disaster standards.

class CrushedVehicleExtrication {
  final double estimatedDebrisWeightTons; // e.g. fallen tree/boulder weight
  final double compressionDurationMinutes; // Duration casualty has been pinned
  final double hydraulicSpreaderCapacityKn; // e.g. 150-600 kN
  final int trappedCasualtyCount;
  final bool hasPreReleaseIvSalineInitiated;
  final bool isChassisCribbingStabilized;

  const CrushedVehicleExtrication({
    required this.estimatedDebrisWeightTons,
    required this.compressionDurationMinutes,
    required this.hydraulicSpreaderCapacityKn,
    required this.trappedCasualtyCount,
    required this.hasPreReleaseIvSalineInitiated,
    required this.isChassisCribbingStabilized,
  });

  /// Required lifting force in kN (1 Ton ~ 9.81 kN)
  double get requiredLiftingForceKn => estimatedDebrisWeightTons * 9.81 * 1.5; // 1.5x safety factor

  /// Is hydraulic equipment sufficient for lifting?
  bool get isHydraulicCapacityAdequate => hydraulicSpreaderCapacityKn >= requiredLiftingForceKn;

  /// Risk of lethal Crush Syndrome (reperfusion of myoglobin/potassium causing cardiac arrest)
  /// Pinned > 15 minutes poses severe reperfusion injury risk.
  bool get isCrushSyndromeRiskHigh => compressionDurationMinutes >= 15.0;

  /// Critical medical extrication mandate
  String get medicalExtricationMandate {
    if (isCrushSyndromeRiskHigh && !hasPreReleaseIvSalineInitiated) {
      return 'CRITICAL WARNING: Pinning > 15 mins. DO NOT LIFT WEIGHT without intravenous normal saline hydration & tourniquet prep to prevent fatal reperfusion cardiac arrest!';
    } else if (isCrushSyndromeRiskHigh && hasPreReleaseIvSalineInitiated) {
      return 'IV hydration active. Maintain ECG monitoring and prepare sodium bicarbonate for acidosis before final weight release.';
    } else {
      return 'Brief compression duration (< 15 mins). Standard rapid extrication permissible with cervical spine immobilization.';
    }
  }

  /// Tactical vehicle stabilization protocol
  String get tacticalStabilizationProtocol {
    if (!isChassisCribbingStabilized) {
      return 'Deploy 4x4 hardwood box cribbing and step chocks beneath vehicle rocker panels to arrest secondary collapse before roof peel.';
    }
    return 'Chassis stabilized. Proceed with hydraulic A/B post cutting and dashboard roll.';
  }
}
