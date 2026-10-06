/// Model representing MoHFW eSanjeevani Disaster Tele-Consultation & Field Vitals Triage.
enum TelemedicineTriageSeverity {
  mildNonUrgent('Green - Routine Tele-Consultation', 0xFF10B981),
  moderateUrgent('Yellow - Urgent Medical Advice within 30 mins', 0xFFFBBF24),
  severeCritical('Red - Critical Tele-ICU Specialist Direction Required Immediately', 0xFFEF4444);

  final String label;
  final int colorValue;
  const TelemedicineTriageSeverity(this.label, this.colorValue);
}

class TelemedicinePatientCase {
  final String patientId;
  final int age;
  final String chiefComplaint;
  final double pulseRateBpm;
  final double oxygenSaturationSpO2;
  final int systolicBloodPressureMmHg;
  final int glasgowComaScale; // 3 to 15

  const TelemedicinePatientCase({
    required this.patientId,
    required this.age,
    required this.chiefComplaint,
    required this.pulseRateBpm,
    required this.oxygenSaturationSpO2,
    required this.systolicBloodPressureMmHg,
    required this.glasgowComaScale,
  });

  /// Evaluates clinical triage priority for tele-specialist queue
  TelemedicineTriageSeverity get triageSeverity {
    if (oxygenSaturationSpO2 < 90.0 ||
        glasgowComaScale < 12 ||
        systolicBloodPressureMmHg < 80 ||
        pulseRateBpm > 130) {
      return TelemedicineTriageSeverity.severeCritical;
    } else if (oxygenSaturationSpO2 < 94.0 || systolicBloodPressureMmHg > 160 || pulseRateBpm > 100) {
      return TelemedicineTriageSeverity.moderateUrgent;
    }
    return TelemedicineTriageSeverity.mildNonUrgent;
  }
}
