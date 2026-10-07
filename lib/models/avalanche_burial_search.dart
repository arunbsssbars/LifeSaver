/// Loop 147: Alpine Avalanche Burial Search & Snow Conveyor Extrication Model
/// Aligned with DGRE / DRDO SASE Guidelines & IKAR International Alpine Rescue protocols.

class AvalancheBurialSearch {
  final double burialDepthMeters; // Depth under packed avalanche snow
  final double burialDurationMinutes;
  final bool isTransceiverBeacon457KhzActive;
  final bool isAirPocketConfirmed;
  final int availableRescuerCount;

  const AvalancheBurialSearch({
    required this.burialDepthMeters,
    required this.burialDurationMinutes,
    required this.isTransceiverBeacon457KhzActive,
    required this.isAirPocketConfirmed,
    required this.availableRescuerCount,
  });

  /// Classical Avalanche Survival Curve:
  /// 0-15 mins: 93% survival (Phase 1: Asphyxiation survival window)
  /// 15-35 mins: Rapid drop to 30% without air pocket
  /// > 35 mins: Plateau only if patent air pocket exists (hypothermia phase)
  double get estimatedSurvivalProbabilityPercent {
    if (burialDurationMinutes <= 15.0) {
      return 93.0;
    } else if (burialDurationMinutes <= 35.0) {
      return isAirPocketConfirmed ? 70.0 : 30.0;
    } else if (burialDurationMinutes <= 90.0) {
      return isAirPocketConfirmed ? 55.0 : 10.0;
    } else {
      return isAirPocketConfirmed ? 25.0 : 2.0;
    }
  }

  /// Estimated volume of snow to excavate for typical burial (Cubic meters)
  /// Excavation volume expands exponentially with burial depth (V = 1.5 * depth^2)
  double get estimatedSnowExcavationVolumeM3 => 1.5 * burialDepthMeters * burialDepthMeters + 1.0;

  /// Tactical Search Phase Guidance (IKAR Standard)
  String get searchPhaseGuidance {
    if (isTransceiverBeacon457KhzActive) {
      return 'SIGNAL SEARCH ACTIVE: Switch all beacons to SEARCH mode. Follow 457 kHz magnetic flux lines with fine bracketing grid search, followed by 90° spiral avalanche probe pinpointing.';
    }
    return 'NO BEACON: Form tight probe line (25 cm spacing) and utilize avalanche rescue dogs / RECCO radar reflectors.';
  }

  /// Strategic Shoveling Conveyor Strategy
  String get strategicShovelingMethod {
    if (burialDepthMeters > 1.0 && availableRescuerCount >= 3) {
      return 'V-SHAPED SNOW CONVEYOR METHOD: Form a V-shaped team downhill from probe. Lead shoveler clears snow sideways while rear shovelers paddle snow downhill to prevent re-burial.';
    }
    return 'RAPID TRENCH DIGGING: Cut 1.5m wide step-trench directly in front of casualty face to secure patent airway immediately.';
  }
}
