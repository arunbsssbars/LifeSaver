/// Model representing NDMA Medical Preparedness Guidelines on Burn and Blast Trauma
/// including Wallace Rule of Nines for Total Body Surface Area (TBSA) and Parkland Resuscitation.
enum BurnDegreeClassification {
  firstDegree('First Degree (Superficial - Red, painful, dry, no blisters)'),
  secondDegree('Second Degree (Partial Thickness - Blisters, severe pain, weeping)'),
  thirdDegree('Third Degree (Full Thickness - Leathery, charred/white, painless due to nerve destruction)');

  final String label;
  const BurnDegreeClassification(this.label);
}

class BurnAssessmentCalculator {
  /// Computes initial 24-hour IV fluid resuscitation volume via Parkland Formula
  /// Volume = 4 mL × Weight in kg × % TBSA
  static double calculateParkland24HourVolumeMl({
    required double patientWeightKg,
    required double totalBodySurfaceAreaPercent,
  }) {
    return 4.0 * patientWeightKg * totalBodySurfaceAreaPercent;
  }

  /// Calculates first 8-hour infusion volume (50% of 24h volume)
  static double calculateFirst8HourVolumeMl({
    required double patientWeightKg,
    required double totalBodySurfaceAreaPercent,
  }) {
    return calculateParkland24HourVolumeMl(
          patientWeightKg: patientWeightKg,
          totalBodySurfaceAreaPercent: totalBodySurfaceAreaPercent,
        ) /
        2.0;
  }

  static const List<String> criticalBurnDirectives = [
    'COOL the burn with clean, cool running water for 15–20 minutes. NEVER use ice or iced water (causes vasoconstriction and hypothermia).',
    'DO NOT apply butter, toothpaste, turmeric, mustard oil, or raw egg whites (triggers severe wound sepsis).',
    'DO NOT pop blisters or peel clothing adhered directly to charred flesh.',
    'COVER loosely with clean plastic cling wrap or sterile non-adherent cotton gauze.',
    'For chemical burns: Brush off dry powders first, then flush copiously with copious water for minimum 30 minutes.',
    'For blast injuries: Check airway patency, look for tension pneumothorax and ruptured eardrums, apply tourniquet for limb hemorrhage.',
  ];
}
