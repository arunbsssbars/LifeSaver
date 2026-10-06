/// Model representing Ministry of Agriculture & Farmers Welfare (MoA&FW) & IMD
/// Standardized Precipitation Index (SPI) and Agricultural Drought Severity Standards.
enum DroughtSeverityClass {
  extremelyWet('Extremely Wet (SPI >= +2.0)', 0xFF0284C7),
  moderatelyWet('Moderately Wet (SPI +1.0 to +1.99)', 0xFF38BDF8),
  nearNormal('Near Normal Precipitation (SPI -0.99 to +0.99)', 0xFF10B981),
  moderateDrought('Moderate Drought (SPI -1.0 to -1.49)', 0xFFFBBF24),
  severeDrought('Severe Drought (SPI -1.5 to -1.99)', 0xFFF97316),
  extremeDrought('Extreme / Catastrophic Drought (SPI <= -2.0)', 0xFFEF4444);

  final String label;
  final int colorValue;
  const DroughtSeverityClass(this.label, this.colorValue);
}

class DroughtAssessmentCalculator {
  /// Evaluates SPI value category
  static DroughtSeverityClass evaluateSpi(double spiValue) {
    if (spiValue >= 2.0) return DroughtSeverityClass.extremelyWet;
    if (spiValue >= 1.0) return DroughtSeverityClass.moderatelyWet;
    if (spiValue >= -0.99) return DroughtSeverityClass.nearNormal;
    if (spiValue >= -1.49) return DroughtSeverityClass.moderateDrought;
    if (spiValue >= -1.99) return DroughtSeverityClass.severeDrought;
    return DroughtSeverityClass.extremeDrought;
  }

  static List<String> getDroughtMitigationDirectives(DroughtSeverityClass severity) {
    switch (severity) {
      case DroughtSeverityClass.extremeDrought:
      case DroughtSeverityClass.severeDrought:
        return [
          '🚨 SEVERE DROUGHT DECLARATION: Deploy water tankers to water-stressed villages and cattle camps.',
          'Release emergency irrigation water from upstream reservoirs for standing life-saving crops.',
          'Open subsidized cattle fodder depots (Pashu Chara Shivir) across affected Taluks.',
          'Promote micro-irrigation (drip/sprinkler) and ban water-intensive non-essential commercial extraction.',
        ];
      case DroughtSeverityClass.moderateDrought:
        return [
          'Monitor groundwater levels and promote rainwater harvesting check dam repair.',
          'Encourage drought-tolerant crops (Millets / Shri Anna, Pulses, Sorghum).',
        ];
      default:
        return [
          'Precipitation and soil moisture levels within nominal ranges for agricultural cycle.',
        ];
    }
  }
}
