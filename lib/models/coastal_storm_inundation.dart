/// Model representing INCOIS / MoES Coastal Storm Inundation & Extreme Sea Surge Models.
class CoastalStormInundationAssessment {
  final double astronomicalTideHeightMeters;
  final double meteorologicalStormSurgeMeters;
  final double waveSetupMeters;
  final double coastalElevationAboveMslMeters;
  final double distanceFromShorelineKm;

  const CoastalStormInundationAssessment({
    required this.astronomicalTideHeightMeters,
    required this.meteorologicalStormSurgeMeters,
    required this.waveSetupMeters,
    required this.coastalElevationAboveMslMeters,
    required this.distanceFromShorelineKm,
  });

  /// Total Water Level (TWL) = Tide + Surge + Wave Setup
  double get totalWaterLevelMeters => astronomicalTideHeightMeters + meteorologicalStormSurgeMeters + waveSetupMeters;

  /// Net Inundation Depth over ground (TWL - Land Elevation)
  double get netInundationDepthMeters => (totalWaterLevelMeters - coastalElevationAboveMslMeters).clamp(0.0, 15.0);

  /// True if land will be submerged by sea surge
  bool get isSubmerged => totalWaterLevelMeters > coastalElevationAboveMslMeters;

  /// Evaluates statutory coastal evacuation directives
  List<String> get evacuationDirectives {
    final directives = <String>[];
    if (isSubmerged) {
      directives.add('🚨 COASTAL INUNDATION IMMINENT: Projected sea flood depth ${netInundationDepthMeters.toStringAsFixed(1)}m over ground.');
      directives.add('Evacuate inland past the $distanceFromShorelineKm km buffer zone to ground at least ${(totalWaterLevelMeters + 3.0).toStringAsFixed(1)}m above MSL.');
      directives.add('Disconnect electrical substations in tidal floodplains to prevent saltwater short-circuit explosions.');
    } else {
      directives.add('Land elevation is currently above projected storm surge high-water mark.');
      directives.add('Monitor INCOIS coastal tide gauge telemetry for astronomical spring tide alignment.');
    }
    return directives;
  }
}
