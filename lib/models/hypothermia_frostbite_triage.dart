import 'dart:math' as math;

/// Model representing ITBP & NDMA High-Altitude Cold Wave Hypothermia & Frostbite Severity Triage.
enum FrostbiteGrade {
  frostnip('Frostnip (Grade 0 - Superficial numbness, blanching, reversible with direct warm hand contact)'),
  grade1('Grade 1 (Superficial - Erythema, edema, no blisters, full recovery)'),
  grade2('Grade 2 (Partial Thickness - Clear blister fluid, severe pain, intact skin sensation)'),
  grade3('Grade 3 (Deep - Hemorrhagic dark blisters, necrosis, irreversible dermal loss)'),
  grade4('Grade 4 (Full Thickness - Bone/muscle gangrene, total mummification, amputation required)');

  final String description;
  const FrostbiteGrade(this.description);
}

class HypothermiaFrostbiteAssessment {
  /// Computes Wind Chill Equivalent Temperature in °C (JAG/TI formula adopted by IMD)
  /// Twc = 13.12 + 0.6215*T - 11.37*(V^0.16) + 0.3965*T*(V^0.16)
  static double calculateWindChillTemperatureC({
    required double airTemperatureC,
    required double windSpeedKmh,
  }) {
    if (windSpeedKmh < 4.8 || airTemperatureC > 10.0) return airTemperatureC;
    final vPow = math.pow(windSpeedKmh, 0.16);
    return 13.12 + (0.6215 * airTemperatureC) - (11.37 * vPow) + (0.3965 * airTemperatureC * vPow);
  }

  static const List<String> fieldFrostbiteRewarmingProtocols = [
    'DO NOT rub frostbitten hands or feet with snow or dry fabric (ice crystals in tissue cause catastrophic cellular shredding).',
    'DO NOT rewarm if there is ANY risk of refreezing before reaching hospital (refreezing causes 100% tissue loss).',
    'RAPID REWARMING: Immerse affected limbs in warm water bath maintained precisely between 37°C and 40°C for 20–30 minutes until skin flushes soft and red.',
    'Administer oral Ibuprofen (400 mg) to prevent arachidonic acid inflammatory thrombosis and tissue necrosis.',
    'Hypothermia core warming: Wrap torso with active chemical warming pads on groin, axillae, and chest; insulate head with woolen cap.',
  ];
}
