import 'package:flutter/material.dart';
import '../models/cwc_river_station.dart';

class CwcGaugeCard extends StatelessWidget {
  final CwcRiverStation station;

  const CwcGaugeCard({
    super.key,
    required this.station,
  });

  @override
  Widget build(BuildContext context) {
    final stage = station.currentStage;
    final stageColor = stage.color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: stageColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: CWC Logo / Badge + River Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0284C7)),
                ),
                child: const Text(
                  'CWC GAUGE',
                  style: TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${station.riverName} • ${station.stationName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Current Water Level vs Danger Level Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CURRENT WATER LEVEL',
                    style: TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '${station.currentLevelMeters.toStringAsFixed(2)} m',
                        style: TextStyle(
                          color: stageColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: stageColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          stage.label,
                          style: TextStyle(
                            color: stageColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Gauge Progress Bar (Warning Level -> Danger Level -> HFL)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: LinearProgressIndicator(
                value: station.gaugePercentage,
                backgroundColor: const Color(0xFF0F172A),
                valueColor: AlwaysStoppedAnimation<Color>(stageColor),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Level Markers
          Wrap(
            spacing: 10,
            runSpacing: 4,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Text(
                'WL: ${station.warningLevelMeters.toStringAsFixed(1)}m',
                style: const TextStyle(color: Color(0xFFFBBF24), fontSize: 10.5, fontWeight: FontWeight.w500),
              ),
              Text(
                'DL: ${station.dangerLevelMeters.toStringAsFixed(1)}m',
                style: const TextStyle(color: Color(0xFFF97316), fontSize: 10.5, fontWeight: FontWeight.bold),
              ),
              Text(
                'HFL: ${station.highestFloodLevelMeters.toStringAsFixed(1)}m (${station.hflYear})',
                style: const TextStyle(color: Color(0xFFEF4444), fontSize: 10.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 10),

          // Upstream Dam Release Status
          Row(
            children: [
              const Icon(Icons.water_damage_rounded, color: Color(0xFF38BDF8), size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Upstream: ${station.upstreamDamName} • Inflow: ${station.damDischargeCusecs.toStringAsFixed(0)} cusecs',
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
