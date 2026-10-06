/// Model representing NDMA Urban Search & Rescue (USAR) Structural Collapse Debris Estimation.
class DisasterDebrisEstimator {
  /// Computes estimated total debris tonnage from building collapses
  /// Tonnage = Building Footprint Area (sq m) * Number of Floors * Structural Density Factor (1.4 Tons/m² for RCC)
  static double calculateRccDebrisTonnage({
    required double buildingFootprintSqMeters,
    required int numberOfFloors,
  }) {
    return buildingFootprintSqMeters * numberOfFloors * 1.4;
  }

  /// Calculates number of 15-ton tipper dumper truck trips needed
  static int calculateTruckTripsRequired({
    required double totalDebrisTonnage,
    double truckPayloadTons = 15.0,
  }) {
    if (truckPayloadTons <= 0) return 0;
    return (totalDebrisTonnage / truckPayloadTons).ceil();
  }

  /// Estimated clearance duration in hours with deployed JCB excavators (each clearing ~45 Tons/hour)
  static double calculateClearanceHours({
    required double totalDebrisTonnage,
    required int excavatorCount,
  }) {
    if (excavatorCount <= 0) return 999.0;
    final totalTph = excavatorCount * 45.0;
    return totalDebrisTonnage / totalTph;
  }
}
