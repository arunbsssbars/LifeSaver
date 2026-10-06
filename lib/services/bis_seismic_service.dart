import '../models/bis_seismic_zone.dart';

class BisSeismicService {
  /// Evaluates BIS IS 1893:2016 Seismic Zone for any Indian or Himalayan coordinate
  static SeismicZoneAssessment getZoneAssessment({
    required double latitude,
    required double longitude,
    required String regionName,
    required String stateOrDistrict,
  }) {
    // 1. Zone V Check: North-East India (Assam, Meghalaya, etc.), Uttarakhand, Himachal, Kutch, Kashmir
    if (stateOrDistrict.contains('Assam') ||
        stateOrDistrict.contains('Uttarakhand') ||
        stateOrDistrict.contains('Himachal') ||
        stateOrDistrict.contains('Kashmir') ||
        stateOrDistrict.contains('Kutch') ||
        (longitude >= 89.5 && latitude >= 23.0) ||
        (latitude >= 29.5 && longitude >= 76.0 && longitude <= 81.0)) {
      return SeismicZoneAssessment(
        locationName: regionName,
        zone: BisSeismicZone.zoneV,
        state: stateOrDistrict,
        nearestFaultBelt: 'Main Boundary Thrust (MBT) / Himalayan Frontal Thrust',
        peakGroundAcceleration: 0.36,
        emergencyExitProtocol:
            'ZONE V CRITICAL: Immediate Drop-Cover-Hold. Evacuate away from unreinforced brick masonry and narrow alleys after tremors cease.',
      );
    }

    // 2. Zone IV Check: Delhi NCR (Noida, Delhi, Gurugram), Bihar, Northern UP, Bengal
    if (stateOrDistrict.contains('Delhi') ||
        stateOrDistrict.contains('Uttar Pradesh') ||
        stateOrDistrict.contains('Bihar') ||
        stateOrDistrict.contains('West Bengal') ||
        (latitude >= 25.0 && latitude <= 29.5 && longitude >= 76.5 && longitude <= 88.5)) {
      return SeismicZoneAssessment(
        locationName: regionName,
        zone: BisSeismicZone.zoneIV,
        state: stateOrDistrict,
        nearestFaultBelt: 'Great Boundary Fault / Sohna Fault / Mahendragarh-Dehradun Fault',
        peakGroundAcceleration: 0.24,
        emergencyExitProtocol:
            'ZONE IV SEVERE: Delhi-NCR is vulnerable to high-rise building swaying from distant Himalayan mega-quakes. Do not use elevators. Drop, Cover, Hold under sturdy tables.',
      );
    }

    // 3. Zone III Check: Mumbai / Maharashtra, Kerala, Gujarat mainland, Coastal Tamil Nadu / Andhra
    if (stateOrDistrict.contains('Maharashtra') ||
        stateOrDistrict.contains('Kerala') ||
        stateOrDistrict.contains('Gujarat') ||
        stateOrDistrict.contains('Karnataka') ||
        stateOrDistrict.contains('Tamil Nadu') ||
        stateOrDistrict.contains('Andhra')) {
      return SeismicZoneAssessment(
        locationName: regionName,
        zone: BisSeismicZone.zoneIII,
        state: stateOrDistrict,
        nearestFaultBelt: 'West Coast Fault / Koyna Intraplate Seismic Belt',
        peakGroundAcceleration: 0.16,
        emergencyExitProtocol:
            'ZONE III MODERATE: Follow standard Drop, Cover and Hold On drill. Inspect coastal infrastructure for liquefaction and settlement.',
      );
    }

    // 4. Default to Zone II (Central/Southern Shield)
    return SeismicZoneAssessment(
      locationName: regionName,
      zone: BisSeismicZone.zoneII,
      state: stateOrDistrict,
      nearestFaultBelt: 'Stable Continental Peninsular Shield',
      peakGroundAcceleration: 0.10,
      emergencyExitProtocol:
          'ZONE II LOW RISK: Low baseline seismic activity. Maintain standard emergency preparedness.',
    );
  }
}
