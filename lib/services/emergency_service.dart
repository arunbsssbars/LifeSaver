import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/emergency_contact.dart';

class EmergencyService {
  static const List<EmergencyContact> _nepalContacts = [
    EmergencyContact(
      title: 'DHM Flood Early Warning Helpline',
      subtitle: 'Real-time river level alert & community warning',
      number: '1155',
      category: EmergencyCategory.floodHydrology,
      icon: Icons.water_drop_rounded,
      countryCode: 'NP',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Armed Police Force (APF) Disaster Helpline',
      subtitle: 'Search, water rescue & disaster operations',
      number: '1114',
      category: EmergencyCategory.disasterResponse,
      icon: Icons.shield_rounded,
      countryCode: 'NP',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Nepal Police Emergency Control',
      subtitle: 'Instant police dispatch & rescue coordination',
      number: '100',
      category: EmergencyCategory.police,
      icon: Icons.local_police_rounded,
      countryCode: 'NP',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Nepal Red Cross Ambulance Service',
      subtitle: 'Emergency medical evacuation & first aid',
      number: '102',
      category: EmergencyCategory.medicalAmbulance,
      icon: Icons.medical_services_rounded,
      countryCode: 'NP',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Fire & Rescue Brigade (Damkal)',
      subtitle: 'Fire suppression, structure collapse & extraction',
      number: '101',
      category: EmergencyCategory.fireRescue,
      icon: Icons.fire_truck_rounded,
      countryCode: 'NP',
      isTollFree: true,
    ),
  ];

  static const List<EmergencyContact> _indiaContacts = [
    EmergencyContact(
      title: 'National Emergency Response (ERSS)',
      subtitle: 'Unified single emergency number across India',
      number: '112',
      category: EmergencyCategory.nationalEmergency,
      icon: Icons.emergency_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'NDRF Disaster Management Control',
      subtitle: 'National Disaster Response Force specialized rescue',
      number: '1078',
      category: EmergencyCategory.disasterResponse,
      icon: Icons.shield_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'State Disaster Management Control (SDMA)',
      subtitle: 'State level flood & calamity response',
      number: '1070',
      category: EmergencyCategory.disasterResponse,
      icon: Icons.water_damage_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'District Emergency Operation Center (DEOC)',
      subtitle: 'Local District Magistrate disaster command',
      number: '1077',
      category: EmergencyCategory.disasterResponse,
      icon: Icons.domain_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'NHAI National Highway Emergency SOS',
      subtitle: 'Expressway & Highway accident / landslide rescue',
      number: '1033',
      category: EmergencyCategory.highwayRescue,
      icon: Icons.add_road_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Indian Railways Disaster & Accident Helpline',
      subtitle: 'Rail accident, train derailment & passenger assistance',
      number: '139',
      category: EmergencyCategory.railwayEmergency,
      icon: Icons.train_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Indian Coast Guard Maritime Search & Rescue',
      subtitle: 'Coastal cyclone, sea rescue & fisherman distress',
      number: '1554',
      category: EmergencyCategory.maritimeCoastGuard,
      icon: Icons.sailing_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'National Ambulance & Medical Emergency',
      subtitle: 'Emergency medical services & trauma response',
      number: '108',
      category: EmergencyCategory.medicalAmbulance,
      icon: Icons.medical_services_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'India Police Control Room',
      subtitle: 'Police assistance & local coordination',
      number: '100',
      category: EmergencyCategory.police,
      icon: Icons.local_police_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
    EmergencyContact(
      title: 'Fire & Rescue Services',
      subtitle: 'Fire & urban search and rescue',
      number: '101',
      category: EmergencyCategory.fireRescue,
      icon: Icons.fire_truck_rounded,
      countryCode: 'IN',
      isTollFree: true,
    ),
  ];

  static List<EmergencyContact> getContactsForCountry(String countryCode) {
    if (countryCode.toUpperCase() == 'NP') {
      return _nepalContacts;
    }
    return _indiaContacts;
  }

  static Future<bool> makePhoneCall(String phoneNumber) async {
    final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    final uri = Uri.parse('tel:$cleanNumber');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }

  static Future<bool> sendDistressSms({
    required double latitude,
    required double longitude,
    required String regionName,
    required String threatLevel,
  }) async {
    final String mapsLink = 'https://maps.google.com/?q=$latitude,$longitude';
    final String message = Uri.encodeComponent(
      '🚨 EMERGENCY SOS ALERT!\n'
      'I am in immediate danger due to $threatLevel near $regionName.\n'
      'My GPS Location: $mapsLink\n'
      'Sent via LifeSaver Early Warning App.',
    );

    final uri = Uri.parse('sms:?body=$message');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri);
    }
    return false;
  }
}
