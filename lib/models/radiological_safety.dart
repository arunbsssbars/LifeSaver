/// Model representing Atomic Energy Regulatory Board (AERB) & NDMA Guidelines
/// on Management of Nuclear and Radiological Emergencies (CBRN Part II).
enum RadiationThreatCategory {
  normalBackground(
    label: 'Normal Background Radiation',
    doseRateMicroSvPerHour: 0.15,
    action: 'Standard environmental background radiation. No protective action needed.',
    colorValue: 0xFF10B981,
  ),
  elevatedAlert(
    label: 'Elevated Radiological Advisory',
    doseRateMicroSvPerHour: 10.0,
    action: 'Emergency Planning Zone (EPZ) alert. Stay indoors, seal windows, and close AC vents.',
    colorValue: 0xFFFBBF24,
  ),
  criticalEmergency(
    label: 'Radiological / Nuclear Emergency',
    doseRateMicroSvPerHour: 1000.0,
    action: 'Severe radiation plume release! Shelter in concrete basement or evacuate under DAE/NDMA directive.',
    colorValue: 0xFFEF4444,
  );

  final String label;
  final double doseRateMicroSvPerHour;
  final String action;
  final int colorValue;

  const RadiationThreatCategory({
    required this.label,
    required this.doseRateMicroSvPerHour,
    required this.action,
    required this.colorValue,
  });
}

class RadiologicalSafetyGuide {
  final String title;
  final String principle;
  final List<String> practicalSteps;

  const RadiologicalSafetyGuide({
    required this.title,
    required this.principle,
    required this.practicalSteps,
  });

  static const List<RadiologicalSafetyGuide> guides = [
    RadiologicalSafetyGuide(
      title: 'The Golden Triad: Time, Distance, Shielding',
      principle: 'Dose decreases inversely with the square of distance (1/r²) and proportionally with shielding mass.',
      practicalSteps: [
        'TIME: Minimize the time spent in areas with elevated radiation levels.',
        'DISTANCE: Double the distance from a radiation source to reduce radiation exposure to 1/4th.',
        'SHIELDING: Concrete, dense brick, lead, and packed earth offer the highest radiation protection factors (PF > 10).',
      ],
    ),
    RadiologicalSafetyGuide(
      title: 'Indoor Sheltering & Sealing SOP (NDMA/AERB)',
      principle: 'Airborne fallout particles deposit externally on roofs and ground.',
      practicalSteps: [
        'Move to the center of a concrete building or below-ground basement.',
        'Turn off all split/window AC units, exhaust fans, and kitchen chimneys to prevent drawing outside air.',
        'Seal cracks around doors and windows with plastic sheets and duct tape.',
        'Do not consume uncovered food, rainwater, or tap water sourced from open reservoirs.',
      ],
    ),
    RadiologicalSafetyGuide(
      title: 'Decontamination & Personal Hygiene',
      principle: 'Removing contaminated outer clothing eliminates up to 90% of radioactive fallout particles.',
      practicalSteps: [
        'Remove outer shoes and clothes before entering clean living spaces; double-bag them in heavy plastic.',
        'Wash hair and body gently with soap and lukewarm water. Do NOT scrub harshly or use hair conditioner (which binds radioactive dust to hair shafts).',
        'Blow nose gently, wipe eyelids and ears with clean wet wipes.',
      ],
    ),
    RadiologicalSafetyGuide(
      title: 'Potassium Iodide (KI) Thyroid Block Prophylaxis',
      principle: 'Non-radioactive iodine saturates the thyroid gland to prevent radioactive Iodine-131 absorption.',
      practicalSteps: [
        'Take Potassium Iodide (KI) ONLY when explicitly directed by public health or NDMA authorities.',
        'Standard single daily dose: Adults 130 mg, Children (3-12 yrs) 65 mg, Infants (<1 yr) 16 mg.',
        'KI protects ONLY the thyroid gland from radioiodine and does not protect against external gamma radiation.',
      ],
    ),
  ];
}
