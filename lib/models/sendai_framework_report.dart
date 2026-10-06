/// Model representing UNDRR Sendai Framework for Disaster Risk Reduction (2015–2030)
/// National Disaster Database Statutory Indicators (Targets A to G) adopted by NDMA.
class SendaiTargetProgress {
  final String targetCode;
  final String targetTitle;
  final String indicatorMetric;
  final double currentYearValue;
  final double baselineTenYearAverage;
  final bool isTargetMetOrImproving;

  const SendaiTargetProgress({
    required this.targetCode,
    required this.targetTitle,
    required this.indicatorMetric,
    required this.currentYearValue,
    required this.baselineTenYearAverage,
    required this.isTargetMetOrImproving,
  });

  /// Computes percentage reduction / improvement relative to 10-year baseline
  double get percentageChangeFromBaseline {
    if (baselineTenYearAverage == 0) return 0.0;
    return ((currentYearValue - baselineTenYearAverage) / baselineTenYearAverage) * 100.0;
  }
}

class NationalSendaiScorecard {
  final String administrativeEntity;
  final int reportingYear;
  final List<SendaiTargetProgress> targets;

  const NationalSendaiScorecard({
    required this.administrativeEntity,
    required this.reportingYear,
    required this.targets,
  });

  /// Generates the official Sendai Framework Target Compliance Manifest Text
  String generateSendaiComplianceManifest() {
    final buffer = StringBuffer();
    buffer.writeln('================================================================');
    buffer.writeln('  NATIONAL SENDAI FRAMEWORK STATUTORY DISASTER SCORECARD');
    buffer.writeln('  Conforming to UNDRR & NDMA National Disaster Management Plan');
    buffer.writeln('================================================================');
    buffer.writeln('Entity / State: $administrativeEntity | Reporting Year: $reportingYear');
    buffer.writeln('----------------------------------------------------------------');
    for (final t in targets) {
      final status = t.isTargetMetOrImproving ? '[ON TRACK / REDUCING]' : '[ELEVATED RISK]';
      buffer.writeln('${t.targetCode} - ${t.targetTitle}:');
      buffer.writeln('   Metric: ${t.indicatorMetric}');
      buffer.writeln('   Current: ${t.currentYearValue.toStringAsFixed(1)} (Baseline: ${t.baselineTenYearAverage.toStringAsFixed(1)}) | Change: ${t.percentageChangeFromBaseline.toStringAsFixed(1)}% $status');
    }
    buffer.writeln('================================================================');
    return buffer.toString();
  }
}
