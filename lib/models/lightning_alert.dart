import 'package:flutter/material.dart';

enum LightningThreatLevel {
  low,
  moderateWatch,
  highDanger,
  extremeImminent,
}

extension LightningThreatLevelExtension on LightningThreatLevel {
  String get label {
    switch (this) {
      case LightningThreatLevel.low:
        return 'LOW RISK';
      case LightningThreatLevel.moderateWatch:
        return 'THUNDERSTORM WATCH';
      case LightningThreatLevel.highDanger:
        return 'HIGH LIGHTNING DANGER';
      case LightningThreatLevel.extremeImminent:
        return 'IMMINENT STRIKE RISK';
    }
  }

  Color get color {
    switch (this) {
      case LightningThreatLevel.low:
        return const Color(0xFF10B981);
      case LightningThreatLevel.moderateWatch:
        return const Color(0xFFFBBF24);
      case LightningThreatLevel.highDanger:
        return const Color(0xFFF97316);
      case LightningThreatLevel.extremeImminent:
        return const Color(0xFFEF4444);
    }
  }
}

class LightningRiskAssessment {
  final LightningThreatLevel threatLevel;
  final double convectiveInstabilityScore;
  final String safetyDirective;
  final String thirtyThirtyRuleStatus;
  final bool isOutdoorUnsafe;

  const LightningRiskAssessment({
    required this.threatLevel,
    required this.convectiveInstabilityScore,
    required this.safetyDirective,
    required this.thirtyThirtyRuleStatus,
    required this.isOutdoorUnsafe,
  });

  /// Computes distance to lightning strike in kilometers using flash-to-bang seconds
  static double calculateStrikeDistanceKm(double secondsBetweenFlashAndThunder) {
    // Speed of sound in air is ~343 m/s (~0.343 km/s)
    return secondsBetweenFlashAndThunder * 0.343;
  }
}
