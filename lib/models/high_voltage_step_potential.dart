/// Loop 149: Snapped High-Voltage Power Line Ground Gradient & Step Potential Model
/// Aligned with Central Electricity Authority (CEA) Safety Regulations & IEEE 80 Standards.

class HighVoltageStepPotential {
  final double lineVoltageKv; // e.g. 11 kV, 33 kV, 66 kV
  final double distanceToFallenConductorMeters;
  final bool isGroundWetOrFlooded;
  final double rescuerFootSeparationMeters; // Stride distance between feet

  const HighVoltageStepPotential({
    required this.lineVoltageKv,
    required this.distanceToFallenConductorMeters,
    required this.isGroundWetOrFlooded,
    required this.rescuerFootSeparationMeters,
  });

  /// Safe isolation radius in meters (10m minimum for 11-33kV, 15m for wet ground)
  double get minimumSafeRadiusMeters => isGroundWetOrFlooded ? 15.0 : 10.0;

  /// Is citizen/rescuer inside the lethal electrical step-potential gradient circle?
  bool get isInsideDangerZone => distanceToFallenConductorMeters < minimumSafeRadiusMeters;

  /// Relative Step Potential Delta V: Proportional to Voltage * (1/r1 - 1/r2) * Foot Separation
  /// If feet are apart (e.g. 0.8m), fatal current passes through legs across heart.
  double get estimatedStepPotentialVolts {
    if (!isInsideDangerZone) return 0.0;
    final r = distanceToFallenConductorMeters > 0.5 ? distanceToFallenConductorMeters : 0.5;
    final soilFactor = isGroundWetOrFlooded ? 1.8 : 1.0;
    final voltRatio = (lineVoltageKv * 1000.0 * 0.15) / r;
    return voltRatio * (rescuerFootSeparationMeters / 0.8) * soilFactor;
  }

  /// Tactical evacuation gait instruction
  String get tacticalEscapeGait {
    if (isInsideDangerZone) {
      return 'CRITICAL ELECTROCUTION HAZARD: DO NOT RUN OR TAKE STRIDES! Keep feet firmly pressed together and BUNNY-HOP or SLOWLY SHUFFLE your feet without ever lifting them off the ground until at least ${minimumSafeRadiusMeters.toStringAsFixed(0)}m away!';
    }
    return 'Clear of danger zone. Maintain perimeter and call State Electricity Board Grid Disconnect (1912).';
  }

  /// Trapped Vehicle Rule
  String get trappedVehicleSafetyRule =>
      'If inside a car with a live wire on top: STAY INSIDE! The rubber tires and metal chassis act as a Faraday cage. Do not step out touching car and ground simultaneously.';
}
