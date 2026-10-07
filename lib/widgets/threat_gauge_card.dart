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
        return const Color(0xFF10B981); // Green
      case ThreatLevel.advisory:
        return const Color(0xFFF59E0B); // Amber
      case ThreatLevel.warning:
        return const Color(0xFFF97316); // Orange
      case ThreatLevel.criticalEmergency:
        return const Color(0xFFEF4444); // Red
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
        return Icons.gpp_bad_rounded;
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: threatColor.withValues(alpha: 0.5),
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
              children: [
                Expanded(
                  child: Container(
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
                        Flexible(
                          child: Text(
                            assessment.threatLevel.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: threatColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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

            const SizedBox(height: 20),

            // Time to respond Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: threatColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.timer_outlined, color: threatColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ESTIMATED TIME TO RESPOND',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                            letterSpacing: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          assessment.formattedResponseTime,
                          style: TextStyle(
                            color: threatColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
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
                Expanded(
                  child: Text(
                    'Monitored Basin: ${assessment.nearestBasinName}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.white38, fontSize: 11.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
