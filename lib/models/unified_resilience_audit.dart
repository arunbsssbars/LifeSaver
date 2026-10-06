/// Model representing the Grand Master Unified Multi-Hazard Resilience Index & Statutory Audit Report
/// synthesizing all 29 disaster dimensions into a normalized 0–100 Resilience Score for District Magistrates & SDMAs.
class DisasterDomainScore {
  final String domainName;
  final double scoreOutOf100;
  final String statusLabel;
  final bool isStatutoryCompliant;

  const DisasterDomainScore({
    required this.domainName,
    required this.scoreOutOf100,
    required this.statusLabel,
    required this.isStatutoryCompliant,
  });
}

class UnifiedResilienceReport {
  final String districtOrRegionName;
  final DateTime auditedAt;
  final double overallResilienceIndexScore; // 0 to 100
  final List<DisasterDomainScore> domainBreakdowns;
  final List<String> priorityExecutiveDirectives;

  const UnifiedResilienceReport({
    required this.districtOrRegionName,
    required this.auditedAt,
    required this.overallResilienceIndexScore,
    required this.domainBreakdowns,
    required this.priorityExecutiveDirectives,
  });

  /// Generates a standardized District Disaster Management Authority (DDMA) Statutory Audit Report Text
  String generateStatutoryAuditReportText() {
    final buffer = StringBuffer();
    buffer.writeln('================================================================');
    buffer.writeln('  DDMA / SDMA STATUTORY DISASTER RESILIENCE & PREPAREDNESS AUDIT');
    buffer.writeln('  Conforming to Disaster Management Act, 2005 & NDMA Directives');
    buffer.writeln('================================================================');
    buffer.writeln('Target Sector: $districtOrRegionName');
    buffer.writeln('Audit Timestamp: ${auditedAt.toIso8601String()}');
    buffer.writeln('Overall Multi-Hazard Resilience Score: ${overallResilienceIndexScore.toStringAsFixed(1)} / 100');
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('DOMAINS ASSESSED:');
    for (final domain in domainBreakdowns) {
      final mark = domain.isStatutoryCompliant ? '[COMPLIANT]' : '[ATTENTION REQUIRED]';
      buffer.writeln(' • ${domain.domainName.padRight(40)} : ${domain.scoreOutOf100.toStringAsFixed(0)}% ($mark)');
    }
    buffer.writeln('----------------------------------------------------------------');
    buffer.writeln('PRIORITY EXECUTIVE DIRECTIVES FOR DISTRICT MAGISTRATE / DEOC:');
    for (var i = 0; i < priorityExecutiveDirectives.length; i++) {
      buffer.writeln(' ${i + 1}. ${priorityExecutiveDirectives[i]}');
    }
    buffer.writeln('================================================================');
    return buffer.toString();
  }
}
