/// Loop 155: Coastal Mudflat & Thixotropic Quicksand Escape Model
/// Aligned with Indian Coast Guard Shore Rescue Protocols & Archimedes Physics.

class QuicksandBuoyancyEscape {
  final double submergedDepthMeters; // Sinking depth (e.g. ankle, knee, waist, chest)
  final double timeToHighTideMinutes; // Approaching tide duration
  final bool isThrashingOrJerkingLegs;
  final bool isLyingBackSupine;

  const QuicksandBuoyancyEscape({
    required this.submergedDepthMeters,
    required this.timeToHighTideMinutes,
    required this.isThrashingOrJerkingLegs,
    required this.isLyingBackSupine,
  });

  /// Density of water-saturated quicksand/mud is ~ 2.0 g/cm3.
  /// Human body density is ~ 1.0 g/cm3.
  /// Physics Law: It is mathematically impossible to sink past waist depth in quicksand IF the body lies flat!
  static const double quicksandDensityGPerCm3 = 2.0;

  /// Force required to pull one trapped foot out straight up (~ 10,000 N, equivalent to lifting a mid-size car)
  /// Direct vertical pull will fracture the femur or dislocate hip.
  double get verticalExtractionSuctionForceNewtons {
    if (submergedDepthMeters < 0.3) return 500.0;
    if (submergedDepthMeters < 0.7) return 4000.0;
    return 10000.0; // Waist/thigh level vacuum suction
  }

  /// Tactical Escape Algorithm (Thixotropic Fluidization)
  String get tacticalEscapeProtocol {
    if (isThrashingOrJerkingLegs) {
      return 'DANGER: STOP THRASHING IMMEDIATELY! Violent movement liquefies sand locally and accelerates sinking while packing sand tightly above feet.';
    }
    if (!isLyingBackSupine) {
      return 'STEP 1: LEAN SLOWLY BACKWARD onto your back to distribute body weight over twice the surface area. The dense mud (2.0 g/cm³) will naturally float your torso!';
    }
    return 'STEP 2: Gently wiggle legs in slow tiny circles to allow water to trickle down along the legs, breaking the vacuum seal. Slowly crawl backward on your back using paddling arm strokes.';
  }

  /// Tidal Inundation Threat Level
  String get tidalThreatAssessment {
    if (timeToHighTideMinutes <= 30.0) {
      return 'IMMINENT DROWNING TIDE: High tide in < 30 mins! Deploy Coast Guard mud-rescue inflatable craft / high-pressure water lance to break suction immediately.';
    }
    return 'Moderate tidal window. Follow self-buoyancy back-float technique or wait for rescue line.';
  }
}
