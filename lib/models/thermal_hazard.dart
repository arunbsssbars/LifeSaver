import 'package:flutter/material.dart';

enum HeatwaveStatus {
  normal,
  yellowWatch,
  orangeAlert,
  redSevereWarning,
}

extension HeatwaveStatusExtension on HeatwaveStatus {
  String get label {
    switch (this) {
      case HeatwaveStatus.normal:
        return 'NORMAL THERMAL COMFORT';
      case HeatwaveStatus.yellowWatch:
        return 'HEAT ALERT (WATCH)';
      case HeatwaveStatus.orangeAlert:
        return 'MODERATE HEATWAVE';
      case HeatwaveStatus.redSevereWarning:
        return 'SEVERE HEATWAVE / LOO WARNING';
    }
  }

  Color get color {
    switch (this) {
      case HeatwaveStatus.normal:
        return const Color(0xFF10B981);
      case HeatwaveStatus.yellowWatch:
        return const Color(0xFFFBBF24);
      case HeatwaveStatus.orangeAlert:
        return const Color(0xFFF97316);
      case HeatwaveStatus.redSevereWarning:
        return const Color(0xFFEF4444);
    }
  }
}

class ThermalAssessment {
  final double temperatureC;
  final double apparentTemperatureC; // Heat index
  final HeatwaveStatus heatwaveStatus;
  final bool isColdWave;
  final String healthAdvisory;
  final List<String> ndmaActionPoints;

  const ThermalAssessment({
    required this.temperatureC,
    required this.apparentTemperatureC,
    required this.heatwaveStatus,
    required this.isColdWave,
    required this.healthAdvisory,
    required this.ndmaActionPoints,
  });
}
