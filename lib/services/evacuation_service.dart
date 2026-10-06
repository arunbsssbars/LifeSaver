import '../models/aapda_mitra_responder.dart';
import 'earthquake_service.dart';

class EvacuationService {
  static const List<NdmaReliefShelter> _allShelters = [
    // Delhi / Noida Shelters
    NdmaReliefShelter(
      id: 'NDMA_NOIDA_01',
      name: 'Noida Stadium Emergency Relief Camp',
      district: 'Gautam Buddha Nagar',
      state: 'Uttar Pradesh',
      latitude: 28.5833,
      longitude: 77.3400,
      elevationMeters: 202.0,
      capacityPeople: 2500,
      currentOccupancy: 340,
      status: ShelterStatus.openAvailable,
      hasMedicalAid: true,
      hasWaterPurifier: true,
      hasHelipad: true,
      contactOfficer: 'SDM Disaster Cell Gautam Buddha Nagar',
      officerPhone: '0120-2544410',
    ),
    NdmaReliefShelter(
      id: 'NDMA_DELHI_02',
      name: 'Yamuna Sports Complex Safe Shelter',
      district: 'East Delhi',
      state: 'Delhi',
      latitude: 28.6650,
      longitude: 77.3100,
      elevationMeters: 208.0,
      capacityPeople: 4000,
      currentOccupancy: 820,
      status: ShelterStatus.openAvailable,
      hasMedicalAid: true,
      hasWaterPurifier: true,
      hasHelipad: false,
      contactOfficer: 'DDMA East Delhi Control',
      officerPhone: '011-22727196',
    ),

    // Assam / Guwahati
    NdmaReliefShelter(
      id: 'ASDMA_GUW_01',
      name: 'Sarada Charan Stadium Relief Hub',
      district: 'Kamrup Metropolitan',
      state: 'Assam',
      latitude: 26.1700,
      longitude: 91.7500,
      elevationMeters: 62.0,
      capacityPeople: 3000,
      currentOccupancy: 1200,
      status: ShelterStatus.fillingFast,
      hasMedicalAid: true,
      hasWaterPurifier: true,
      hasHelipad: true,
      contactOfficer: 'ASDMA Kamrup Metro Disaster Officer',
      officerPhone: '1077',
    ),

    // Bihar / Patna
    NdmaReliefShelter(
      id: 'BSDMA_PAT_01',
      name: 'Patliputra Sports Complex Elevated Shelter',
      district: 'Patna',
      state: 'Bihar',
      latitude: 25.6000,
      longitude: 85.1200,
      elevationMeters: 55.0,
      capacityPeople: 5000,
      currentOccupancy: 650,
      status: ShelterStatus.openAvailable,
      hasMedicalAid: true,
      hasWaterPurifier: true,
      hasHelipad: true,
      contactOfficer: 'BSDMA Emergency Control',
      officerPhone: '1070',
    ),

    // Uttarakhand / Rishikesh
    NdmaReliefShelter(
      id: 'USDMA_RISHI_01',
      name: 'Rishikesh High-Altitude Transit Camp',
      district: 'Dehradun',
      state: 'Uttarakhand',
      latitude: 30.1100,
      longitude: 78.3000,
      elevationMeters: 380.0,
      capacityPeople: 1800,
      currentOccupancy: 210,
      status: ShelterStatus.openAvailable,
      hasMedicalAid: true,
      hasWaterPurifier: true,
      hasHelipad: true,
      contactOfficer: 'USDMA Dehradun Disaster Cell',
      officerPhone: '1070',
    ),
  ];

  static const List<AapdaMitraVolunteer> _volunteers = [
    AapdaMitraVolunteer(
      name: 'Rajesh Sharma (Aapda Mitra Leader)',
      volunteerId: 'AM-UP-GBN-104',
      district: 'Gautam Buddha Nagar / Noida',
      state: 'Uttar Pradesh',
      skills: ['Inflatable Boat Rescue', 'CPR & First Aid', 'Elderly Evacuation'],
      phone: '+919811002233',
      isAvailableNow: true,
    ),
    AapdaMitraVolunteer(
      name: 'Pooja Verma (Aapda Sakhi)',
      volunteerId: 'AM-DL-EST-088',
      district: 'East Delhi',
      state: 'Delhi',
      skills: ['Triage & Emergency Meds', 'Community Shelter Lead'],
      phone: '+919877665544',
      isAvailableNow: true,
    ),
    AapdaMitraVolunteer(
      name: 'Biren Kalita (Civil Defence Volunteer)',
      volunteerId: 'AM-AS-KAM-023',
      district: 'Kamrup / Guwahati',
      state: 'Assam',
      skills: ['Deep Water Rescue', 'Radio Telecom Link'],
      phone: '+919435001122',
      isAvailableNow: true,
    ),
  ];

  /// Returns shelters sorted by distance to the given coordinates
  static List<NdmaReliefShelter> getNearbyShelters(double userLat, double userLng) {
    List<NdmaReliefShelter> list = _allShelters.map((s) {
      final dist = EarthquakeService.calculateDistanceKm(
        userLat,
        userLng,
        s.latitude,
        s.longitude,
      );
      return s.copyWithDistance(dist);
    }).toList();

    list.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
    return list;
  }

  static List<AapdaMitraVolunteer> getVolunteersForDistrict(String district) {
    return _volunteers;
  }
}
