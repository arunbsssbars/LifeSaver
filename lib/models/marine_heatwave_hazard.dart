/// Model representing INCOIS & CMFRI Marine Heatwave and Coral Reef Bleaching Alert System
/// using Degree Heating Weeks (DHW in °C-weeks) and Sea Surface Temperature (SST) anomalies.
enum MarineHeatwaveCategory {
  normal(
    categoryName: 'Nominal Marine State',
    dhwDegreeHeatingWeeks: 0.0,
    impact: 'Sea surface temperatures within seasonal climatological baselines.',
    colorValue: 0xFF10B981,
  ),
  bleachingWatch(
    categoryName: 'Bleaching Watch (DHW: 1 – 4 °C-weeks)',
    dhwDegreeHeatingWeeks: 1.0,
    impact: 'Low thermal stress on coral reefs and coastal fish habitats. Monitoring active.',
    colorValue: 0xFFFBBF24,
  ),
  bleachingWarning(
    categoryName: 'Bleaching Warning (DHW: 4 – 8 °C-weeks)',
    dhwDegreeHeatingWeeks: 4.0,
    impact: 'Significant thermal stress. Widespread coral bleaching and fish migration expected.',
    colorValue: 0xFFF97316,
  ),
  bleachingAlertLevel2(
    categoryName: 'Bleaching Alert Level 2 (DHW > 8 °C-weeks)',
    dhwDegreeHeatingWeeks: 8.0,
    impact: 'Severe, catastrophic thermal stress. Severe multi-species coral mortality and fishery collapse.',
    colorValue: 0xFFEF4444,
  );

  final String categoryName;
  final double dhwDegreeHeatingWeeks;
  final String impact;
  final int colorValue;

  const MarineHeatwaveCategory({
    required this.categoryName,
    required this.dhwDegreeHeatingWeeks,
    required this.impact,
    required this.colorValue,
  });
}

class MarineHeatwaveAssessment {
  final String marineRegion;
  final double seaSurfaceTemperatureC;
  final double sstAnomalyC;
  final double degreeHeatingWeeks;
  final MarineHeatwaveCategory category;
  final List<String> coastalFisheryDirectives;

  const MarineHeatwaveAssessment({
    required this.marineRegion,
    required this.seaSurfaceTemperatureC,
    required this.sstAnomalyC,
    required this.degreeHeatingWeeks,
    required this.category,
    required this.coastalFisheryDirectives,
  });

  /// Evaluates INCOIS Marine Heatwave and Coral Thermal Stress
  static MarineHeatwaveAssessment evaluate({
    required String regionName,
    required double sstC,
    required double sstAnomalyC,
    required double dhwWeeks,
  }) {
    MarineHeatwaveCategory cat;
    if (dhwWeeks >= 8.0) {
      cat = MarineHeatwaveCategory.bleachingAlertLevel2;
    } else if (dhwWeeks >= 4.0) {
      cat = MarineHeatwaveCategory.bleachingWarning;
    } else if (dhwWeeks >= 1.0 || sstAnomalyC >= 1.0) {
      cat = MarineHeatwaveCategory.bleachingWatch;
    } else {
      cat = MarineHeatwaveCategory.normal;
    }

    final directives = <String>[];
    if (cat == MarineHeatwaveCategory.bleachingAlertLevel2 || cat == MarineHeatwaveCategory.bleachingWarning) {
      directives.add('🚨 MARINE HEATWAVE WARNING: Severe thermal stress in coastal waters (DHW: ${dhwWeeks.toStringAsFixed(1)} °C-weeks).');
      directives.add('Commercial trawlers advised to shift pelagic fishing operations to deeper offshore upwelling zones.');
      directives.add('Suspend coastal dredging and non-essential marine construction near coral reef national parks (Gulf of Mannar, Lakshadweep, Andaman).');
    } else {
      directives.add('Sea surface temperature anomalies within stable ecological ranges for coastal fishing communities.');
    }

    return MarineHeatwaveAssessment(
      marineRegion: regionName,
      seaSurfaceTemperatureC: sstC,
      sstAnomalyC: sstAnomalyC,
      degreeHeatingWeeks: dhwWeeks,
      category: cat,
      coastalFisheryDirectives: directives,
    );
  }
}
