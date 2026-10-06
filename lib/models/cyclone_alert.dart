import 'package:flutter/material.dart';

enum CycloneStage {
  stage1PreWatch, // 72 hrs
  stage2Alert, // 48 hrs (Yellow)
  stage3Warning, // 24 hrs (Orange)
  stage4PostLandfall, // 12 hrs (Red)
  noCyclone,
}

extension CycloneStageExtension on CycloneStage {
  String get stageName {
    switch (this) {
      case CycloneStage.stage1PreWatch:
        return 'STAGE I: PRE-CYCLONE WATCH (72h)';
      case CycloneStage.stage2Alert:
        return 'STAGE II: CYCLONE ALERT (48h)';
      case CycloneStage.stage3Warning:
        return 'STAGE III: CYCLONE WARNING (24h)';
      case CycloneStage.stage4PostLandfall:
        return 'STAGE IV: POST-LANDFALL OUTLOOK (12h)';
      case CycloneStage.noCyclone:
        return 'NORMAL COASTAL STATE';
    }
  }

  Color get color {
    switch (this) {
      case CycloneStage.stage1PreWatch:
        return const Color(0xFF38BDF8);
      case CycloneStage.stage2Alert:
        return const Color(0xFFFBBF24);
      case CycloneStage.stage3Warning:
        return const Color(0xFFF97316);
      case CycloneStage.stage4PostLandfall:
        return const Color(0xFFEF4444);
      case CycloneStage.noCyclone:
        return const Color(0xFF10B981);
    }
  }
}

enum CycloneCategory {
  depression, // 31-49 km/h
  deepDepression, // 50-61 km/h
  cyclonicStorm, // 62-88 km/h
  severeCyclonicStorm, // 89-117 km/h
  verySevereCyclonicStorm, // 118-166 km/h
  extremelySevereCyclonicStorm, // 167-221 km/h
  superCyclonicStorm, // >= 222 km/h
}

class CycloneAlertData {
  final String cycloneName;
  final CycloneStage stage;
  final CycloneCategory category;
  final double estimatedWindSpeedKmh;
  final double stormSurgeMeters;
  final double waveHeightMeters; // INCOIS wave height
  final String expectedLandfallPoint;
  final Duration estimatedLandfallTime;
  final String fishermenAdvisory;
  final List<String> affectedDistricts;

  const CycloneAlertData({
    required this.cycloneName,
    required this.stage,
    required this.category,
    required this.estimatedWindSpeedKmh,
    required this.stormSurgeMeters,
    required this.waveHeightMeters,
    required this.expectedLandfallPoint,
    required this.estimatedLandfallTime,
    required this.fishermenAdvisory,
    required this.affectedDistricts,
  });
}
