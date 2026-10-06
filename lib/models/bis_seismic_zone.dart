import 'package:flutter/material.dart';

enum BisSeismicZone {
  zoneII, // Low Risk (Zone Factor 0.10)
  zoneIII, // Moderate Risk (Zone Factor 0.16)
  zoneIV, // Severe Damage Risk (Zone Factor 0.24)
  zoneV, // Very Severe Catastrophic Risk (Zone Factor 0.36)
}

extension BisSeismicZoneExtension on BisSeismicZone {
  String get romanName {
    switch (this) {
      case BisSeismicZone.zoneII:
        return 'BIS ZONE II';
      case BisSeismicZone.zoneIII:
        return 'BIS ZONE III';
      case BisSeismicZone.zoneIV:
        return 'BIS ZONE IV';
      case BisSeismicZone.zoneV:
        return 'BIS ZONE V';
    }
  }

  String get riskLabel {
    switch (this) {
      case BisSeismicZone.zoneII:
        return 'Low Damage Risk (Z = 0.10)';
      case BisSeismicZone.zoneIII:
        return 'Moderate Damage Risk (Z = 0.16)';
      case BisSeismicZone.zoneIV:
        return 'Severe Damage Risk (Z = 0.24)';
      case BisSeismicZone.zoneV:
        return 'Very Severe / Catastrophic Risk (Z = 0.36)';
    }
  }

  Color get color {
    switch (this) {
      case BisSeismicZone.zoneII:
        return const Color(0xFF10B981); // Green
      case BisSeismicZone.zoneIII:
        return const Color(0xFFFBBF24); // Yellow
      case BisSeismicZone.zoneIV:
        return const Color(0xFFF97316); // Orange
      case BisSeismicZone.zoneV:
        return const Color(0xFFEF4444); // Red
    }
  }

  String get buildingCodeGuidelines {
    switch (this) {
      case BisSeismicZone.zoneII:
        return 'Standard masonry with lintel bands. Minimum earthquake resistance required.';
      case BisSeismicZone.zoneIII:
        return 'IS 13920 ductile detailing for RCC frames mandatory. Reinforced plinth & roof bands.';
      case BisSeismicZone.zoneIV:
        return 'High seismic design mandatory (IS 1893). Ductile shear walls, beam-column joint confining ties, open ground storey (stilt) retrofitting required.';
      case BisSeismicZone.zoneV:
        return 'Maximum seismic design (IS 1893 / IS 13920). Strict non-engineered structure prohibition. Base isolation and seismic dampers recommended.';
    }
  }
}

class SeismicZoneAssessment {
  final String locationName;
  final BisSeismicZone zone;
  final String state;
  final String nearestFaultBelt;
  final double peakGroundAcceleration; // PGA in g
  final String emergencyExitProtocol;

  const SeismicZoneAssessment({
    required this.locationName,
    required this.zone,
    required this.state,
    required this.nearestFaultBelt,
    required this.peakGroundAcceleration,
    required this.emergencyExitProtocol,
  });
}
