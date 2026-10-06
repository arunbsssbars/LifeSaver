/// Model representing Central Motor Vehicles Rules (CMVR) & PESO
/// HAZCHEM Emergency Action Code (EAC) & UN Dangerous Goods Number System.
class HazchemActionGuide {
  final String unNumber;
  final String chemicalName;
  final String hazchemCode; // e.g. "2WE", "3YE", "2RE"
  final String primaryHazardClass;
  final String firefightingMedium;
  final String personalProtectionLevel;
  final double immediateIsolationRadiusMeters;

  const HazchemActionGuide({
    required this.unNumber,
    required this.chemicalName,
    required this.hazchemCode,
    required this.primaryHazardClass,
    required this.firefightingMedium,
    required this.personalProtectionLevel,
    required this.immediateIsolationRadiusMeters,
  });

  static const List<HazchemActionGuide> commonTransportChemicals = [
    HazchemActionGuide(
      unNumber: 'UN 1017',
      chemicalName: 'Chlorine Gas (Liquefied Compressed)',
      hazchemCode: '2XE',
      primaryHazardClass: 'Class 2.3 (Toxic Gas) & Class 5.1 (Oxidizer)',
      firefightingMedium: 'Water Fog / Fine Spray (DO NOT apply water directly into leaking cylinder container)',
      personalProtectionLevel: 'Level A Encapsulated Gas-Tight Hazmat Suit with SCBA',
      immediateIsolationRadiusMeters: 500.0,
    ),
    HazchemActionGuide(
      unNumber: 'UN 1075',
      chemicalName: 'Petroleum Gases, Liquefied (LPG)',
      hazchemCode: '2WE',
      primaryHazardClass: 'Class 2.1 (Flammable Gas - BLEVE Hazard)',
      firefightingMedium: 'Water spray cooling on tank shell. Stop gas flow before extinguishing flame.',
      personalProtectionLevel: 'Full Structural Firefighter Protective Clothing with SCBA',
      immediateIsolationRadiusMeters: 800.0,
    ),
    HazchemActionGuide(
      unNumber: 'UN 1005',
      chemicalName: 'Anhydrous Ammonia Gas',
      hazchemCode: '2RE',
      primaryHazardClass: 'Class 2.3 (Toxic & Corrosive Gas)',
      firefightingMedium: 'Copious water fog curtain to absorb and neutralize ammonia vapor',
      personalProtectionLevel: 'Level B Chemical Splash Suit with positive-pressure SCBA',
      immediateIsolationRadiusMeters: 300.0,
    ),
  ];
}
