/// Model representing Central Pollution Control Board (CPCB) National Air Quality Index (NAQI)
/// and Commission for Air Quality Management (CAQM) Graded Response Action Plan (GRAP I - IV).
enum NaqiCategory {
  good(
    band: '0 – 50 (Good)',
    impact: 'Minimal health impact; clean pristine air.',
    colorValue: 0xFF10B981,
  ),
  satisfactory(
    band: '51 – 100 (Satisfactory)',
    impact: 'Minor breathing discomfort to sensitive people.',
    colorValue: 0xFF84CC16,
  ),
  moderate(
    band: '101 – 200 (Moderate)',
    impact: 'Breathing discomfort to people with lungs/asthma and heart diseases.',
    colorValue: 0xFFFBBF24,
  ),
  poor(
    band: '201 – 300 (Poor)',
    impact: 'Breathing discomfort to most people on prolonged outdoor exposure.',
    colorValue: 0xFFF97316,
  ),
  veryPoor(
    band: '301 – 400 (Very Poor)',
    impact: 'Respiratory illness on prolonged exposure. Pronounced effect on asthma patients.',
    colorValue: 0xFFEF4444,
  ),
  severePlus(
    band: '401 – 500+ (Severe / Emergency)',
    impact: 'Affects healthy people and seriously impacts those with existing diseases. Smog emergency.',
    colorValue: 0xFF7F1D1D,
  );

  final String band;
  final String impact;
  final int colorValue;

  const NaqiCategory({
    required this.band,
    required this.impact,
    required this.colorValue,
  });
}

enum GrapStage {
  none(
    stageName: 'Standard Monitoring',
    triggerAqi: 0,
    measures: ['Regular mechanized sweeping and water sprinkling.'],
  ),
  stage1Poor(
    stageName: 'GRAP Stage I (Poor: AQI 201–300)',
    triggerAqi: 201,
    measures: [
      'Strict ban on open burning of biomass and municipal solid waste.',
      'Water sprinkling on unpaved roads and construction sites.',
      'Enforce anti-dust guidelines in demolition projects.',
    ],
  ),
  stage2VeryPoor(
    stageName: 'GRAP Stage II (Very Poor: AQI 301–400)',
    triggerAqi: 301,
    measures: [
      'Ban on use of Diesel Generator (DG) sets (except essential services).',
      'Enhance parking fees to discourage private vehicular transport.',
      'Daily water sprinkling with dust suppressants on major arterial roads.',
    ],
  ),
  stage3Severe(
    stageName: 'GRAP Stage III (Severe: AQI 401–450)',
    triggerAqi: 401,
    measures: [
      'Strict ban on non-essential construction and demolition activities.',
      'Restrictions on plying of BS-III Petrol and BS-IV Diesel 4-wheelers.',
      'Discontinue physical classes in schools up to Class 5.',
    ],
  ),
  stage4SeverePlus(
    stageName: 'GRAP Stage IV (Severe+: AQI > 450 Smog Emergency)',
    triggerAqi: 451,
    measures: [
      'Ban on entry of non-electric/non-CNG commercial trucks into NCR.',
      'Mandatory Work-from-Home (50% staff) in public and private offices.',
      'Suspend in-person physical school classes across all grades.',
      'N95 / FFP2 mask advisory for all outdoor movements.',
    ],
  );

  final String stageName;
  final int triggerAqi;
  final List<String> measures;

  const GrapStage({
    required this.stageName,
    required this.triggerAqi,
    required this.measures,
  });
}

class CpcbAqiAssessment {
  final int aqiValue;
  final double pm25;
  final double pm10;
  final NaqiCategory category;
  final GrapStage grapStage;
  final List<String> healthPrecautions;

  const CpcbAqiAssessment({
    required this.aqiValue,
    required this.pm25,
    required this.pm10,
    required this.category,
    required this.grapStage,
    required this.healthPrecautions,
  });

  /// Evaluates CPCB NAQI and CAQM GRAP Stage
  static CpcbAqiAssessment evaluate({
    required int aqi,
    required double pm25UgM3,
    required double pm10UgM3,
  }) {
    NaqiCategory cat;
    GrapStage grap;

    if (aqi > 450) {
      cat = NaqiCategory.severePlus;
      grap = GrapStage.stage4SeverePlus;
    } else if (aqi >= 401) {
      cat = NaqiCategory.severePlus;
      grap = GrapStage.stage3Severe;
    } else if (aqi >= 301) {
      cat = NaqiCategory.veryPoor;
      grap = GrapStage.stage2VeryPoor;
    } else if (aqi >= 201) {
      cat = NaqiCategory.poor;
      grap = GrapStage.stage1Poor;
    } else if (aqi >= 101) {
      cat = NaqiCategory.moderate;
      grap = GrapStage.none;
    } else if (aqi >= 51) {
      cat = NaqiCategory.satisfactory;
      grap = GrapStage.none;
    } else {
      cat = NaqiCategory.good;
      grap = GrapStage.none;
    }

    final precautions = <String>[];
    if (aqi >= 301) {
      precautions.add('Wear certified N95 or FFP2 respirators for all essential outdoor movements.');
      precautions.add('Avoid early morning jogging or high-intensity aerobic workouts outdoors.');
      precautions.add('Run indoor HEPA air purifiers and keep windows closed during thermal inversion hours.');
    } else if (aqi >= 201) {
      precautions.add('Individuals with asthma or chronic bronchitis should carry emergency rescue inhalers.');
      precautions.add('Keep hydrated and wash eyes with clean saline if burning sensation occurs.');
    } else {
      precautions.add('Air quality within safe statutory parameters for general population.');
    }

    return CpcbAqiAssessment(
      aqiValue: aqi,
      pm25: pm25UgM3,
      pm10: pm10UgM3,
      category: cat,
      grapStage: grap,
      healthPrecautions: precautions,
    );
  }
}
