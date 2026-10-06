import 'dart:math' as math;

/// Model representing Bureau of Indian Standards (IS 8452) & EurOtop Manual
/// Coastal Sea Wall & Revetment Wave Overtopping Discharge and Promenade Danger Triage.
enum OvertoppingSafetyZone {
  safePedestrian('Safe for Coastal Pedestrians & Vehicles (< 1 L/s/m)', 0xFF10B981),
  hazardousPedestrian('Hazardous to Pedestrians (1 - 10 L/s/m) - Barricade Promenade', 0xFFFBBF24),
  structuralDamage('Dangerous Overtopping (> 50 L/s/m) - Structural Scour & Inundation Risk', 0xFFEF4444);

  final String description;
  final int colorValue;
  const OvertoppingSafetyZone(this.description, this.colorValue);
}

class SeawallOvertoppingHazard {
  final String seawallSector;
  final double significantWaveHeightHm0;
  final double crestFreeboardRcMeters; // Seawall crest height minus water level
  final double seawallSlopeAngleDegrees;

  const SeawallOvertoppingHazard({
    required this.seawallSector,
    required this.significantWaveHeightHm0,
    required this.crestFreeboardRcMeters,
    required this.seawallSlopeAngleDegrees,
  });

  /// Wave overtopping specific discharge in Litres/second per meter length of seawall (EurOtop formula)
  /// q = sqrt(g * Hm0^3) * 0.067 * exp(-4.75 * Rc / Hm0)
  double get estimatedOvertoppingDischargeLitresPerSecPerMeter {
    if (significantWaveHeightHm0 <= 0.0) return 0.0;
    const g = 9.81;
    final term1 = math.sqrt(g * math.pow(significantWaveHeightHm0, 3));
    final relativeFreeboard = (crestFreeboardRcMeters / significantWaveHeightHm0).clamp(0.0, 5.0);
    final dischargeM3PerSec = term1 * 0.067 * math.exp(-4.75 * relativeFreeboard);
    return (dischargeM3PerSec * 1000.0).clamp(0.0, 500.0); // Convert to L/s/m
  }

  /// Evaluates overtopping safety level
  OvertoppingSafetyZone get safetyStatus {
    final q = estimatedOvertoppingDischargeLitresPerSecPerMeter;
    if (q >= 50.0) {
      return OvertoppingSafetyZone.structuralDamage;
    } else if (q >= 1.0) {
      return OvertoppingSafetyZone.hazardousPedestrian;
    }
    return OvertoppingSafetyZone.safePedestrian;
  }

  /// True if sea-front road / promenade must be sealed to the public
  bool get isPromenadeClosureMandated => safetyStatus != OvertoppingSafetyZone.safePedestrian;
}
