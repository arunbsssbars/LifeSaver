/// Loop 145: Open-Field Lightning Ground Step-Potential & Reverse Triage Model
/// Aligned with IMD Damini Alert Guidelines, NDMA Lightning SOP & IS/IEC 62305.

class LightningFieldSafety {
  final double distanceToTallObjectMeters; // Distance to lone tree / pole
  final double heightOfTallObjectMeters;
  final double flashToBangIntervalSeconds; // Seconds between lightning flash and thunderclap
  final bool isWorkerInOpenAgriculturalField;
  final bool isTouchingMetalEquipment;
  final int victimCardiacArrestCount;

  const LightningFieldSafety({
    required this.distanceToTallObjectMeters,
    required this.heightOfTallObjectMeters,
    required this.flashToBangIntervalSeconds,
    required this.isWorkerInOpenAgriculturalField,
    required this.isTouchingMetalEquipment,
    required this.victimCardiacArrestCount,
  });

  /// Approximate distance to storm cell (km) based on speed of sound (340 m/s)
  double get estimatedStormDistanceKm => (flashToBangIntervalSeconds * 340.0) / 1000.0;

  /// 30-30 Rule Compliance: If flash-to-bang is < 30 seconds (~10 km), immediate indoor shelter required
  bool get isImmediateShelterMandatory => flashToBangIntervalSeconds < 30.0;

  /// Side-flash danger zone: Standing within 2x height of a single tree/pole carries severe side-flash risk
  bool get isSideFlashDangerPresent =>
      heightOfTallObjectMeters > 0 && distanceToTallObjectMeters < (2.0 * heightOfTallObjectMeters);

  /// Reverse Triage Principle: Lightning cardiac arrest victims appear dead (apneic/pulseless)
  /// but have high resuscitation rates if CPR is started immediately!
  String get reverseTriageProtocol {
    if (victimCardiacArrestCount > 0) {
      return 'REVERSE TRIAGE APPLIED: Treat unresponsive, pulseless lightning victims FIRST with immediate continuous CPR (30:2) and AED! Heart often resumes with prompt oxygenation.';
    }
    return 'Assess survivors for ruptured eardrums, keraunoparalysis, and blast-related secondary injuries.';
  }

  /// Tactical open-field posture
  String get tacticalFieldPosture {
    if (isWorkerInOpenAgriculturalField) {
      return 'ADOPT LIGHTNING CROUCH: Drop to balls of feet, keep heels touching tightly together (minimizing step potential ΔV), tuck head between knees, cover ears, and avoid lying flat on ground!';
    }
    return 'Move immediately into an enclosed pucca structure or metal-bodied enclosed vehicle (Faraday cage effect).';
  }
}
