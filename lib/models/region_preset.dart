class RegionPreset {
  final String name;
  final String stateOrDistrict;
  final String country; // 'Nepal' or 'India'
  final String countryCode; // 'NP' or 'IN'
  final double latitude;
  final double longitude;
  final String majorRiverBasin;

  const RegionPreset({
    required this.name,
    required this.stateOrDistrict,
    required this.country,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.majorRiverBasin,
  });

  static const List<RegionPreset> presets = [
    // --- NEPAL ---
    RegionPreset(
      name: 'Kathmandu Valley',
      stateOrDistrict: 'Bagmati Province',
      country: 'Nepal',
      countryCode: 'NP',
      latitude: 27.7172,
      longitude: 85.3240,
      majorRiverBasin: 'Bagmati & Bishnumati River',
    ),
    RegionPreset(
      name: 'Biratnagar / Koshi',
      stateOrDistrict: 'Koshi Province',
      country: 'Nepal',
      countryCode: 'NP',
      latitude: 26.4525,
      longitude: 87.2718,
      majorRiverBasin: 'Saptakoshi River Basin',
    ),
    RegionPreset(
      name: 'Pokhara / Kaski',
      stateOrDistrict: 'Gandaki Province',
      country: 'Nepal',
      countryCode: 'NP',
      latitude: 28.2096,
      longitude: 83.9856,
      majorRiverBasin: 'Seti Gandaki River Basin',
    ),
    RegionPreset(
      name: 'Narayangarh / Chitwan',
      stateOrDistrict: 'Bagmati Province',
      country: 'Nepal',
      countryCode: 'NP',
      latitude: 27.6934,
      longitude: 84.4285,
      majorRiverBasin: 'Narayani River Basin',
    ),
    RegionPreset(
      name: 'Birendranagar / Surkhet',
      stateOrDistrict: 'Karnali Province',
      country: 'Nepal',
      countryCode: 'NP',
      latitude: 28.6019,
      longitude: 81.6338,
      majorRiverBasin: 'Karnali River Basin',
    ),

    // --- INDIA ---
    RegionPreset(
      name: 'Guwahati / Assam',
      stateOrDistrict: 'Assam',
      country: 'India',
      countryCode: 'IN',
      latitude: 26.1445,
      longitude: 91.7362,
      majorRiverBasin: 'Brahmaputra River Basin',
    ),
    RegionPreset(
      name: 'Patna / Bihar',
      stateOrDistrict: 'Bihar',
      country: 'India',
      countryCode: 'IN',
      latitude: 25.5941,
      longitude: 85.1376,
      majorRiverBasin: 'Ganga & Gandak River',
    ),
    RegionPreset(
      name: 'Noida / Delhi NCR',
      stateOrDistrict: 'Uttar Pradesh / Delhi',
      country: 'India',
      countryCode: 'IN',
      latitude: 28.5355,
      longitude: 77.3910,
      majorRiverBasin: 'Yamuna & Hindon Basin',
    ),
    RegionPreset(
      name: 'Rishikesh / Haridwar',
      stateOrDistrict: 'Uttarakhand',
      country: 'India',
      countryCode: 'IN',
      latitude: 30.0869,
      longitude: 78.2676,
      majorRiverBasin: 'Ganga & Alaknanda Basin',
    ),
    RegionPreset(
      name: 'Kochi / Aluva',
      stateOrDistrict: 'Kerala',
      country: 'India',
      countryCode: 'IN',
      latitude: 9.9312,
      longitude: 76.2673,
      majorRiverBasin: 'Periyar River Basin',
    ),
    RegionPreset(
      name: 'Siliguri / Jalpaiguri',
      stateOrDistrict: 'West Bengal',
      country: 'India',
      countryCode: 'IN',
      latitude: 26.7271,
      longitude: 88.3953,
      majorRiverBasin: 'Teesta & Mahananda Basin',
    ),
    RegionPreset(
      name: 'Mumbai Coastal / Mithi',
      stateOrDistrict: 'Maharashtra',
      country: 'India',
      countryCode: 'IN',
      latitude: 19.0760,
      longitude: 72.8777,
      majorRiverBasin: 'Mithi River & Arabian Sea',
    ),
  ];
}
