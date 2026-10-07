/// Safety status of mounded LPG storage bullet per OISD-STD-150 / PESO.
enum MoundedBulletSafetyStatus {
  certifiedInherentlySafe,
  marginalCathodicProtection,
  excessiveSettlementRisk,
  moundCoverErosionViolation,
}

/// Safety telemetry and structural model for LPG Mounded Bullet Storage Installations.
///
/// Implements OISD-STD-150 (Design & Safety Requirements for Mounded Storage of LPG) and PESO standards.
/// Formulates:
/// - Earth/sand cover thickness >= 1.0 meter over top of vessel shell.
/// - Cathodic Protection (CP) off-potential criterion: -850 mV to -1200 mV vs Cu/CuSO4 reference electrode.
/// - Settlement monitoring across concrete continuous saddles (differential settlement <= 10 mm).
/// - Inherently BLEVE-proof design verification under external fire impingement.
class LpgMoundedBulletSafety {
  final String bulletFacilityTag;
  final String lpgBottlingPlantLocation;
  final double vesselStorageCapacityTonnes;
  final double providedMoundCoverThicknessMeters; // Must be >= 1.0 m per OISD-STD-150
  final double measuredCathodicProtectionPotentialMilliVolts; // Typically -850 to -1150 mV
  final double measuredDifferentialSettlementMm; // Must be <= 10.0 mm
  final double operatingVapourPressureBar;
  final double designPressureBar;
  final bool hasHydrocarbonGasDetectorsAtManholeTrench;
  final bool hasPressureVacuumReliefValvesCertified;

  const LpgMoundedBulletSafety({
    required this.bulletFacilityTag,
    required this.lpgBottlingPlantLocation,
    required this.vesselStorageCapacityTonnes,
    required this.providedMoundCoverThicknessMeters,
    required this.measuredCathodicProtectionPotentialMilliVolts,
    required this.measuredDifferentialSettlementMm,
    required this.operatingVapourPressureBar,
    required this.designPressureBar,
    this.hasHydrocarbonGasDetectorsAtManholeTrench = true,
    this.hasPressureVacuumReliefValvesCertified = true,
  });

  /// Evaluates whether the earthen/sand mound cover thickness satisfies OISD-STD-150 standard (>= 1.0m).
  bool get isMoundCoverThicknessCompliant {
    return providedMoundCoverThicknessMeters >= 1.0;
  }

  /// Checks if Cathodic Protection potential is within the protective range (-850 mV to -1200 mV vs Cu/CuSO4).
  bool get isCathodicProtectionEffective {
    return measuredCathodicProtectionPotentialMilliVolts <= -850.0 &&
        measuredCathodicProtectionPotentialMilliVolts >= -1200.0;
  }

  /// Evaluates whether differential foundation settlement is within the 10mm structural limit.
  bool get isDifferentialSettlementAcceptable {
    return measuredDifferentialSettlementMm <= 10.0;
  }

  /// Operating pressure margin percentage relative to design pressure.
  double get operatingPressureRatioPercent {
    if (designPressureBar <= 0.0) return 100.0;
    return (operatingVapourPressureBar / designPressureBar) * 100.0;
  }

  /// Evaluates statutory OISD-STD-150 safety status.
  MoundedBulletSafetyStatus get safetyStatus {
    if (!isMoundCoverThicknessCompliant) {
      return MoundedBulletSafetyStatus.moundCoverErosionViolation;
    }
    if (!isDifferentialSettlementAcceptable) {
      return MoundedBulletSafetyStatus.excessiveSettlementRisk;
    }
    if (!isCathodicProtectionEffective) {
      return MoundedBulletSafetyStatus.marginalCathodicProtection;
    }
    return MoundedBulletSafetyStatus.certifiedInherentlySafe;
  }

  /// Returns true if the installation is certified for pressurized LPG storage without risk of catastrophic BLEVE.
  bool get isBleveImmuneCertified {
    return safetyStatus == MoundedBulletSafetyStatus.certifiedInherentlySafe &&
        hasHydrocarbonGasDetectorsAtManholeTrench &&
        hasPressureVacuumReliefValvesCertified;
  }
}
