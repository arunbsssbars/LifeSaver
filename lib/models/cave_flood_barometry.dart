/// Loop 148: Flooded Cave / Mining Tunnel Confined Air Pocket Barometric Survival Model
/// Aligned with British Cave Rescue Council (BCRC) & International Karst Rescue Protocols.

class CaveFloodBarometry {
  final double chamberVolumeM3; // Estimated initial air chamber volume
  final double externalWaterHeadMeters; // Height of floodwater above sump seal
  final int trappedPersonCount;
  final double trappedHoursElapsed;
  final double co2ConcentrationPercent;

  const CaveFloodBarometry({
    required this.chamberVolumeM3,
    required this.externalWaterHeadMeters,
    required this.trappedPersonCount,
    required this.trappedHoursElapsed,
    required this.co2ConcentrationPercent,
  });

  /// Boyle's Law: P1 * V1 = P2 * V2
  /// As flood water seals and rises, air pocket compresses under hydrostatic head (10m water head ~ 1 bar delta)
  double get compressedAirPocketVolumeM3 {
    final absolutePressureBar = 1.0 + (externalWaterHeadMeters / 10.0);
    return chamberVolumeM3 / absolutePressureBar;
  }

  /// Human O2 consumption ~ 25 Liters/hour/person resting; CO2 production ~ 20 Liters/hour/person
  /// Critical CO2 limit is 3.0% (headache/confusion), lethal at > 7.0%
  bool get isCo2ToxicityImminent => co2ConcentrationPercent >= 3.0;

  /// Estimated remaining breathable atmosphere hours
  double get estimatedRemainingHours {
    final availableAirLiters = compressedAirPocketVolumeM3 * 1000.0;
    final totalCo2ProductionPerHour = trappedPersonCount * 20.0;
    if (totalCo2ProductionPerHour <= 0) return 999.0;
    final remainingLitersBefore3Percent = availableAirLiters * 0.03;
    final hours = remainingLitersBefore3Percent / totalCo2ProductionPerHour;
    final remaining = hours - trappedHoursElapsed;
    return remaining > 0.0 ? remaining : 0.0;
  }

  /// Tactical Life Support & Extraction Order
  String get tacticalLifeSupportDirective {
    if (isCo2ToxicityImminent) {
      return 'CRITICAL HYPERCAPNIA: Deploy chemical CO2 lithium hydroxide scrubbers or purge chamber via compressed airline immediately!';
    } else {
      return 'REST & CONSERVE: All trapped survivors must lie still together for body heat conservation, minimize speaking/moving to reduce metabolic O2 consumption.';
    }
  }

  /// Sump diving extraction plan
  String get sumpDivingExtractionPlan =>
      'Lay continuous 9mm static guideline with strobe beacons through flooded sumps. Rescuers escort casualties with positive-pressure full-face masks and ketamine sedation protocol if panic risks airway loss.';
}
