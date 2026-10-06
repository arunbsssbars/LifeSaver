/// Model representing NDMA Crowd Management Guidelines (Pilgrimages, Ghats, Sports Stadiums)
/// and Fruin's Level of Service (LoS) Crowd Density Asphyxiation Prevention Protocol.
enum CrowdDensityRiskLevel {
  comfortable(
    densityPerSquareMeter: '< 1.5 persons / m²',
    status: 'Comfortable Free Flow',
    description: 'Pedestrians can choose walking speed and bypass others freely.',
    colorValue: 0xFF10B981,
  ),
  restricted(
    densityPerSquareMeter: '1.5 – 3.0 persons / m²',
    status: 'Constrained Crowd Flow',
    description: 'Walking speed restricted; involuntary physical contact with neighbors begins.',
    colorValue: 0xFFFBBF24,
  ),
  criticalDensity(
    densityPerSquareMeter: '3.0 – 5.0 persons / m²',
    status: 'Critical Crush Alert (High Risk)',
    description: 'Individual movement is dictated by surrounding crowd momentum. High risk of localized falling.',
    colorValue: 0xFFF97316,
  ),
  crowdCollapseShockwave(
    densityPerSquareMeter: '> 5.0 persons / m²',
    status: 'Crowd Turbulence / Shockwave Imminent',
    description: 'Compressive asphyxiation hazard! Crowd behaves like a fluid with dangerous shockwaves rippling through.',
    colorValue: 0xFFEF4444,
  );

  final String densityPerSquareMeter;
  final String status;
  final String description;
  final int colorValue;

  const CrowdDensityRiskLevel({
    required this.densityPerSquareMeter,
    required this.status,
    required this.description,
    required this.colorValue,
  });
}

class CrowdSafetyCalculator {
  /// Evaluates crowd density in persons per square meter
  static CrowdDensityRiskLevel evaluateDensity({
    required int totalHeadcount,
    required double areaSquareMeters,
  }) {
    if (areaSquareMeters <= 0) return CrowdDensityRiskLevel.crowdCollapseShockwave;
    final density = totalHeadcount / areaSquareMeters;

    if (density > 5.0) {
      return CrowdDensityRiskLevel.crowdCollapseShockwave;
    } else if (density >= 3.0) {
      return CrowdDensityRiskLevel.criticalDensity;
    } else if (density >= 1.5) {
      return CrowdDensityRiskLevel.restricted;
    }
    return CrowdDensityRiskLevel.comfortable;
  }

  static const List<String> stampedeSurvivalTechniques = [
    'ADOPT THE BOXER STANCE: Keep feet slightly apart, knees bent, and bring your hands up to your chest like a boxer. This creates a 5–10 cm protective breathing pocket to prevent compressive asphyxia.',
    'MOVE WITH THE FLOW: Never fight against crowd pressure or push back violently. Drift diagonally with the surge toward the edges or open side alleys.',
    'STAY ON YOUR FEET: If you drop a mobile phone, bag, or shoe, DO NOT bend down to pick it up.',
    'IF YOU FALL DOWN: Curl into a tight ball on your left side, protect your head with your arms, and avoid lying flat on your stomach or back.',
    'AVOID BARRIERS: Stay away from solid walls, barricades, stairwells, and narrow choke points where compressive pressures exceed 4,000 Newtons.',
  ];
}
