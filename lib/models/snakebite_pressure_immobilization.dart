/// Loop 152: Post-Disaster Snakebite Envenomation & Pressure Immobilization Model
/// Aligned with National Snakebite Management Protocol (MoHFW), ICMR & WHO Guidelines.

enum SnakeType {
  bigFourViper, // Russell's Viper, Saw-scaled Viper (Vasculo-toxic / Hemo-toxic)
  bigFourElapid, // Spectacled Cobra, Common Krait (Neuro-toxic)
  unknownSpecies,
}

class SnakebitePressureImmobilization {
  final SnakeType snakeType;
  final String biteLimbLocation; // 'Arm', 'Leg', 'Hand', 'Foot'
  final double minutesSinceBite;
  final bool has20MinuteClottingFailure; // 20WBCT failed (blood did not clot after 20 mins)
  final bool isPtosisOrParalysisPresent; // Neurotoxic signs
  final bool isBiteSiteWashedOrCut;

  const SnakebitePressureImmobilization({
    required this.snakeType,
    required this.biteLimbLocation,
    required this.minutesSinceBite,
    required this.has20MinuteClottingFailure,
    required this.isPtosisOrParalysisPresent,
    required this.isBiteSiteWashedOrCut,
  });

  /// Recommended Anti-Snake Venom (ASV) Initial Loading Dose (Vials)
  int get recommendedAsvInitialVials {
    if (has20MinuteClottingFailure || isPtosisOrParalysisPresent) {
      return 10; // Standard 10 vials polyvalent ASV infusion over 1 hour
    }
    return 0; // Monitor hourly if asymptomatic
  }

  /// Emergency First Aid Protocol (DOs and DONTs)
  String get firstAidTacticalProtocol {
    if (snakeType == SnakeType.bigFourElapid) {
      return 'NEUROTOXIC ELAPID: Apply broad elastic crepe bandage at 50-70 mmHg (firm like an ankle sprain) from fingers/toes up to armpit/groin with rigid splint. Keep limb at heart level and transport immediately!';
    } else {
      return 'VIPERINE / GENERAL BITE: Immobilize limb completely with rigid splint and sling. DO NOT APPLY TIGHT PRESSURE BANDAGE if swelling/bleeding is severe. Rush to hospital with Polyvalent ASV.';
    }
  }

  /// Critical Life-Saving Prohibitions (MoHFW / WHO Standard)
  List<String> get criticalProhibitions => const [
        'NEVER cut, incise, or slash the bite wound.',
        'NEVER suck out venom with mouth or commercial suction devices.',
        'NEVER apply tight arterial tourniquets (causes limb gangrene & amputation).',
        'NEVER apply ice, herbal pastes, potassium permanganate, or electric shock.',
        'DO NOT allow victim to walk or run; physical exertion accelerates lymphatic venom spread.',
      ];
}
