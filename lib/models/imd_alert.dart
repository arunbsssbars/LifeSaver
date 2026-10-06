import 'package:flutter/material.dart';

/// Official India Meteorological Department (IMD) 4-Stage Color Coded Alert Level
enum ImdAlertLevel {
  green, // No Warning (Normal)
  yellow, // Watch (Be Updated)
  orange, // Alert (Be Prepared)
  red, // Warning (Take Action)
}

extension ImdAlertLevelExtension on ImdAlertLevel {
  String get codeName {
    switch (this) {
      case ImdAlertLevel.green:
        return 'GREEN ALERT';
      case ImdAlertLevel.yellow:
        return 'YELLOW WATCH';
      case ImdAlertLevel.orange:
        return 'ORANGE ALERT';
      case ImdAlertLevel.red:
        return 'RED WARNING';
    }
  }

  String get actionDirective {
    switch (this) {
      case ImdAlertLevel.green:
        return 'NO ADVERSE WEATHER: No special action required. Standard activities may continue.';
      case ImdAlertLevel.yellow:
        return 'BE UPDATED: Keep track of prevailing weather condition and municipal advisories.';
      case ImdAlertLevel.orange:
        return 'BE PREPARED: Maintain high readiness for severe weather, disruptions in transit, and localized waterlogging.';
      case ImdAlertLevel.red:
        return 'TAKE ACTION: Severe weather imminent! High risk to life and property. Move to safety and follow NDRF/SDMA instructions.';
    }
  }

  Color get color {
    switch (this) {
      case ImdAlertLevel.green:
        return const Color(0xFF10B981);
      case ImdAlertLevel.yellow:
        return const Color(0xFFFBBF24);
      case ImdAlertLevel.orange:
        return const Color(0xFFF97316);
      case ImdAlertLevel.red:
        return const Color(0xFFEF4444);
    }
  }

  IconData get icon {
    switch (this) {
      case ImdAlertLevel.green:
        return Icons.check_circle_outline_rounded;
      case ImdAlertLevel.yellow:
        return Icons.info_outline_rounded;
      case ImdAlertLevel.orange:
        return Icons.warning_amber_rounded;
      case ImdAlertLevel.red:
        return Icons.dangerous_rounded;
    }
  }
}

/// Official IMD Hazard Categorization
enum ImdHazardCategory {
  heavyRainfall,
  riverFlood,
  thunderstormLightning,
  tropicalCyclone,
  heatwave,
  coldwave,
  denseFog,
  highWindGust,
}

extension ImdHazardCategoryExtension on ImdHazardCategory {
  String get displayName {
    switch (this) {
      case ImdHazardCategory.heavyRainfall:
        return 'Heavy to Extremely Heavy Rainfall';
      case ImdHazardCategory.riverFlood:
        return 'River Basin Inundation';
      case ImdHazardCategory.thunderstormLightning:
        return 'Thunderstorm & Lightning Activity';
      case ImdHazardCategory.tropicalCyclone:
        return 'Cyclonic Storm & Gale Winds';
      case ImdHazardCategory.heatwave:
        return 'Severe Heatwave / Loo Conditions';
      case ImdHazardCategory.coldwave:
        return 'Severe Cold Wave & Frost';
      case ImdHazardCategory.denseFog:
        return 'Very Dense Fog / Low Visibility';
      case ImdHazardCategory.highWindGust:
        return 'Squally Wind & Gale Gusts';
    }
  }
}

/// Structured Alert Model matching NDMA / IMD Common Alerting Protocol (CAP)
class ImdDistrictAlert {
  final String district;
  final String state;
  final ImdAlertLevel alertLevel;
  final ImdHazardCategory category;
  final String headline;
  final String description;
  final String instruction;
  final DateTime issuedAt;
  final DateTime validUntil;

  const ImdDistrictAlert({
    required this.district,
    required this.state,
    required this.alertLevel,
    required this.category,
    required this.headline,
    required this.description,
    required this.instruction,
    required this.issuedAt,
    required this.validUntil,
  });
}
