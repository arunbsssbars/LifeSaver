/// Loop 151: Grain Silo & Granular Media Engulfment Extrication Model
/// Aligned with NDMA Agricultural Safety, OSHA 1910.272 & FCI Bulk Handling Standards.

class GrainSiloEngulfment {
  final double victimSubmergedDepthMeters; // Depth of grain/sand around casualty
  final String grainType; // Wheat, Paddy, Corn, Sand
  final bool isDischargeAugerTurnedOff;
  final bool hasRescueCofferdamShieldInserted;
  final int victimAge;

  const GrainSiloEngulfment({
    required this.victimSubmergedDepthMeters,
    required this.grainType,
    required this.isDischargeAugerTurnedOff,
    required this.hasRescueCofferdamShieldInserted,
    required this.victimAge,
  });

  /// Friction force of grain on human body (Newtons)
  /// Waist-deep engulfment (~0.9m) requires > 1,800 N (400 lbs) of pull force — pulls body apart if pulled by rope!
  /// Chest-deep (~1.3m) requires > 3,500 N (800 lbs).
  double get estimatedFrictionForceNewtons {
    if (victimSubmergedDepthMeters <= 0.3) {
      return 250.0;
    } else if (victimSubmergedDepthMeters <= 0.8) {
      return 1800.0; // Waist deep
    } else if (victimSubmergedDepthMeters <= 1.3) {
      return 3500.0; // Chest deep
    } else {
      return 5000.0; // Fully submerged
    }
  }

  /// Can casualty be pulled out directly by a rescuer's arms or rope harness without crushing limbs?
  bool get canPullDirectlyWithoutCofferdam => victimSubmergedDepthMeters <= 0.3;

  /// Tactical Silo Extrication Sequence
  String get tacticalExtricationSequence {
    if (!isDischargeAugerTurnedOff) {
      return 'CRITICAL PRIORITY: TURN OFF & LOCK OUT ALL BOTTOM AUGER UNLOADERS IMMEDIATELY! Flowing grain acts as quicksand engulfing a human in 4-6 seconds.';
    }
    if (!hasRescueCofferdamShieldInserted) {
      return 'DO NOT PULL CASUALTY WITH ROPE (Friction force is ${estimatedFrictionForceNewtons.toStringAsFixed(0)} N, will dislocate spine)! Insert curved aluminum grain rescue shield panels / barrels around casualty.';
    }
    return 'Shield locked around victim. Use grain vacuum auger or buckets to scoop out grain within the shield tube until legs are free, then lift safely.';
  }

  /// Airway Protection Directive
  String get airwayProtectionDirective =>
      'Fit high-efficiency particulate respirator or positive-pressure oxygen mask to casualty immediately to prevent grain dust inhalation and mechanical suffocation.';
}
