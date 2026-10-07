/// Loop 141: NDMA / NDRF National Borewell Rescue Telemetry & Life-Support Model
/// Aligned with NDMA Borewell Incident SOP & Ministry of Jal Shakti guidelines.

class BorewellRescueTelemetry {
  final double boreholeDepthMeters;
  final double casualtyTrappedDepthMeters;
  final double casingDiameterInches;
  final double oxygenFlowRateLitersPerMin;
  final double ambientTemperatureCelsius;
  final double parallelPitDepthMeters;
  final bool isAudioVisualContactEstablished;
  final bool hasPneumaticCapsuleDeployed;

  const BorewellRescueTelemetry({
    required this.boreholeDepthMeters,
    required this.casualtyTrappedDepthMeters,
    required this.casingDiameterInches,
    required this.oxygenFlowRateLitersPerMin,
    required this.ambientTemperatureCelsius,
    required this.parallelPitDepthMeters,
    required this.isAudioVisualContactEstablished,
    required this.hasPneumaticCapsuleDeployed,
  });

  /// Recommended oxygen pumping rate is >= 15.0 L/min for deep shaft survival
  bool get isOxygenSupplyAdequate => oxygenFlowRateLitersPerMin >= 15.0;

  /// Parallel rescue pit remaining depth to reach casualty horizontal tunnel level
  double get remainingParallelPitMeters {
    final diff = casualtyTrappedDepthMeters - parallelPitDepthMeters;
    return diff > 0.0 ? diff : 0.0;
  }

  /// Estimated horizontal tunnel breakthrough distance
  double get horizontalTunnelDistanceMeters => 2.5; // Standard 2.5m safety standoff

  /// Risk classification based on depth, casing diameter, and oxygen supply
  String get rescueRiskTier {
    if (casualtyTrappedDepthMeters > 30.0 || !isOxygenSupplyAdequate) {
      return 'CRITICAL RED — Deep Trapping / Asphyxia Risk';
    } else if (casualtyTrappedDepthMeters > 15.0) {
      return 'HIGH AMBER — Deep Extraction in Progress';
    } else {
      return 'MODERATE YELLOW — Shallow Retrieval Range';
    }
  }

  /// Tactical operational advice for incident command
  String get incidentCommandDirective {
    if (!isOxygenSupplyAdequate) {
      return 'URGENT: Increase continuous medical oxygen supply to >= 18 L/min immediately via flexible micro-hose!';
    }
    if (!isAudioVisualContactEstablished) {
      return 'Deploy high-resolution night-vision micro-camera with audio transducer down the shaft.';
    }
    if (remainingParallelPitMeters > 0.0) {
      return 'Continue mechanical / manual parallel drilling (${remainingParallelPitMeters.toStringAsFixed(1)}m remaining) with continuous casing stabilization.';
    }
    return 'Parallel pit aligned. Commence cautious horizontal manual tunneling with laser distance guidance.';
  }
}
