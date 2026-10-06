import 'package:flutter/material.dart';
import '../models/hazard_status.dart';

class ThreatGaugeCard extends StatelessWidget {
  final HazardAssessment assessment;
  final VoidCallback onRefresh;
  final VoidCallback onSimulateDrill;

  const ThreatGaugeCard({
    super.key,
    required this.assessment,
    required this.onRefresh,
    required this.onSimulateDrill,
  });

  Color _getThreatColor(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.safe:
        return const Color(0xFF10B981); // Emerald Green
      case ThreatLevel.advisory:
        return const Color(0xFFF59E0B); // Amber / Yellow
      case ThreatLevel.warning:
        return const Color(0xFFF97316); // Bright Orange
      case ThreatLevel.criticalEmergency:
        return const Color(0xFFEF4444); // Crimson Red
    }
  }

  IconData _getThreatIcon(ThreatLevel level) {
    switch (level) {
      case ThreatLevel.safe:
        return Icons.verified_user_rounded;
      case ThreatLevel.advisory:
        return Icons.info_outline_rounded;
      case ThreatLevel.warning:
        return Icons.warning_amber_rounded;
      case ThreatLevel.criticalEmergency:
        return Icons.dangerous_rounded;
    }
  }

  String _formatResponseTime(Duration duration) {
    if (duration == Duration.zero) return 'Immediate';
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '$hours hr $minutes min';
    } else if (hours > 0) {
      return '$hours hours';
    } else {
      return '$minutes minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    final threatColor = _getThreatColor(assessment.threatLevel);
    final icon = _getThreatIcon(assessment.threatLevel);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: threatColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: threatColor.withValues(alpha: 0.12),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Status Chip & Action Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: threatColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: threatColor.withValues(alpha: 0.6)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: threatColor, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        assessment.threatLevel.title,
                        style: TextStyle(
                          color: threatColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Simulate Drill',
                      icon: const Icon(Icons.tune_rounded, color: Colors.blueGrey, size: 20),
                      onPressed: onSimulateDrill,
                    ),
                    IconButton(
                      tooltip: 'Refresh Live Telemetry',
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white70, size: 20),
                      onPressed: onRefresh,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Lead Time / Response Time Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: threatColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.timer_rounded,
                      color: threatColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESTIMATED RESPONSE / EVACUATION WINDOW',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatResponseTime(assessment.estimatedResponseTime),
                          style: TextStyle(
                            color: threatColor,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommendation Text
            Text(
              assessment.primaryRecommendation,
              style: const TextStyle(
                color: Color(0xFFE2E8F0),
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 14),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 10),

            // Timestamp footer
            Row(
              children: [
                const Icon(Icons.sensors_rounded, size: 14, color: Colors.white38),
                const SizedBox(width: 6),
                Text(
                  'Monitored Basin: ${assessment.nearestBasinName}',
                  style: const TextStyle(color: Colors.white38, fontSize: 11.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
