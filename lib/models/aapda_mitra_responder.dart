import 'package:flutter/material.dart';

enum ShelterStatus {
  openAvailable,
  fillingFast,
  atCapacity,
}

extension ShelterStatusExtension on ShelterStatus {
  String get label {
    switch (this) {
      case ShelterStatus.openAvailable:
        return 'AVAILABLE';
      case ShelterStatus.fillingFast:
        return 'FILLING FAST';
      case ShelterStatus.atCapacity:
        return 'AT CAPACITY';
    }
  }

  Color get color {
    switch (this) {
      case ShelterStatus.openAvailable:
        return const Color(0xFF10B981);
      case ShelterStatus.fillingFast:
        return const Color(0xFFFBBF24);
      case ShelterStatus.atCapacity:
        return const Color(0xFFEF4444);
    }
  }
}

class NdmaReliefShelter {
  final String id;
  final String name;
  final String district;
  final String state;
  final double latitude;
  final double longitude;
  final double elevationMeters;
  final int capacityPeople;
  final int currentOccupancy;
  final ShelterStatus status;
  final bool hasMedicalAid;
  final bool hasWaterPurifier;
  final bool hasHelipad;
  final String contactOfficer;
  final String officerPhone;
  final double? distanceKm;

  const NdmaReliefShelter({
    required this.id,
    required this.name,
    required this.district,
    required this.state,
    required this.latitude,
    required this.longitude,
    required this.elevationMeters,
    required this.capacityPeople,
    required this.currentOccupancy,
    required this.status,
    required this.hasMedicalAid,
    required this.hasWaterPurifier,
    required this.hasHelipad,
    required this.contactOfficer,
    required this.officerPhone,
    this.distanceKm,
  });

  NdmaReliefShelter copyWithDistance(double km) {
    return NdmaReliefShelter(
      id: id,
      name: name,
      district: district,
      state: state,
      latitude: latitude,
      longitude: longitude,
      elevationMeters: elevationMeters,
      capacityPeople: capacityPeople,
      currentOccupancy: currentOccupancy,
      status: status,
      hasMedicalAid: hasMedicalAid,
      hasWaterPurifier: hasWaterPurifier,
      hasHelipad: hasHelipad,
      contactOfficer: contactOfficer,
      officerPhone: officerPhone,
      distanceKm: km,
    );
  }
}

class AapdaMitraVolunteer {
  final String name;
  final String volunteerId;
  final String district;
  final String state;
  final List<String> skills; // e.g. 'Water Rescue', 'First Aid / CPR', 'Evacuation Transit'
  final String phone;
  final bool isAvailableNow;

  const AapdaMitraVolunteer({
    required this.name,
    required this.volunteerId,
    required this.district,
    required this.state,
    required this.skills,
    required this.phone,
    required this.isAvailableNow,
  });
}
