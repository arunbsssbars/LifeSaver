import 'dart:math' as math;

/// Model representing Bureau of Indian Standards (IS 15682) & NFPA 68
/// Combustible Dust Deflagration Severity Index (Kst), Maximum Explosion Pressure (Pmax) & Vent Sizing.
enum DustExplosionClass {
  stClass0('St 0 - Non-Explosive Dust (Kst = 0 bar.m/s)', 0.0),
  stClass1('St 1 - Weak to Moderate Explosion (Kst: 1 - 200 bar.m/s) e.g. Grain, Coal, Sugar', 150.0),
  stClass2('St 2 - Strong Explosion (Kst: 201 - 300 bar.m/s) e.g. Epoxy resins, Cellulose', 250.0),
  stClass3('St 3 - Very Strong / Detonation Hazard (Kst > 300 bar.m/s) e.g. Aluminum, Magnesium dust', 400.0);

  final String description;
  final double representativeKstBarMetersPerSec;
  const DustExplosionClass(this.description, this.representativeKstBarMetersPerSec);
}

class DustExplosionVentingDesign {
  final String plantUnitTag;
  final DustExplosionClass explosionClass;
  final double enclosureVolumeCubicMeters;
  final double enclosurePredBar; // Maximum reduced explosion pressure design of vessel (e.g. 0.5 bar)
  final double providedReliefVentAreaSqMeters;
  final bool hasFlamelessVentMeshAndSparkExtinguisher;

  const DustExplosionVentingDesign({
    required this.plantUnitTag,
    required this.explosionClass,
    required this.enclosureVolumeCubicMeters,
    required this.enclosurePredBar,
    required this.providedReliefVentAreaSqMeters,
    required this.hasFlamelessVentMeshAndSparkExtinguisher,
  });

  /// Required Vent Area (Av in m²) using NFPA 68 simplified venting equation:
  /// Av = C * (V^(2/3)) * sqrt(Kst / Pred)
  double get requiredReliefVentAreaSqMeters {
    if (enclosureVolumeCubicMeters <= 0.0 || enclosurePredBar <= 0.0) return 0.0;
    final vTwoThirds = math.pow(enclosureVolumeCubicMeters, 2.0 / 3.0);
    final kst = explosionClass.representativeKstBarMetersPerSec;
    final ventArea = 0.007 * vTwoThirds * math.sqrt(kst / enclosurePredBar);
    return ventArea.clamp(0.1, 50.0);
  }

  /// True if installed explosion relief panel area is adequate to prevent vessel structural rupture
  bool get isExplosionVentingAdequate => providedReliefVentAreaSqMeters >= requiredReliefVentAreaSqMeters;

  /// True if indoor flameless venting / chemical suppression is statutory mandated (to avoid fireball ejecta in indoor workspaces)
  bool get isFlamelessSuppressionMandated => explosionClass == DustExplosionClass.stClass3 || !hasFlamelessVentMeshAndSparkExtinguisher;
}
