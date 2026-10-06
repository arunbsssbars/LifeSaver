/// Model representing an Offline Evacuation Waypoint and Dry-Path Route calculation
class EvacuationWaypoint {
  final String label;
  final double latitude;
  final double longitude;
  final double elevationMeters;
  final bool isSafeFromFlood;
  final String terrainType;

  const EvacuationWaypoint({
    required this.label,
    required this.latitude,
    required this.longitude,
    required this.elevationMeters,
    required this.isSafeFromFlood,
    required this.terrainType,
  });
}

class EvacuationRouteProfile {
  final String routeName;
  final double totalDistanceKm;
  final int estimatedWalkingMinutes;
  final double minimumElevationAlongPath;
  final bool crossesInundatedZone;
  final List<EvacuationWaypoint> checkpoints;

  const EvacuationRouteProfile({
    required this.routeName,
    required this.totalDistanceKm,
    required this.estimatedWalkingMinutes,
    required this.minimumElevationAlongPath,
    required this.crossesInundatedZone,
    required this.checkpoints,
  });
}
