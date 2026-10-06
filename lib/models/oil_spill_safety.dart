/// Model representing Indian Coast Guard National Oil Spill Disaster Contingency Plan (NOS-DCP).
enum OilSpillTierCategory {
  tier1(
    tierName: 'Tier 1 (< 700 Metric Tons)',
    responsibility: 'Port / Facility Operator Local Response Equipment (Booms & Skimmers)',
    colorValue: 0xFFFBBF24,
  ),
  tier2(
    tierName: 'Tier 2 (700 – 10,000 Metric Tons)',
    responsibility: 'Regional Indian Coast Guard Response with Mutual Aid Partners',
    colorValue: 0xFFF97316,
  ),
  tier3(
    tierName: 'Tier 3 (> 10,000 Metric Tons / Catastrophic Tanker Breach)',
    responsibility: 'National Emergency Response led by Director General Indian Coast Guard & International Aid',
    colorValue: 0xFFEF4444,
  );

  final String tierName;
  final String responsibility;
  final int colorValue;

  const OilSpillTierCategory({
    required this.tierName,
    required this.responsibility,
    required this.colorValue,
  });
}

class OilSpillResponseCalculator {
  /// Evaluates spill tier based on spill mass in metric tons
  static OilSpillTierCategory evaluateTier(double spillMetricTons) {
    if (spillMetricTons > 10000.0) return OilSpillTierCategory.tier3;
    if (spillMetricTons >= 700.0) return OilSpillTierCategory.tier2;
    return OilSpillTierCategory.tier1;
  }

  /// Calculates containment boom length in meters required to encircle slick
  /// Boom Length = 3.5 * sqrt(Area in sq meters)
  static double calculateBoomLengthMeters({required double slickRadiusMeters}) {
    return (2.0 * 3.14159 * slickRadiusMeters) * 1.3; // 30% overlap reserve
  }
}
