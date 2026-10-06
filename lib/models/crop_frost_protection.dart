/// Model representing IMD Agromet Advisory Service (AAS) Ground Frost & Cold Injury Protection.
enum CropFrostThreatLevel {
  noFrost(
    label: 'No Frost Hazard',
    minTempC: 8.0,
    colorValue: 0xFF10B981,
  ),
  frostWatch(
    label: 'Frost Watch (4°C – 7°C Clear Night)',
    minTempC: 4.0,
    colorValue: 0xFFFBBF24,
  ),
  groundFrostWarning(
    label: 'Severe Ground Frost (<= 3°C Ground Inversion)',
    minTempC: 0.0,
    colorValue: 0xFFEF4444,
  );

  final String label;
  final double minTempC;
  final int colorValue;

  const CropFrostThreatLevel({
    required this.label,
    required this.minTempC,
    required this.colorValue,
  });
}

class CropFrostSafetyAdvisor {
  /// Evaluates agricultural ground frost risk for Rabi crops (Mustard, Potato, Wheat)
  static CropFrostThreatLevel evaluateFrostRisk({
    required double minimumTemperatureC,
    required double windSpeedKmh,
    required double cloudCoverOctas,
  }) {
    // Frost occurs on calm (< 5 km/h) and clear (< 2 octas) nights when min temp <= 4°C
    final isCalmAndClear = windSpeedKmh <= 6.0 && cloudCoverOctas <= 2.0;

    if (minimumTemperatureC <= 3.0 && isCalmAndClear) {
      return CropFrostThreatLevel.groundFrostWarning;
    } else if (minimumTemperatureC <= 6.0 && isCalmAndClear) {
      return CropFrostThreatLevel.frostWatch;
    }
    return CropFrostThreatLevel.noFrost;
  }

  static const List<String> agronomicMitigationSteps = [
    'Apply light evening sprinkler irrigation: Water releases latent heat of fusion (80 cal/g), keeping soil surface ~2°C warmer.',
    'Create controlled smoke smudge pots (*Dhuan*) along windward borders using dry leaves and biomass.',
    'Cover sensitive vegetable seedbeds with straw mulch or plastic polythene tunnels.',
    'Spray 0.1% Thiourea or 0.1% Sulphuric Acid solution on standing mustard/potato crops to enhance cellular cold tolerance.',
  ];
}
