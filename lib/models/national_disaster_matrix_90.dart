/// Model representing the comprehensive 90-Domain National Disaster Emergency Matrix (NIDMP 90)
/// uniting all Indian Statutory Guidelines, Early Warning Systems, and Civil Protection Protocols.
class NationalDisasterMatrix90Cockpit {
  final String operatingJurisdiction;
  final DateTime telemetryTimestamp;
  final int totalOperationalDomainsCount;
  final double compositeNationalReadinessPercent;
  final List<String> activeSectorDirectives;

  const NationalDisasterMatrix90Cockpit({
    required this.operatingJurisdiction,
    required this.telemetryTimestamp,
    required this.totalOperationalDomainsCount,
    required this.compositeNationalReadinessPercent,
    required this.activeSectorDirectives,
  });

  /// Formats the 90-Domain Master National Disaster Management Summary
  String generateNationalMatrixSummary() {
    final buffer = StringBuffer();
    buffer.writeln('================================================================');
    buffer.writeln('  NATIONAL DISASTER MANAGEMENT COMMISSION (NDMC / NDMA)');
    buffer.writeln('  90-Domain Integrated National Civil Protection Operations Matrix');
    buffer.writeln('================================================================');
    buffer.writeln('Jurisdiction: $operatingJurisdiction');
    buffer.writeln('Timestamp: ${telemetryTimestamp.toIso8601String()}');
    buffer.writeln('Total Fully-Integrated Specialized Domains: $totalOperationalDomainsCount');
    buffer.writeln('National Composite Preparedness Index: ${compositeNationalReadinessPercent.toStringAsFixed(1)}%');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('STRATEGIC SECTOR READINESS DIRECTIVES:');
    for (final directive in activeSectorDirectives) {
      buffer.writeln(' • $directive');
    }
    buffer.writeln('================================================================');
    return buffer.toString();
  }
}
