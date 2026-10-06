class FireSafetyGuide {
  final String title;
  final String fireClass;
  final String extinguisherType;
  final String dangerWarning;
  final List<String> passSteps;

  const FireSafetyGuide({
    required this.title,
    required this.fireClass,
    required this.extinguisherType,
    required this.dangerWarning,
    required this.passSteps,
  });

  static const List<FireSafetyGuide> indianNbcGuides = [
    FireSafetyGuide(
      title: 'Class A: Solid Combustibles (Wood, Paper, Clothes)',
      fireClass: 'Class A',
      extinguisherType: 'Water (APW) / ABC Dry Powder',
      dangerWarning: 'Ensure embers are completely quenched with water.',
      passSteps: [
        'P: Pull the safety pin from the handle.',
        'A: Aim the nozzle at the base of the fire (not flames).',
        'S: Squeeze the lever slowly and evenly.',
        'S: Sweep side to side covering the burning area.',
      ],
    ),
    FireSafetyGuide(
      title: 'Class B & Electrical: Liquids & Live Equipment',
      fireClass: 'Class B / Electrical',
      extinguisherType: 'Carbon Dioxide (CO₂) / ABC Dry Powder',
      dangerWarning: 'NEVER USE WATER ON LIVE ELECTRICAL EQUIPMENT (Risk of fatal electrocution).',
      passSteps: [
        'Isolate main electrical breaker immediately if accessible.',
        'Discharge CO₂ horn aiming at base of flame.',
        'Avoid touching CO₂ horn with bare hands (frostbite hazard).',
      ],
    ),
    FireSafetyGuide(
      title: 'Class C: LPG / CNG Cylinder & Pipeline Leaks',
      fireClass: 'Class C',
      extinguisherType: 'Dry Chemical Powder (DCP) / Wet Jute Bag',
      dangerWarning: 'NEVER OPERATE ELECTRICAL SWITCHES OR LIGHTERS. Sparks ignite vapor cloud explosions.',
      passSteps: [
        'Turn off regulator valve clockwise immediately.',
        'Cover cylinder head with a thick, soaking-wet jute cloth or cotton blanket to cut oxygen.',
        'Open all doors and windows for natural cross-ventilation. Evacuate outdoors.',
      ],
    ),
  ];
}

class ChemicalDisasterProtocol {
  final String chemicalName;
  final String typicalSource;
  final String odorIdentifier;
  final String primarySop;
  final String windEvacuationDirective;

  const ChemicalDisasterProtocol({
    required this.chemicalName,
    required this.typicalSource,
    required this.odorIdentifier,
    required this.primarySop,
    required this.windEvacuationDirective,
  });

  static const List<ChemicalDisasterProtocol> protocols = [
    ChemicalDisasterProtocol(
      chemicalName: 'LPG / Methane Gas (Heavier than Air)',
      typicalSource: 'Domestic Cylinder / Commercial Kitchen / Pipeline',
      odorIdentifier: 'Rotten eggs / Ethyl Mercaptan stench',
      primarySop: 'Vapors pool near ground and floors. Ventilate horizontally, do not switch lights on/off, evacuate.',
      windEvacuationDirective: 'Move away laterally from low-lying drains and basements.',
    ),
    ChemicalDisasterProtocol(
      chemicalName: 'Ammonia (NH₃)',
      typicalSource: 'Cold Storage / Fertilizer Plant / Ice Factory',
      odorIdentifier: 'Sharp pungent choking smell',
      primarySop: 'Ammonia is highly soluble in water. Place a wet handkerchief over nose and eyes immediately.',
      windEvacuationDirective: 'EVACUATE CROSSWIND (perpendicular to wind). Do not run in the direction of the wind plume.',
    ),
    ChemicalDisasterProtocol(
      chemicalName: 'Chlorine (Cl₂)',
      typicalSource: 'Water Treatment Plants / Chemical Industry',
      odorIdentifier: 'Suffocating bleach-like odor with greenish-yellow gas',
      primarySop: 'Gas is heavier than air. Climb to higher floors or roof. Cover nose with wet cloth.',
      windEvacuationDirective: 'Move UPWIND and to elevated terrain.',
    ),
  ];
}
