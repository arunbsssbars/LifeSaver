/// Model representing National Centre for Disease Control (NCDC) & NDMA
/// Biological Disaster Management Guidelines for Post-Flood Disease Outbreak Prevention.
enum PostFloodHazard {
  cholera(
    disease: 'Cholera & Acute Watery Diarrhea (Vibrio cholerae)',
    incubationPeriod: '2 hours to 5 days',
    transmissionMode: 'Fecal-oral route via contaminated water/food in relief camps.',
    symptoms: 'Profuse rice-water diarrhea, rapid dehydration, muscle cramps.',
    criticalAction: 'Immediate Oral Rehydration Salts (ORS), clean halogen tablet water, Ringers Lactate for shock.',
  ),
  leptospirosis(
    disease: 'Leptospirosis / Rat Fever (Leptospira interrogans)',
    incubationPeriod: '5 to 14 days',
    transmissionMode: 'Contact of broken skin/mucosa with floodwaters contaminated with rodent urine.',
    symptoms: 'High fever, intense calf muscle pain, conjunctival suffusion (red eyes), jaundice.',
    criticalAction: 'Wear gumboots in stagnant waters; prophylactic Doxycycline under medical supervision.',
  ),
  dengue(
    disease: 'Dengue & Chikungunya (Aedes aegypti)',
    incubationPeriod: '4 to 10 days',
    transmissionMode: 'Bites of day-biting mosquitoes breeding in stagnant post-flood puddles & containers.',
    symptoms: 'Sudden high fever, severe retro-orbital eye pain, joint agony, petechial rash.',
    criticalAction: 'Eliminate stagnant water in coolers/pots; apply DEET repellents; monitor platelet count.',
  ),
  hepatitisAE(
    disease: 'Viral Hepatitis A & E',
    incubationPeriod: '15 to 50 days',
    transmissionMode: 'Waterborne viral contamination from breached sewage lines mixing with drinking supply.',
    symptoms: 'Jaundice, dark urine, pale stools, nausea, extreme fatigue.',
    criticalAction: 'Boil water for minimum 1 minute vigorous rolling boil; consume only cooked, hot foods.',
  );

  final String disease;
  final String incubationPeriod;
  final String transmissionMode;
  final String symptoms;
  final String criticalAction;

  const PostFloodHazard({
    required this.disease,
    required this.incubationPeriod,
    required this.transmissionMode,
    required this.symptoms,
    required this.criticalAction,
  });
}

class WaterDisinfectionGuide {
  /// Halogen / Chlorine tablet calculation (Sodium Dichloroisocyanurate - NaDCC)
  static String calculateChlorineDose({required double waterLiters}) {
    // Standard NDMA/NCDC norm: 1 tablet (33mg NaDCC) per 5 Liters of clear water (gives ~2-4 ppm chlorine)
    final tabletsNeeded = (waterLiters / 5.0).ceil();
    return '$tabletsNeeded Chlorine/Halogen tablet(s) required. Dissolve and wait 30 minutes contact time before consumption.';
  }

  /// Oral Rehydration Solution (ORS) WHO/UNICEF formulation
  static const String orsRecipe =
      'WHO ORS Formulation: Dissolve 1 sachet in exactly 1.0 Liter of safe drinking water.\n'
      'Emergency Homemade SSS (Sugar-Salt Solution): 6 level teaspoons sugar + 1/2 level teaspoon salt in 1.0 Liter clean boiled water.';
}
