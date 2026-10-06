/// Model representing NDMA & Bureau of Energy Efficiency (BEE)
/// Urban Heat Island (UHI) Mitigation & Cool Roof Implementation Standards.
class UrbanHeatIslandAssessment {
  final String cityWardName;
  final double ambientRuralTemperatureC;
  final double urbanCoreTemperatureC;
  final double roofAreaSqMeters;
  final double solarReflectanceIndex; // SRI >= 78 for cool roofs
  final bool hasHighAlbedoCoolRoofCoating;

  const UrbanHeatIslandAssessment({
    required this.cityWardName,
    required this.ambientRuralTemperatureC,
    required this.urbanCoreTemperatureC,
    required this.roofAreaSqMeters,
    required this.solarReflectanceIndex,
    required this.hasHighAlbedoCoolRoofCoating,
  });

  /// Urban Heat Island Intensity (ΔT = Urban - Rural)
  double get uhiIntensityDeltaC => (urbanCoreTemperatureC - ambientRuralTemperatureC).clamp(0.0, 15.0);

  /// Estimated indoor roof underside temperature reduction from cool roof application (°C)
  /// Cool roofs with SRI >= 78 reduce surface temps by ~20°C and indoor temps by ~3°C to 5°C
  double get estimatedIndoorTemperatureDropC => hasHighAlbedoCoolRoofCoating ? 4.2 : 0.0;

  /// True if ward exhibits severe microclimate overheating (ΔT >= 4.0°C)
  bool get isSevereUhiZone => uhiIntensityDeltaC >= 4.0;

  /// Estimated annual air-conditioning cooling energy savings (kWh)
  double get estimatedAnnualEnergySavingsKwh => hasHighAlbedoCoolRoofCoating ? (roofAreaSqMeters * 12.5) : 0.0;
}
