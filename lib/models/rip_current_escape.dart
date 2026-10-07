/// Loop 143: Rip Current Escape & Surf Zone Hydrodynamic Vector Model
/// Aligned with INCOIS Coastal Hazards & Rashtriya Life Saving Society (RLSS India).

class RipCurrentEscape {
  final double ripCurrentSpeedMps; // 0.5 to 3.0 m/s
  final double ripChannelWidthMeters; // Typically 15-40 meters
  final double swimmerVelocityMps; // Average human swim velocity ~ 0.6 - 1.0 m/s
  final bool isTreadingWaterOrFloating;
  final double distanceOffshoreMeters;

  const RipCurrentEscape({
    required this.ripCurrentSpeedMps,
    required this.ripChannelWidthMeters,
    required this.swimmerVelocityMps,
    required this.isTreadingWaterOrFloating,
    required this.distanceOffshoreMeters,
  });

  /// Can an average human swim against this rip current straight back to shore?
  /// Human sprint speed in water is < 1.0 m/s. Attempting to swim against > 1.2 m/s causes fatal exhaustion.
  bool get isDirectSwimToShoreImpossible => ripCurrentSpeedMps >= swimmerVelocityMps;

  /// Escape swim angle relative to shoreline
  /// Swimming 90 degrees parallel to the beach quickly exits the narrow rip neck.
  double get recommendedEscapeSwimAngleDegrees => 90.0;

  /// Estimated time to swim out of the rip current channel sideways (seconds)
  double get timeToEscapeChannelSeconds {
    final effectiveCrossSpeed = swimmerVelocityMps > 0.3 ? swimmerVelocityMps : 0.5;
    return (ripChannelWidthMeters / 2.0) / effectiveCrossSpeed;
  }

  /// Tactical survival protocol
  String get survivalProtocol {
    if (ripCurrentSpeedMps > 1.8) {
      return 'EXTREME RIP VELOCITY (${ripCurrentSpeedMps.toStringAsFixed(1)} m/s): DO NOT SWIM AGAINST CURRENT! Float on your back to conserve energy until rip dissipates past breaking waves, then swim parallel to shore.';
    } else {
      return 'STANDARD RIP CURRENT: Turn 90° and swim PARALLEL to the beach across the current for ~${timeToEscapeChannelSeconds.toStringAsFixed(0)}s to exit the channel, then angle diagonally toward breaking waves to body-surf ashore.';
    }
  }

  /// Emergency signal instruction
  String get emergencySignalInstruction =>
      'Wave one arm calmly in the air and shout for lifeguard assistance while maintaining horizontal back-float buoyancy.';
}
