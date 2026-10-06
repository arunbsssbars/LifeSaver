import 'package:flutter/material.dart';

enum CwcRiverStage {
  normal, // Below Warning Level
  warning, // Above Warning Level, Below Danger Level
  severe, // Above Danger Level
  extreme, // Exceeding or Approaching Historical HFL
}

extension CwcRiverStageExtension on CwcRiverStage {
  String get label {
    switch (this) {
      case CwcRiverStage.normal:
        return 'NORMAL FLOW';
      case CwcRiverStage.warning:
        return 'ABOVE WARNING LEVEL';
      case CwcRiverStage.severe:
        return 'ABOVE DANGER LEVEL';
      case CwcRiverStage.extreme:
        return 'EXTREME FLOOD (NEAR HFL)';
    }
  }

  Color get color {
    switch (this) {
      case CwcRiverStage.normal:
        return const Color(0xFF10B981);
      case CwcRiverStage.warning:
        return const Color(0xFFFBBF24);
      case CwcRiverStage.severe:
        return const Color(0xFFF97316);
      case CwcRiverStage.extreme:
        return const Color(0xFFEF4444);
    }
  }
}

class CwcRiverStation {
  final String stationName;
  final String riverName;
  final String state;
  final double currentLevelMeters;
  final double warningLevelMeters;
  final double dangerLevelMeters;
  final double highestFloodLevelMeters;
  final String hflYear;
  final String upstreamDamName;
  final double damDischargeCusecs; // Cusecs/m3/s released upstream
  final double latitude;
  final double longitude;

  const CwcRiverStation({
    required this.stationName,
    required this.riverName,
    required this.state,
    required this.currentLevelMeters,
    required this.warningLevelMeters,
    required this.dangerLevelMeters,
    required this.highestFloodLevelMeters,
    required this.hflYear,
    required this.upstreamDamName,
    required this.damDischargeCusecs,
    required this.latitude,
    required this.longitude,
  });

  CwcRiverStage get currentStage {
    if (currentLevelMeters >= highestFloodLevelMeters - 0.2) {
      return CwcRiverStage.extreme;
    } else if (currentLevelMeters >= dangerLevelMeters) {
      return CwcRiverStage.severe;
    } else if (currentLevelMeters >= warningLevelMeters) {
      return CwcRiverStage.warning;
    }
    return CwcRiverStage.normal;
  }

  /// Percentage position between baseline (WL - 2m) and HFL for UI gauges
  double get gaugePercentage {
    final double baseline = warningLevelMeters - 2.0;
    if (highestFloodLevelMeters <= baseline) return 0.5;
    final pct = (currentLevelMeters - baseline) / (highestFloodLevelMeters - baseline);
    return pct.clamp(0.0, 1.0);
  }
}
