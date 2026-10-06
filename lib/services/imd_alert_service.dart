import '../models/hazard_status.dart';
import '../models/imd_alert.dart';

class ImdAlertService {
  /// Evaluates district conditions against official India Meteorological Department (IMD) standards
  static ImdDistrictAlert evaluateDistrictAlert({
    required String districtName,
    required String stateName,
    required WeatherStatus weather,
    required FloodStatus flood,
  }) {
    final now = DateTime.now();
    final validUntil = now.add(const Duration(hours: 24));

    final double rainRate = weather.currentRainfall; // mm/h
    final double rainSumToday = weather.rainSumToday; // mm in 24h
    final double windSpeed = weather.windSpeed; // km/h
    final double temp = weather.temperature; // °C
    final double surge = flood.surgeRatio;

    // --- IMD RED WARNING CRITERIA ---
    // 1. Extremely Heavy Rainfall: >= 204.5 mm in 24h or cloudburst >= 45 mm/h
    // 2. Severe River Surge >= 2.5x
    // 3. Cyclone/Gale winds >= 75 km/h
    // 4. Extreme Heatwave >= 45°C
    if (rainSumToday >= 204.5 || rainRate >= 45.0 || surge >= 2.5 || windSpeed >= 75.0 || temp >= 45.0) {
      ImdHazardCategory category = ImdHazardCategory.heavyRainfall;
      String headline = 'IMD RED WARNING: Extremely Heavy Rainfall & Inundation';
      String desc = 'Extremely severe weather event in progress. Rainfall accumulation projected at ${rainSumToday.toStringAsFixed(1)} mm with wind gusts at ${windSpeed.toStringAsFixed(1)} km/h.';

      if (temp >= 45.0) {
        category = ImdHazardCategory.heatwave;
        headline = 'IMD RED WARNING: Severe Heatwave Alert';
        desc = 'Extreme daytime temperatures ($temp°C) causing high risk of severe heat illness and heat stroke.';
      } else if (windSpeed >= 75.0) {
        category = ImdHazardCategory.tropicalCyclone;
        headline = 'IMD RED WARNING: Severe Gale Winds / Cyclonic Squall';
        desc = 'Destructive winds of ${windSpeed.toStringAsFixed(1)} km/h threatening trees, tin roofs, and power lines.';
      } else if (surge >= 2.5) {
        category = ImdHazardCategory.riverFlood;
        headline = 'IMD RED WARNING: River Basin Inundation & Flash Flood';
        desc = 'River flow surging at ${surge.toStringAsFixed(2)}x baseline with imminent embankment overtopping.';
      }

      return ImdDistrictAlert(
        district: districtName,
        state: stateName,
        alertLevel: ImdAlertLevel.red,
        category: category,
        headline: headline,
        description: desc,
        instruction: 'TAKE ACTION: Evacuate low-lying zones. Stay away from electric poles, weak structures, and waterlogged subways. Call NDRF/SDMA 112.',
        issuedAt: now,
        validUntil: validUntil,
      );
    }

    // --- IMD ORANGE ALERT CRITERIA ---
    // 1. Very Heavy Rainfall: 115.6 mm to 204.4 mm in 24h or rain rate 20-45 mm/h
    // 2. River Surge 1.7x to 2.5x
    // 3. Squall winds 50-75 km/h
    // 4. Heatwave 42°C - 45°C
    if (rainSumToday >= 115.6 || rainRate >= 20.0 || surge >= 1.7 || windSpeed >= 50.0 || temp >= 42.0) {
      ImdHazardCategory category = ImdHazardCategory.heavyRainfall;
      String headline = 'IMD ORANGE ALERT: Very Heavy Rainfall & Squalls';
      String desc = 'Heavy to very heavy precipitation observed. Potential traffic disruptions and municipal drainage choking.';

      if (temp >= 42.0) {
        category = ImdHazardCategory.heatwave;
        headline = 'IMD ORANGE ALERT: Moderate to Severe Heatwave';
        desc = 'High temperature ($temp°C) with elevated heat index. Increased risk of dehydration.';
      } else if (surge >= 1.7) {
        category = ImdHazardCategory.riverFlood;
        headline = 'IMD ORANGE ALERT: River Water Level Alert';
        desc = 'Rapid river stage rise (${surge.toStringAsFixed(2)}x) approaching CWC Warning Level.';
      }

      return ImdDistrictAlert(
        district: districtName,
        state: stateName,
        alertLevel: ImdAlertLevel.orange,
        category: category,
        headline: headline,
        description: desc,
        instruction: 'BE PREPARED: Keep emergency kit ready. Avoid waterlogged routes and unessential travel during peak storm.',
        issuedAt: now,
        validUntil: validUntil,
      );
    }

    // --- IMD YELLOW WATCH CRITERIA ---
    // 1. Heavy Rainfall: 64.5 mm to 115.5 mm in 24h or rain rate 8-20 mm/h
    // 2. River Surge 1.3x to 1.7x
    // 3. Gusty winds 35-50 km/h
    // 4. High Rain probability >= 75%
    if (rainSumToday >= 64.5 || rainRate >= 8.0 || surge >= 1.3 || windSpeed >= 35.0 || weather.precipitationProbability >= 75.0) {
      return ImdDistrictAlert(
        district: districtName,
        state: stateName,
        alertLevel: ImdAlertLevel.yellow,
        category: rainRate >= 8.0 ? ImdHazardCategory.heavyRainfall : ImdHazardCategory.thunderstormLightning,
        headline: 'IMD YELLOW WATCH: Isolated Thunderstorms & Showers',
        description: 'Atmospheric instability in district with probability of localized showers and thunder activity.',
        instruction: 'BE UPDATED: Monitor weather bulletins and stay indoors during thunderstorm flashes.',
        issuedAt: now,
        validUntil: validUntil,
      );
    }

    // --- IMD GREEN NORMAL ---
    return ImdDistrictAlert(
      district: districtName,
      state: stateName,
      alertLevel: ImdAlertLevel.green,
      category: ImdHazardCategory.heavyRainfall,
      headline: 'IMD GREEN: No Adverse Weather Warning',
      description: 'Standard seasonal conditions for $districtName, $stateName. River flow within normal baseline (${surge.toStringAsFixed(2)}x).',
      instruction: 'NO ACTION REQUIRED: Routine activities may proceed normally.',
      issuedAt: now,
      validUntil: validUntil,
    );
  }
}
