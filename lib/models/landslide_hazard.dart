/// Model representing Geological Survey of India (GSI) Landslide Hazard Assessment
/// and Slope Stability Early Warning based on National Landslide Susceptibility Mapping (NLSM).
enum LandslideHazardZone {
  veryHighRisk(
    name: 'Very High Risk Zone (GSI Zone I)',
    description: 'Steep escarpments (>45°), unstable slopes, active debris flows in Himalayan / Western Ghats belts.',
    colorValue: 0xFFEF4444,
  ),
  highRisk(
    name: 'High Risk Zone (GSI Zone II)',
    description: 'Moderate-steep slopes (30°-45°), loose overburden, high rainfall triggering history.',
    colorValue: 0xFFF97316,
  ),
  moderateRisk(
    name: 'Moderate Risk Zone (GSI Zone III)',
    description: 'Gentle slopes (15°-30°), dense vegetation cover, stable rock formations.',
    colorValue: 0xFFFBBF24,
  ),
  lowRisk(
    name: 'Low Risk Zone (GSI Zone IV)',
    description: 'Flat alluvial plains, plateau interiors, low topographic gradient (<15°).',
    colorValue: 0xFF10B981,
  );

  final String name;
  final String description;
  final int colorValue;

  const LandslideHazardZone({
    required this.name,
    required this.description,
    required this.colorValue,
  });
}

class LandslideRiskAssessment {
  final LandslideHazardZone hazardZone;
  final double antecedentRainfallMm; // 72-hour cumulative rain
  final double currentRainfallMmPerHour;
  final double slopeGradientDegrees;
  final double soilSaturationIndex; // 0.0 to 1.0
  final bool isTriggerImminent;
  final List<String> warningIndicators;
  final List<String> evacuationDirectives;

  const LandslideRiskAssessment({
    required this.hazardZone,
    required this.antecedentRainfallMm,
    required this.currentRainfallMmPerHour,
    required this.slopeGradientDegrees,
    required this.soilSaturationIndex,
    required this.isTriggerImminent,
    required this.warningIndicators,
    required this.evacuationDirectives,
  });

  /// Evaluates GSI Landslide Risk based on terrain slope, antecedent rainfall, and rainfall intensity
  static LandslideRiskAssessment evaluate({
    required double latitude,
    required double longitude,
    required String regionName,
    required double antecedentRainfallMm,
    required double currentRainfallMmPerHour,
  }) {
    // Determine slope gradient and baseline GSI zone based on Indian geography
    // Himalayan belt: Uttarakhand, Himachal, Sikkim, NE India, Western Ghats (Wayanad, Nilgiris)
    final isHimalayan = (latitude >= 26.0 && latitude <= 36.0 && longitude >= 73.0 && longitude <= 97.0) &&
        (regionName.toLowerCase().contains('uttarakhand') ||
            regionName.toLowerCase().contains('himachal') ||
            regionName.toLowerCase().contains('sikkim') ||
            regionName.toLowerCase().contains('chamoli') ||
            regionName.toLowerCase().contains('uttarkashi') ||
            regionName.toLowerCase().contains('shimla') ||
            regionName.toLowerCase().contains('nepal') ||
            regionName.toLowerCase().contains('bagmati') ||
            regionName.toLowerCase().contains('guwahati') ||
            regionName.toLowerCase().contains('assam'));

    final isWesternGhats = (latitude >= 8.0 && latitude <= 21.0 && longitude >= 73.0 && longitude <= 77.5) &&
        (regionName.toLowerCase().contains('kerala') ||
            regionName.toLowerCase().contains('wayanad') ||
            regionName.toLowerCase().contains('munnar') ||
            regionName.toLowerCase().contains('nilgiri') ||
            regionName.toLowerCase().contains('periyar') ||
            regionName.toLowerCase().contains('coorg') ||
            regionName.toLowerCase().contains('mahabaleshwar'));

    double slopeDegrees = 5.0; // default flat plains
    LandslideHazardZone zone = LandslideHazardZone.lowRisk;

    if (isHimalayan) {
      slopeDegrees = 42.0;
      zone = LandslideHazardZone.veryHighRisk;
    } else if (isWesternGhats) {
      slopeDegrees = 34.0;
      zone = LandslideHazardZone.highRisk;
    } else if (regionName.toLowerCase().contains('patna') || regionName.toLowerCase().contains('noida') || regionName.toLowerCase().contains('delhi')) {
      slopeDegrees = 2.0;
      zone = LandslideHazardZone.lowRisk;
    }

    // Soil saturation index calculation (antecedent rainfall saturation curve)
    // 150mm over 72h approaches 100% saturation in hill cut soils
    final saturation = (antecedentRainfallMm / 150.0).clamp(0.0, 1.0);

    // GSI Landslide trigger threshold:
    // When 72h rain > 100mm AND current rain > 15mm/h on slopes > 30°
    final isImminent = (zone == LandslideHazardZone.veryHighRisk || zone == LandslideHazardZone.highRisk) &&
        (antecedentRainfallMm >= 100.0 || currentRainfallMmPerHour >= 20.0 || saturation >= 0.85);

    final indicators = <String>[];
    if (saturation >= 0.8) indicators.add('Soil pore water pressure critical (Saturation: ${(saturation * 100).toStringAsFixed(0)}%)');
    if (slopeDegrees >= 30.0) indicators.add('Steep terrain angle ($slopeDegrees°) vulnerable to shear failure');
    if (currentRainfallMmPerHour >= 15.0) indicators.add('High hourly precipitation ($currentRainfallMmPerHour mm/h) accelerating slope runoff');
    if (indicators.isEmpty) indicators.add('Terrain slope and soil moisture within stable limits');

    final directives = <String>[];
    if (isImminent) {
      directives.add('🚨 EVACUATE IMMEDIATELY: Move perpendicular to the landslide path, never run downhill.');
      directives.add('Listen for unusual sounds like trees cracking, boulders knocking, or rumbling earth.');
      directives.add('Stay away from river valleys, drainage channels, and hill escarpments.');
      directives.add('Report tension cracks appearing in roads or building foundations to DEOC 1077.');
    } else {
      directives.add('Monitor local drainage channels for sudden muddying of clear stream waters.');
      directives.add('Ensure natural slope runoff weep holes in retaining walls are unblocked.');
      directives.add('Identify high-ground evacuation shelters away from mountain cut banks.');
    }

    return LandslideRiskAssessment(
      hazardZone: zone,
      antecedentRainfallMm: antecedentRainfallMm,
      currentRainfallMmPerHour: currentRainfallMmPerHour,
      slopeGradientDegrees: slopeDegrees,
      soilSaturationIndex: saturation,
      isTriggerImminent: isImminent,
      warningIndicators: indicators,
      evacuationDirectives: directives,
    );
  }
}
