/// Model representing DMRC & NFPA 130 Standard for Fixed Guideway Transit and Passenger Rail Systems.
class TunnelEvacuationSafetyAssessment {
  final String tunnelSectionName;
  final double tunnelLengthMeters;
  final double longitudinalVentilationAirVelocityMs; // must exceed 2.5 m/s critical velocity
  final double distanceToNearestCrossPassageMeters; // must be <= 250m
  final bool hasActiveEmergencyLightingAndLoudspeakers;

  const TunnelEvacuationSafetyAssessment({
    required this.tunnelSectionName,
    required this.tunnelLengthMeters,
    required this.longitudinalVentilationAirVelocityMs,
    required this.distanceToNearestCrossPassageMeters,
    required this.hasActiveEmergencyLightingAndLoudspeakers,
  });

  /// True if forced ventilation prevents deadly smoke backlayering
  bool get isSmokeBacklayeringPrevented => longitudinalVentilationAirVelocityMs >= 2.5;

  /// True if cross-passage egress spacing meets statutory life safety requirements (< 250m)
  bool get isEgressSpacingCompliant => distanceToNearestCrossPassageMeters <= 250.0;
}
