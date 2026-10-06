import 'dart:math' as math;

/// Model representing PESO & Center for Chemical Process Safety (CCPS)
/// Boiling Liquid Expanding Vapor Explosion (BLEVE) Fireball Diameter, Duration & Thermal Hazard.
class BleveFireballHazard {
  final String plantFacilityName;
  final String chemicalName; // LPG, Propane, Butane, Propylene
  final double flammableMassKilograms;
  final double distanceToPublicBoundaryMeters;

  const BleveFireballHazard({
    required this.plantFacilityName,
    required this.chemicalName,
    required this.flammableMassKilograms,
    required this.distanceToPublicBoundaryMeters,
  });

  /// Maximum Fireball Diameter in meters (D = 5.8 * M^0.33 per CCPS/TNO Yellow Book)
  double get fireballDiameterMeters {
    if (flammableMassKilograms <= 0.0) return 0.0;
    return 5.8 * math.pow(flammableMassKilograms, 0.33);
  }

  /// Fireball Combustion Duration in seconds (t = 0.45 * M^0.33)
  double get fireballDurationSeconds {
    if (flammableMassKilograms <= 0.0) return 0.0;
    return 0.45 * math.pow(flammableMassKilograms, 0.33);
  }

  /// Estimated Thermal Radiation Intensity at public boundary distance (kW/m²)
  /// I approx (eta * M * Hc) / (4 * pi * R^2 * t)
  double calculateThermalRadiationKwPerSqMeter(double distanceMeters) {
    if (distanceMeters <= 10.0 || flammableMassKilograms <= 0.0) return 100.0;
    // Approximated radiative fraction ~0.25, Heat of combustion ~46000 kJ/kg for LPG
    const radiativeHeatTotal = 46000.0 * 0.25;
    final totalRadiationKj = flammableMassKilograms * radiativeHeatTotal;
    final surfaceArea = 4 * math.pi * distanceMeters * distanceMeters;
    final intensityKjPerM2 = totalRadiationKj / surfaceArea;
    return (intensityKjPerM2 / fireballDurationSeconds).clamp(0.1, 250.0);
  }

  /// True if 37.5 kW/m² 100% lethality threshold is breached at public boundary
  bool get isCriticalLethalityBoundaryBreached => calculateThermalRadiationKwPerSqMeter(distanceToPublicBoundaryMeters) >= 37.5;

  /// True if 4.75 kW/m² pain threshold / 2nd degree burn is exceeded at boundary
  bool get isPublicEvacuationMandated => calculateThermalRadiationKwPerSqMeter(distanceToPublicBoundaryMeters) >= 4.75;
}
