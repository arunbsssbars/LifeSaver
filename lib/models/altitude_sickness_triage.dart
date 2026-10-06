/// Model representing ITBP & Army Medical Corps High-Altitude Rescue
/// Lake Louise Acute Mountain Sickness (AMS), HAPE, and HACE Severity Triage.
enum HighAltitudeEmergencyType {
  mildAms('Mild Acute Mountain Sickness - Rest & Acclimatization', 0xFF10B981),
  moderateAms('Moderate AMS - Acetazolamide 250mg & Halt Ascent', 0xFFFBBF24),
  severeHapeHace('CRITICAL HAPE/HACE - Immediate Descent >= 1000m, Gamow Bag & Dexamethasone', 0xFFEF4444);

  final String guidance;
  final int colorValue;
  const HighAltitudeEmergencyType(this.guidance, this.colorValue);
}

class AltitudeSicknessTriage {
  final double currentAltitudeMeters;
  final int headacheScore; // 0 (None) to 3 (Severe/Incapacitating)
  final int gastrointestinalScore; // 0 to 3
  final int fatigueWeaknessScore; // 0 to 3
  final int dizzinessLightheadednessScore; // 0 to 3
  final bool hasAtaxiaLossOfCoordination; // HACE sign
  final bool hasDyspneaAtRestAndCyanosis; // HAPE sign

  const AltitudeSicknessTriage({
    required this.currentAltitudeMeters,
    required this.headacheScore,
    required this.gastrointestinalScore,
    required this.fatigueWeaknessScore,
    required this.dizzinessLightheadednessScore,
    required this.hasAtaxiaLossOfCoordination,
    required this.hasDyspneaAtRestAndCyanosis,
  });

  /// Lake Louise AMS Total Score (requires headache > 0 + at least one other symptom)
  int get lakeLouiseScore {
    if (headacheScore == 0) return 0;
    return headacheScore + gastrointestinalScore + fatigueWeaknessScore + dizzinessLightheadednessScore;
  }

  /// Evaluates altitude medical emergency category
  HighAltitudeEmergencyType get emergencySeverity {
    if (hasAtaxiaLossOfCoordination || hasDyspneaAtRestAndCyanosis || lakeLouiseScore >= 9) {
      return HighAltitudeEmergencyType.severeHapeHace;
    } else if (lakeLouiseScore >= 3) {
      return HighAltitudeEmergencyType.moderateAms;
    }
    return HighAltitudeEmergencyType.mildAms;
  }

  /// True if hyperbaric chamber (Gamow Bag) or emergency helicopter evacuation is mandatory
  bool get isImmediateDescentMandatory => emergencySeverity == HighAltitudeEmergencyType.severeHapeHace;
}
