import 'dart:math' as math;

/// Storage risk classification per PESO Ammonium Nitrate Rules 2012.
enum AmmoniumNitrateSafetyRating {
  fullyCompliant,
  moderateBufferDeficit,
  severeInhabitedEncroachment,
  criticalFireRisk,
}

/// Safety assessment model for Ammonium Nitrate Storage & Warehouse Protection.
///
/// Implements PESO (Petroleum and Explosives Safety Organisation) Ammonium Nitrate Rules 2012 & Static & Mobile Pressure Vessels Rules.
/// Formulates:
/// - Inhabited Building Safe Distance (ISD): D = k * Q^(1/3)
///   Where k = 15.0 for standard solid ammonium nitrate storage, Q = stored net mass in kg.
/// - Mandatory combustible separation distance >= 15.0 meters.
/// - Flameproof ventilation, automatic high-velocity water deluge density >= 10.0 L/min/m^2.
class AmmoniumNitrateStorageSafety {
  final String warehouseFacilityId;
  final String locationDistrict;
  final double storedQuantityTonnes;
  final double providedClearanceToInhabitedDwellingsMeters;
  final double distanceToCombustibleMaterialMeters;
  final double waterDelugeSprinklerDensityLpmPerSqM;
  final bool hasNonCombustibleConcreteStructure;
  final bool hasDedicatedVentilationLouvres;
  final bool isStoredInBagsOnWoodenPallets; // False if treated non-wooden/flame-retardant pallets

  const AmmoniumNitrateStorageSafety({
    required this.warehouseFacilityId,
    required this.locationDistrict,
    required this.storedQuantityTonnes,
    required this.providedClearanceToInhabitedDwellingsMeters,
    required this.distanceToCombustibleMaterialMeters,
    required this.waterDelugeSprinklerDensityLpmPerSqM,
    required this.hasNonCombustibleConcreteStructure,
    required this.hasDedicatedVentilationLouvres,
    this.isStoredInBagsOnWoodenPallets = false,
  });

  /// Calculates mandatory safe separation distance to inhabited buildings in meters.
  /// D_req = 15.0 * (Q_kg)^(1/3)
  double get requiredInhabitedBuildingSafeDistanceMeters {
    final quantityKg = storedQuantityTonnes * 1000.0;
    if (quantityKg <= 0.0) return 0.0;
    return 15.0 * math.pow(quantityKg, 1.0 / 3.0);
  }

  /// Calculates safety buffer compliance margin in meters.
  double get separationBufferMarginMeters {
    return providedClearanceToInhabitedDwellingsMeters - requiredInhabitedBuildingSafeDistanceMeters;
  }

  /// Checks if minimum 15m isolation from combustible materials is respected.
  bool get isCombustibleIsolationAdequate {
    return distanceToCombustibleMaterialMeters >= 15.0 && !isStoredInBagsOnWoodenPallets;
  }

  /// Checks if water deluge density meets the 10.0 L/min/m^2 firefighting standard.
  bool get isFireDelugeAdequate {
    return waterDelugeSprinklerDensityLpmPerSqM >= 10.0;
  }

  /// Evaluates statutory PESO safety rating.
  AmmoniumNitrateSafetyRating get safetyRating {
    if (!hasNonCombustibleConcreteStructure || isStoredInBagsOnWoodenPallets || !isFireDelugeAdequate) {
      return AmmoniumNitrateSafetyRating.criticalFireRisk;
    }
    if (providedClearanceToInhabitedDwellingsMeters < (0.75 * requiredInhabitedBuildingSafeDistanceMeters)) {
      return AmmoniumNitrateSafetyRating.severeInhabitedEncroachment;
    }
    if (providedClearanceToInhabitedDwellingsMeters < requiredInhabitedBuildingSafeDistanceMeters || !isCombustibleIsolationAdequate) {
      return AmmoniumNitrateSafetyRating.moderateBufferDeficit;
    }
    return AmmoniumNitrateSafetyRating.fullyCompliant;
  }

  /// Evaluates whether the facility is certified for operation under PESO rules.
  bool get isPesoStorageCertified {
    return safetyRating == AmmoniumNitrateSafetyRating.fullyCompliant;
  }
}
