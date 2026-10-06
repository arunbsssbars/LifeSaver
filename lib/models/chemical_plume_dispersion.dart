/// Model representing NDMA Chemical (Terrorism & Industrial) Disaster Management Guidelines
/// and Emergency Response Planning Guidelines (ERPG-1, ERPG-2, ERPG-3) Toxic Plume Radii.
enum ErpgPlumeLevel {
  erpg1(
    levelName: 'ERPG-1 (Mild Odor / Irritation)',
    impact: 'Max airborne concentration below which nearly all individuals could be exposed for up to 1 hour without experiencing other than mild transient adverse health effects.',
    colorValue: 0xFFFBBF24,
  ),
  erpg2(
    levelName: 'ERPG-2 (Irreversible Health Effects Threshold)',
    impact: 'Max airborne concentration below which nearly all individuals could be exposed for up to 1 hour without developing irreversible health effects or symptoms impairing escape.',
    colorValue: 0xFFF97316,
  ),
  erpg3(
    levelName: 'ERPG-3 (Lethal / Life-Threatening Threshold)',
    impact: 'Max airborne concentration below which nearly all individuals could be exposed for up to 1 hour without developing life-threatening health effects.',
    colorValue: 0xFFEF4444,
  );

  final String levelName;
  final String impact;
  final int colorValue;

  const ErpgPlumeLevel({
    required this.levelName,
    required this.impact,
    required this.colorValue,
  });
}

class ChemicalPlumeZone {
  final String toxicChemicalName;
  final double emissionRateKgPerSec;
  final double windSpeedMetersPerSec;
  final double erpg3LethalRadiusKm;
  final double erpg2EvacuationRadiusKm;
  final double erpg1AdvisoryRadiusKm;
  final double plumeDownwindAngleDegrees;

  const ChemicalPlumeZone({
    required this.toxicChemicalName,
    required this.emissionRateKgPerSec,
    required this.windSpeedMetersPerSec,
    required this.erpg3LethalRadiusKm,
    required this.erpg2EvacuationRadiusKm,
    required this.erpg1AdvisoryRadiusKm,
    required this.plumeDownwindAngleDegrees,
  });

  /// Evaluates Gaussian plume toxic dispersion zone for emergency incident commanders
  static ChemicalPlumeZone calculateDispersion({
    required String chemicalName,
    required double releaseQuantityKg,
    required double ambientWindSpeedMs,
  }) {
    final wind = ambientWindSpeedMs.clamp(1.0, 30.0);
    // Empirical dispersion model based on release mass
    final factor = releaseQuantityKg / (wind * 100.0);

    final r3 = (0.2 * factor).clamp(0.1, 5.0);
    final r2 = (0.6 * factor).clamp(0.3, 12.0);
    final r1 = (1.5 * factor).clamp(0.8, 25.0);

    return ChemicalPlumeZone(
      toxicChemicalName: chemicalName,
      emissionRateKgPerSec: releaseQuantityKg / 600.0, // 10 min release duration
      windSpeedMetersPerSec: wind,
      erpg3LethalRadiusKm: r3,
      erpg2EvacuationRadiusKm: r2,
      erpg1AdvisoryRadiusKm: r1,
      plumeDownwindAngleDegrees: 45.0, // standard Pasquill Class D cone angle
    );
  }
}
