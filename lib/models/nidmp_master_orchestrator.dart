/// Model representing the 70-Domain National Integrated Disaster Management Platform (NIDMP)
/// executive command cockpit uniting Central Ministries, NDRF, SDMAs, and neighboring SAARC disaster networks.
class NidmpNationalCockpit {
  final String nationState;
  final DateTime synchronizationTimestamp;
  final int totalIntegratedDomains;
  final double nationalPreparednessIndexScore;
  final int activeMajorDisasterOperations;
  final List<String> regionalOperationsRooms;

  const NidmpNationalCockpit({
    required this.nationState,
    required this.synchronizationTimestamp,
    required this.totalIntegratedDomains,
    required this.nationalPreparednessIndexScore,
    required this.activeMajorDisasterOperations,
    required this.regionalOperationsRooms,
  });

  /// Generates the National Executive Committee (NEC) Statutory Disaster Briefing Manifest
  String generateNecStatutoryBriefing() {
    final buffer = StringBuffer();
    buffer.writeln('================================================================');
    buffer.writeln('  NATIONAL EXECUTIVE COMMITTEE (NEC) STATUTORY DISASTER BRIEFING');
    buffer.writeln('  National Integrated Disaster Management Platform (NIDMP)');
    buffer.writeln('================================================================');
    buffer.writeln('Jurisdiction: $nationState | Timestamp: ${synchronizationTimestamp.toIso8601String()}');
    buffer.writeln('Total Integrated Specialized Domains: $totalIntegratedDomains');
    buffer.writeln('National Composite Preparedness Index: ${nationalPreparednessIndexScore.toStringAsFixed(1)}%');
    buffer.writeln('Active Level-3 National Disaster Operations: $activeMajorDisasterOperations');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('REGIONAL EMERGENCY OPERATIONS CENTRES (SEOC / DEOC):');
    for (final room in regionalOperationsRooms) {
      buffer.writeln(' • $room');
    }
    buffer.writeln('================================================================');
    return buffer.toString();
  }
}
