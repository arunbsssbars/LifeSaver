/// Model representing IMD & CPCB Northern Indian Convective Dust Storm (Andhi / Haboob)
/// Early Warning Protocols for Rajasthan, Delhi-NCR, Haryana, Punjab & Uttar Pradesh.
enum DustStormSeverity {
  noDustStorm(
    label: 'Nominal Atmosphere',
    minWindSpeedKmh: 0.0,
    minVisibilityMeters: 2000.0,
    colorValue: 0xFF10B981,
  ),
  moderateAndhi(
    label: 'Moderate Dust Storm (Andhi Watch)',
    minWindSpeedKmh: 45.0,
    minVisibilityMeters: 500.0,
    colorValue: 0xFFFBBF24,
  ),
  severeHaboob(
    label: 'Severe Convective Dust Storm / Haboob (Red Warning)',
    minWindSpeedKmh: 70.0,
    minVisibilityMeters: 100.0,
    colorValue: 0xFFEF4444,
  );

  final String label;
  final double minWindSpeedKmh;
  final double minVisibilityMeters;
  final int colorValue;

  const DustStormSeverity({
    required this.label,
    required this.minWindSpeedKmh,
    required this.minVisibilityMeters,
    required this.colorValue,
  });
}

class DustStormSafetyAdvisor {
  /// Evaluates convective dust storm threat
  static DustStormSeverity evaluate({
    required double gustWindSpeedKmh,
    required double visibilityMeters,
    required double pm10UgM3,
  }) {
    if (gustWindSpeedKmh >= 65.0 && (visibilityMeters < 500.0 || pm10UgM3 >= 800.0)) {
      return DustStormSeverity.severeHaboob;
    } else if (gustWindSpeedKmh >= 40.0 && (visibilityMeters < 1000.0 || pm10UgM3 >= 400.0)) {
      return DustStormSeverity.moderateAndhi;
    }
    return DustStormSeverity.noDustStorm;
  }

  static const List<String> andhiSurvivalDirectives = [
    'SEEK SOLID INDOOR SHELTER: Close and latch all exterior windows, doors, and exhaust dampers immediately.',
    'PROTECT EYES & AIRWAYS: Wear airtight safety goggles and certified N95 respirators to prevent corneal abrasions and silicosis.',
    'DRIVERS ON HIGHWAY: Pull vehicle completely off the paved roadway, turn OFF all lights, set emergency parking brake, and keep foot OFF brake pedal (prevents trailing vehicles from rear-ending you).',
    'AVOID TIN SHEDS & BILLBOARDS: High gust fronts exceeding 70 km/h frequently collapse hoardings, uproot eucalyptus trees, and snap electrical utility poles.',
  ];
}
