/// Loop 146: Domestic LPG Kitchen Leak & Cylinder Fire Containment Model
/// Aligned with PESO Domestic LPG Safety Rules, NFPA 58 & NBC 2016 Part 4.

class DomesticLpgLeakSafety {
  final double estimatedLeakVolumePercent; // Concentration % in room (LEL is 2.1% to UEL 9.5%)
  final bool isRegulatorValveOnFire;
  final bool areElectricalSwitchesTouched;
  final bool isExhaustFanTurnedOn;
  final double roomFloorAreaM2;

  const DomesticLpgLeakSafety({
    required this.estimatedLeakVolumePercent,
    required this.isRegulatorValveOnFire,
    required this.areElectricalSwitchesTouched,
    required this.isExhaustFanTurnedOn,
    required this.roomFloorAreaM2,
  });

  /// LPG is heavier than air (Relative vapor density ~ 1.8x). Settles along floor & drains.
  static const double lpgVaporDensity = 1.8;
  static const double lowerExplosiveLimitLel = 2.1;
  static const double upperExplosiveLimitUel = 9.5;

  /// Is room in explosive vapor cloud range?
  bool get isExplosiveMixturePresent =>
      estimatedLeakVolumePercent >= lowerExplosiveLimitLel &&
      estimatedLeakVolumePercent <= upperExplosiveLimitUel;

  /// Cylinder BLEVE explosion hazard present if flame impinges on vapor space of cylinder
  bool get isCylinderBleveRiskHigh => isRegulatorValveOnFire;

  /// Primary tactical response for domestic kitchen incident
  String get primaryTacticalResponse {
    if (isRegulatorValveOnFire) {
      return 'BURNING REGULATOR FIRE: DO NOT PANIC! Take a large thick cotton/jute gunny bag or bedsheet soaked dripping wet in water, wrap it swiftly from behind to smother the flame, and immediately turn the regulator switch OFF.';
    } else if (isExplosiveMixturePresent) {
      return 'EXPLOSIVE LPG GAS DETECTED (Vapor heavier than air, pooling on floor): DO NOT operate any electrical switches (No lights, No exhaust fan)! Open all low-level doors and windows to disperse gas outward.';
    } else {
      return 'SMELL OF GAS: Turn off regulator knob clockwise, fit the safety cap on cylinder, open doors and windows, and call the 24x7 Emergency LPG Hotline (1906).';
    }
  }

  /// Critical safety prohibition
  String get criticalSafetyProhibition =>
      'STRICT WARNING: Never light a match or turn on/off ANY electrical switch or phone flashlight in a gas-leaking kitchen; the contact arcing will ignite the heavy vapor cloud!';
}
