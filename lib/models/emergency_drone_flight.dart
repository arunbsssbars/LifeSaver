/// Model representing DGCA / MoCA Emergency Drone Green Zone Flight Corridor & Medical Airdrops.
class EmergencyDroneFlightPlan {
  final String flightId;
  final String destinationLocation;
  final double flightDistanceKm;
  final double payloadWeightKg; // max 5kg for emergency quadcopters
  final double droneCruisingSpeedKmh;
  final double currentBatteryPercentage;

  const EmergencyDroneFlightPlan({
    required this.flightId,
    required this.destinationLocation,
    required this.flightDistanceKm,
    required this.payloadWeightKg,
    required this.droneCruisingSpeedKmh,
    required this.currentBatteryPercentage,
  });

  /// Flight duration in minutes
  double get estimatedFlightMinutes => (flightDistanceKm / droneCruisingSpeedKmh) * 60.0;

  /// Required battery consumption percentage (approx 2.5% per km with full payload)
  double get estimatedBatteryUsagePercent => flightDistanceKm * 2.5;

  /// True if drone has sufficient battery reserve to complete round-trip return to base
  bool get hasSufficientBatteryForRoundTrip => currentBatteryPercentage >= (estimatedBatteryUsagePercent * 2.2);
}
