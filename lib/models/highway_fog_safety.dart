/// Model representing Ministry of Road Transport and Highways (MoRTH) & NHAI
/// Winter Dense Fog Expressway Multi-Vehicle Pileup Prevention Standards.
enum FogIntensityBand {
  clear(
    label: 'Clear Visibility (>1000m)',
    maxSafeSpeedKmh: 100.0,
    colorValue: 0xFF10B981,
  ),
  shallowFog(
    label: 'Shallow Fog (500m - 1000m)',
    maxSafeSpeedKmh: 70.0,
    colorValue: 0xFF84CC16,
  ),
  moderateFog(
    label: 'Moderate Fog (200m - 500m)',
    maxSafeSpeedKmh: 50.0,
    colorValue: 0xFFFBBF24,
  ),
  denseFog(
    label: 'Dense Fog (50m - 200m)',
    maxSafeSpeedKmh: 30.0,
    colorValue: 0xFFF97316,
  ),
  veryDenseFog(
    label: 'Very Dense Zero-Visibility Fog (<50m)',
    maxSafeSpeedKmh: 15.0,
    colorValue: 0xFFEF4444,
  );

  final String label;
  final double maxSafeSpeedKmh;
  final int colorValue;

  const FogIntensityBand({
    required this.label,
    required this.maxSafeSpeedKmh,
    required this.colorValue,
  });
}

class HighwayFogSafetyAdvisor {
  final double visibilityDistanceMeters;
  final FogIntensityBand intensity;
  final double recommendedSpeedKmh;
  final double minimumSafeFollowingDistanceMeters;
  final List<String> expresswayDirectives;

  const HighwayFogSafetyAdvisor({
    required this.visibilityDistanceMeters,
    required this.intensity,
    required this.recommendedSpeedKmh,
    required this.minimumSafeFollowingDistanceMeters,
    required this.expresswayDirectives,
  });

  /// Evaluates highway fog safety parameters
  static HighwayFogSafetyAdvisor evaluate({required double visibilityMeters}) {
    FogIntensityBand band;
    if (visibilityMeters < 50.0) {
      band = FogIntensityBand.veryDenseFog;
    } else if (visibilityMeters <= 200.0) {
      band = FogIntensityBand.denseFog;
    } else if (visibilityMeters <= 500.0) {
      band = FogIntensityBand.moderateFog;
    } else if (visibilityMeters <= 1000.0) {
      band = FogIntensityBand.shallowFog;
    } else {
      band = FogIntensityBand.clear;
    }

    // Following distance on wet/cold tarmac: 4-second rule
    final speedMs = (band.maxSafeSpeedKmh * 1000.0) / 3600.0;
    final followingDistance = (speedMs * 4.0).clamp(20.0, 150.0);

    final directives = <String>[];
    if (band == FogIntensityBand.veryDenseFog || band == FogIntensityBand.denseFog) {
      directives.add('🚨 DENSE FOG ADVISORY: Turn on low-beam headlights and dedicated yellow fog lamps.');
      directives.add('NEVER use high-beam lights (high-beams reflect off water droplets creating a blinding white glare).');
      directives.add('Follow the painted yellow/white continuous lane boundary markers on the left shoulder.');
      directives.add('DO NOT stop abruptly in the middle of expressway carriageways. Pull completely off into toll/rest plazas.');
      directives.add('Listen for audible road rumblers and engine sounds at crossroad intersections.');
    } else {
      directives.add('Maintain statutory headway spacing and drive within posted expressway speed limits.');
    }

    return HighwayFogSafetyAdvisor(
      visibilityDistanceMeters: visibilityMeters,
      intensity: band,
      recommendedSpeedKmh: band.maxSafeSpeedKmh,
      minimumSafeFollowingDistanceMeters: followingDistance,
      expresswayDirectives: directives,
    );
  }
}
