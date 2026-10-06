import 'package:flutter/material.dart';

enum EmergencyCategory {
  police,
  disasterResponse,
  floodHydrology,
  medicalAmbulance,
  fireRescue,
  nationalEmergency,
  highwayRescue,
  railwayEmergency,
  maritimeCoastGuard,
  womenSafety,
}

class EmergencyContact {
  final String title;
  final String subtitle;
  final String number;
  final EmergencyCategory category;
  final IconData icon;
  final String countryCode; // 'NP' or 'IN'
  final bool isTollFree;

  const EmergencyContact({
    required this.title,
    required this.subtitle,
    required this.number,
    required this.category,
    required this.icon,
    required this.countryCode,
    this.isTollFree = true,
  });
}
