/// Loop 157: High-Rise Balcony & Window Ledge Mechanical Advantage Rope Rescue Model
/// Aligned with NDRF USAR Rope Rescue Guidelines & INSARAG High-Angle Rescue standards.

class HighRiseRopeRigging {
  final double ledgeHeightMeters; // Height above ground level
  final int strandedSurvivorCount;
  final double mainRopeBreakingStrengthKn; // Standard 11mm static kernmantle ~ 30 kN
  final int mechanicalAdvantageRatio; // 3:1 (Z-rig), 4:1, 5:1
  final bool isEdgeRollerPadDeployed;
  final bool isTwoPointBombproofAnchorRigged;

  const HighRiseRopeRigging({
    required this.ledgeHeightMeters,
    required this.strandedSurvivorCount,
    required this.mainRopeBreakingStrengthKn,
    required this.mechanicalAdvantageRatio,
    required this.isEdgeRollerPadDeployed,
    required this.isTwoPointBombproofAnchorRigged,
  });

  /// Standard Rescue Safety Factor (10:1 for human rescue load ~ 2.2 kN load $\implies$ 22 kN minimum rope)
  bool get isRopeSafetyFactorAdequate => mainRopeBreakingStrengthKn >= 22.0;

  /// Effective Haul Force Required (per 80 kg rescuer + casualty ~ 160 kg ~ 1.6 kN)
  double get estimatedRescuerHaulForceNewtons {
    const loadN = 1600.0;
    final ratio = mechanicalAdvantageRatio > 0 ? mechanicalAdvantageRatio : 1;
    return loadN / ratio;
  }

  /// Tactical Rigging Deployment Directive
  String get tacticalRiggingDirective {
    if (!isTwoPointBombproofAnchorRigged) {
      return 'CRITICAL ANCHOR SAFETY: Rig multi-point load-sharing equalized anchors (angle < 60°) on reinforced concrete structural columns or load-bearing beams before edge approach.';
    }
    if (!isEdgeRollerPadDeployed) {
      return 'Deploy heavy-duty canvas edge protectors and articulated edge rollers over sharp masonry parapet to prevent rope sheath abrasion.';
    }
    return 'Anchor and edge secured. Lower pick-off rescuer with rescue harness/triangle, clip casualty directly into master belay ring, and haul via $mechanicalAdvantageRatio:1 Z-Rig mechanical advantage system.';
  }

  /// Survivor Ledge Guidance
  String get survivorLedgeGuidance =>
      'Instruct stranded survivors on balcony/ledge: Sit down against building wall, do not look down, do not attempt to jump onto awnings, and wait for rescuer pick-off harness.';
}
