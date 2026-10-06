import 'dart:math' as math;

/// Model representing NFPA 130 & DMRC Standard for Fixed Guideway Transit Systems
/// Underground Tunnel Smoke Purge Longitudinal Jet Fan Thrust & Egress Tenability.
class MetroJetFanThrustTenability {
  final String metroStationTunnelReach;
  final double tunnelCrossSectionAreaSqMeters;
  final double tunnelPerimeterMeters;
  final int operationalJetFanCount;
  final double thrustPerJetFanNewtons; // Typically 800 to 1200 N per fan
  final double tunnelAirTemperatureCelsius;
  final double egressPathOpticalVisibilityMeters; // Tenability requirement >= 10m
  final double carbonMonoxideConcentrationPpm; // Tenability requirement <= 50 ppm

  const MetroJetFanThrustTenability({
    required this.metroStationTunnelReach,
    required this.tunnelCrossSectionAreaSqMeters,
    required this.tunnelPerimeterMeters,
    required this.operationalJetFanCount,
    required this.thrustPerJetFanNewtons,
    required this.tunnelAirTemperatureCelsius,
    required this.egressPathOpticalVisibilityMeters,
    required this.carbonMonoxideConcentrationPpm,
  });

  /// Total Induced Thrust in Newtons
  double get totalThrustNewtons => operationalJetFanCount * thrustPerJetFanNewtons;

  /// Critical Air Velocity to prevent smoke backlayering (approx 2.5 to 3.0 m/s in DMRC tunnels)
  /// Induced velocity V = sqrt(2 * Total Thrust / (rho * Area * friction factor))
  double get inducedAirVelocityMetersPerSec {
    if (tunnelCrossSectionAreaSqMeters <= 0.0) return 0.0;
    const airDensityRho = 1.2; // kg/m3
    final term = totalThrustNewtons / (airDensityRho * tunnelCrossSectionAreaSqMeters * 0.5);
    return math.sqrt(math.max(0.0, term)).clamp(0.0, 10.0);
  }

  /// True if induced air velocity exceeds critical backlayering velocity (~2.8 m/s)
  bool get isSmokeBacklayeringSuppressed => inducedAirVelocityMetersPerSec >= 2.8;

  /// Tenability compliance status for passenger emergency evacuation (Visibility >= 10m & CO <= 50 ppm & Temp <= 60°C)
  bool get isEgressTenabilityMaintained {
    return egressPathOpticalVisibilityMeters >= 10.0 &&
        carbonMonoxideConcentrationPpm <= 50.0 &&
        tunnelAirTemperatureCelsius <= 60.0;
  }
}
