import '../models/citizen_report.dart';

/// Autonomous Service managing crowdsourced citizen reports and authority endorsements
class CitizenReportingService {
  static final List<CitizenHazardReport> _reports = [
    CitizenHazardReport(
      reportId: 'REP-101',
      hazardType: DisasterHazardType.floodedRoad,
      title: 'Yamuna Pushta Road Water Inundation (Waist Deep)',
      description: 'Rising river backflow has submerged the underpass near Sector 135.',
      latitude: 28.5020,
      longitude: 77.4100,
      districtName: 'Noida / Gautam Buddha Nagar',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      verificationCount: 8,
      isAuthorityVerified: true,
    ),
    CitizenHazardReport(
      reportId: 'REP-102',
      hazardType: DisasterHazardType.landslideBlockage,
      title: 'Debris Flow on Badrinath National Highway (NH-58)',
      description: 'Heavy boulders blocking both lanes near Chamoli. SDRF clearance machinery deployed.',
      latitude: 30.4120,
      longitude: 79.3240,
      districtName: 'Chamoli',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 50)),
      verificationCount: 14,
      isAuthorityVerified: true,
    ),
    CitizenHazardReport(
      reportId: 'REP-103',
      hazardType: DisasterHazardType.electricalHazard,
      title: 'Transformer Sparking and Low Hanging Snapped Cable',
      description: 'Waterlogged lane with sparking transformer near Gandhi Ghat market.',
      latitude: 25.6140,
      longitude: 85.1760,
      districtName: 'Patna',
      reportedAt: DateTime.now().subtract(const Duration(minutes: 12)),
      verificationCount: 4,
      isAuthorityVerified: false,
    ),
  ];

  static List<CitizenHazardReport> get activeReports => List.unmodifiable(_reports);

  /// Submits a new citizen hazard report
  static CitizenHazardReport submitReport({
    required DisasterHazardType type,
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    required String districtName,
  }) {
    final report = CitizenHazardReport(
      reportId: 'REP-${DateTime.now().millisecondsSinceEpoch}',
      hazardType: type,
      title: title,
      description: description,
      latitude: latitude,
      longitude: longitude,
      districtName: districtName,
      reportedAt: DateTime.now(),
      verificationCount: 1,
      isAuthorityVerified: false,
    );
    _reports.insert(0, report);
    return report;
  }

  /// Upvotes / verifies an existing hazard report
  static void verifyReport(String reportId) {
    final index = _reports.indexWhere((r) => r.reportId == reportId);
    if (index != -1) {
      final current = _reports[index];
      _reports[index] = CitizenHazardReport(
        reportId: current.reportId,
        hazardType: current.hazardType,
        title: current.title,
        description: current.description,
        latitude: current.latitude,
        longitude: current.longitude,
        districtName: current.districtName,
        reportedAt: current.reportedAt,
        verificationCount: current.verificationCount + 1,
        isAuthorityVerified: current.isAuthorityVerified,
      );
    }
  }
}
