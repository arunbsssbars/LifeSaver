/// Loop 154: High-Density Crowd Surge & Traumatic Asphyxia Boxer Stance Model
/// Aligned with NDMA Crowd Management Guidelines & Fruin's Pedestrian Flow Physics.

class StampedeCrushDefense {
  final double crowdDensityPersonsPerM2; // Critical threshold > 4.0 p/m2, lethal shockwaves > 6.0 p/m2
  final double crowdSpeedMps;
  final bool isPersonKnockedToGround;
  final bool hasBoxerStanceAdopted;
  final double bottleneckWidthMeters;

  const StampedeCrushDefense({
    required this.crowdDensityPersonsPerM2,
    required this.crowdSpeedMps,
    required this.isPersonKnockedToGround,
    required this.hasBoxerStanceAdopted,
    required this.bottleneckWidthMeters,
  });

  /// Compressive Force Generated in high-density surge (Newtons)
  /// At 6-8 persons/m2, compressive forces exceed 4,000 N (~900 lbs), bending steel railings & crushing lungs!
  double get estimatedCompressiveForceNewtons {
    if (crowdDensityPersonsPerM2 < 3.0) {
      return 100.0;
    } else if (crowdDensityPersonsPerM2 < 5.0) {
      return 1200.0;
    } else if (crowdDensityPersonsPerM2 < 7.0) {
      return 3500.0;
    } else {
      return 4500.0;
    }
  }

  /// Traumatic asphyxia risk tier
  String get asphyxiaRiskTier {
    if (crowdDensityPersonsPerM2 >= 6.0) {
      return 'CRITICAL RED — Turbulent Crowd Shockwave / Fatal Compressive Asphyxia Risk';
    } else if (crowdDensityPersonsPerM2 >= 4.0) {
      return 'HIGH AMBER — Severe Stop-and-Go Compression';
    } else {
      return 'MODERATE YELLOW — Dense Flow';
    }
  }

  /// Tactical Self-Defense Posture (Standing)
  String get standingDefensivePosture {
    return 'BOXER STANCE (CHEST EXPANSION): Bring arms up to chest, clench fists with forearms locked against ribs like a boxer. This creates a rigid 15 cm survival breathing cage around your lungs to prevent ribcage collapse.';
  }

  /// Tactical Fall Recovery (If knocked down)
  String get fallenSurvivalPosture {
    if (isPersonKnockedToGround) {
      return 'FALLEN IN SURGE: Immediately curl into FETAL POSITION on your left side, tuck knees to chest, wrap arms tightly around your head and neck to protect carotid arteries and skull from trampling until surge pauses.';
    }
    return 'Maintain upright balance: Keep feet staggered (one forward, one back) with knees slightly bent. NEVER stop to pick up dropped items.';
  }

  /// Flow Navigation Directive
  String get flowNavigationDirective =>
      'DO NOT FIGHT AGAINST THE FLOW: Move diagonally across the crowd drift toward the outer perimeter or solid pillar pockets.';
}
