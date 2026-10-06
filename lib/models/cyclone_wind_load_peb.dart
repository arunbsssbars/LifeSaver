/// Model representing Bureau of Indian Standards (IS 875 Part 3:2015)
/// Cyclone Wind Load on Industrial Pre-Engineered Buildings (PEB) & Roof Sheeting Suction.
class CycloneWindLoadPeb {
  final String shedFacilityName;
  final double basicWindSpeedVbMs; // e.g. 50 m/s for coastal Zone VI
  final double terrainHeightFactorK2; // 1.05 for Category 2
  final double topographyFactorK3; // 1.0
  final double cyclonicImportanceFactorK4; // 1.30 for industrial structures in coastal cyclone zones
  final double internalPressureCoeffCpi; // +/- 0.5 for industrial sheds with openings
  final double externalSuctionCoeffCpe; // e.g. -1.2 for roof corners/ridges

  const CycloneWindLoadPeb({
    required this.shedFacilityName,
    required this.basicWindSpeedVbMs,
    required this.terrainHeightFactorK2,
    required this.topographyFactorK3,
    required this.cyclonicImportanceFactorK4,
    required this.internalPressureCoeffCpi,
    required this.externalSuctionCoeffCpe,
  });

  /// Design Wind Velocity Vz = Vb * k1 * k2 * k3 * k4 (in m/s, where k1 = 1.0)
  double get designWindVelocityVzMs => basicWindSpeedVbMs * 1.0 * terrainHeightFactorK2 * topographyFactorK3 * cyclonicImportanceFactorK4;

  /// Design Wind Pressure Pz = 0.6 * (Vz^2) in N/m² (Pascals)
  double get designWindPressurePzNPerSqMeter => 0.6 * (designWindVelocityVzMs * designWindVelocityVzMs);

  /// Net Uplift Wind Pressure on Roof Cladding (kN/m²)
  /// Pnet = (Cpe - Cpi) * Pz
  double get netRoofUpliftPressureKiloNewtonsPerSqMeter {
    final netCoeff = (externalSuctionCoeffCpe.abs() + internalPressureCoeffCpi.abs());
    final pnetPascals = netCoeff * designWindPressurePzNPerSqMeter;
    return pnetPascals / 1000.0; // convert N/m2 to kN/m2
  }

  /// True if roof cladding is at critical danger of sheet fly-off during cyclone landfall (> 2.0 kN/m²)
  bool get isCriticalRoofBlowOffRisk => netRoofUpliftPressureKiloNewtonsPerSqMeter > 2.0;
}
