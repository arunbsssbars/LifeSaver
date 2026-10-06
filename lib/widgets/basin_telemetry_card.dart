import 'package:flutter/material.dart';
import '../models/hazard_status.dart';

class BasinTelemetryCard extends StatelessWidget {
  final HazardAssessment assessment;

  const BasinTelemetryCard({
    super.key,
    required this.assessment,
  });

  @override
  Widget build(BuildContext context) {
    final flood = assessment.floodStatus;
    final weather = assessment.weatherStatus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.water_rounded, color: Color(0xFF38BDF8), size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Hydrological & Weather Telemetry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2x2 Grid for Telemetry Metrics
          Row(
            children: [
              // Current Discharge
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.waves_rounded,
                  iconColor: const Color(0xFF38BDF8),
                  title: 'River Discharge',
                  value: '${flood.currentDischarge.toStringAsFixed(1)} m³/s',
                  subtitle: 'Mean: ${flood.meanDischarge.toStringAsFixed(1)} m³/s',
                ),
              ),
              const SizedBox(width: 10),
              // Forecast Peak
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.trending_up_rounded,
                  iconColor: flood.surgeRatio > 1.35 ? Colors.orangeAccent : Colors.lightGreenAccent,
                  title: '3-Day Peak',
                  value: '${flood.maxForecastDischarge.toStringAsFixed(1)} m³/s',
                  subtitle: 'Surge: ${flood.surgeRatio.toStringAsFixed(2)}x',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // Rain Rate
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.grain_rounded,
                  iconColor: const Color(0xFF818CF8),
                  title: 'Rain Intensity',
                  value: '${weather.currentRainfall.toStringAsFixed(1)} mm/h',
                  subtitle: 'Today: ${weather.rainSumToday.toStringAsFixed(1)} mm',
                ),
              ),
              const SizedBox(width: 10),
              // Rain Prob & Wind
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.air_rounded,
                  iconColor: const Color(0xFF34D399),
                  title: 'Rain Probability',
                  value: '${weather.precipitationProbability.toStringAsFixed(0)}%',
                  subtitle: 'Wind: ${weather.windSpeed.toStringAsFixed(1)} km/h',
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),
          // Multi-day trend summary
          if (flood.forecastDischarges.length >= 2) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Text(
                    'GloFAS Model: ',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  Expanded(
                    child: Text(
                      'Surge ${flood.surgeRatio.toStringAsFixed(2)}x (${assessment.threatLevel.shortLabel})',
                      style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 15),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
