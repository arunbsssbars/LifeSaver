import '../models/thermal_hazard.dart';

class ThermalHazardService {
  /// Evaluates Heatwave / Coldwave according to NDMA National Action Plan & IMD criteria
  static ThermalAssessment evaluateThermalState({
    required double temperatureC,
    required String stateOrDistrict,
    double relativeHumidity = 50.0,
  }) {
    // Steadman / Rothfusz Heat Index approximation
    final double heatIndex = _computeHeatIndex(temperatureC, relativeHumidity);

    final bool isHilly = stateOrDistrict.contains('Uttarakhand') ||
        stateOrDistrict.contains('Himachal') ||
        stateOrDistrict.contains('Kashmir') ||
        stateOrDistrict.contains('Sikkim');

    final bool isCoastal = stateOrDistrict.contains('Odisha') ||
        stateOrDistrict.contains('Kerala') ||
        stateOrDistrict.contains('Tamil Nadu') ||
        stateOrDistrict.contains('Andhra') ||
        stateOrDistrict.contains('Maharashtra');

    // 1. Severe Heatwave / Red Warning
    // Plains >= 45°C or departure >= 6.5°C
    if ((!isHilly && temperatureC >= 45.0) || (isHilly && temperatureC >= 35.0) || (isCoastal && temperatureC >= 40.0) || heatIndex >= 52.0) {
      return ThermalAssessment(
        temperatureC: temperatureC,
        apparentTemperatureC: heatIndex,
        heatwaveStatus: HeatwaveStatus.redSevereWarning,
        isColdWave: false,
        healthAdvisory:
            'RED ALERT: Severe Heatwave / Deadly Loo conditions. Extreme risk of heat stroke, dehydration, and sunstroke.',
        ndmaActionPoints: [
          'Avoid direct sun exposure between 11:00 AM and 4:00 PM.',
          'Drink Oral Rehydration Solution (ORS), lemon water (Nimbu Paani), Chaas, Lassi, and Aam Panna frequently.',
          'Never leave children or pets inside locked vehicles (interior temperatures exceed 60°C within 10 minutes).',
          'Wear loose, light-colored cotton clothes and cover your head with a Gamchha/towel or umbrella.',
        ],
      );
    }

    // 2. Moderate Heatwave / Orange Alert
    // Plains 42°C - 44.9°C
    if ((!isHilly && temperatureC >= 42.0) || (isHilly && temperatureC >= 32.0) || (isCoastal && temperatureC >= 37.0) || heatIndex >= 42.0) {
      return ThermalAssessment(
        temperatureC: temperatureC,
        apparentTemperatureC: heatIndex,
        heatwaveStatus: HeatwaveStatus.orangeAlert,
        isColdWave: false,
        healthAdvisory:
            'ORANGE ALERT: Moderate Heatwave. High vulnerability for elderly, infants, outdoor laborers, and pregnant women.',
        ndmaActionPoints: [
          'Carry a water bottle whenever travelling outdoors.',
          'Take frequent rest breaks in shaded areas for outdoor workers.',
          'Keep cattle and pets in shaded enclosures with adequate water troughs.',
        ],
      );
    }

    // 3. Heat Watch / Yellow
    // Plains 40°C - 41.9°C
    if ((!isHilly && temperatureC >= 40.0) || (isHilly && temperatureC >= 30.0) || heatIndex >= 35.0) {
      return ThermalAssessment(
        temperatureC: temperatureC,
        apparentTemperatureC: heatIndex,
        heatwaveStatus: HeatwaveStatus.yellowWatch,
        isColdWave: false,
        healthAdvisory: 'YELLOW WATCH: Warm and uncomfortable thermal conditions. Maintain hydration.',
        ndmaActionPoints: [
          'Drink sufficient water even if not feeling thirsty.',
          'Avoid alcohol, tea, coffee, and carbonated soft drinks which dehydrate the body.',
        ],
      );
    }

    // 4. Cold Wave Check
    if (temperatureC <= 4.0 || (!isHilly && temperatureC <= 9.0)) {
      return ThermalAssessment(
        temperatureC: temperatureC,
        apparentTemperatureC: temperatureC,
        heatwaveStatus: HeatwaveStatus.normal,
        isColdWave: true,
        healthAdvisory:
            'COLD WAVE WARNING: Freezing / severe cold conditions with risk of hypothermia and frostbite.',
        ndmaActionPoints: [
          'Wear multiple layers of loose warm clothing rather than a single thick garment.',
          'Keep head, neck, hands, and feet well covered (high body heat loss occurs from head/extremities).',
          'Ensure safe ventilation when using coal Angithi or charcoal heaters indoors to prevent Carbon Monoxide poisoning.',
        ],
      );
    }

    // 5. Normal Comfort
    return ThermalAssessment(
      temperatureC: temperatureC,
      apparentTemperatureC: heatIndex,
      heatwaveStatus: HeatwaveStatus.normal,
      isColdWave: false,
      healthAdvisory: 'Normal thermal parameters. No heatwave or coldwave warnings.',
      ndmaActionPoints: [
        'Maintain standard hydration and balanced diet.',
      ],
    );
  }

  static double _computeHeatIndex(double t, double r) {
    if (t < 27.0) return t;
    // Simplified Rothfusz regression
    return -8.78469475556 +
        1.61139411 * t +
        2.33854883889 * r +
        -0.14611605 * t * r +
        -0.012308094 * t * t +
        -0.0164248277778 * r * r +
        0.002211732 * t * t * r +
        0.00072546 * t * r * r +
        -0.000003582 * t * t * r * r;
  }
}
