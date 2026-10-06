/// Model representing MoHFW & PESO Guidelines for Hospital Liquid Medical Oxygen (LMO)
/// Cryogenic Storage, Manifold Buffer Capacity, and Disaster Autonomy Hours.
class HospitalOxygenReserve {
  final String hospitalName;
  final double cryogenicTankCapacityKilolitres;
  final double currentLiquidOxygenLevelPercent;
  final int totalOccupiedIcuVentilatorBeds;
  final int totalOccupiedHighFlowOxygenBeds;
  final double manifoldDTypeCylinderCount;

  const HospitalOxygenReserve({
    required this.hospitalName,
    required this.cryogenicTankCapacityKilolitres,
    required this.currentLiquidOxygenLevelPercent,
    required this.totalOccupiedIcuVentilatorBeds,
    required this.totalOccupiedHighFlowOxygenBeds,
    required this.manifoldDTypeCylinderCount,
  });

  /// Total Gas Volume Available in Litres (1 Litre Liquid O2 expands to ~860 Litres Gas)
  double get totalGaseousOxygenLitres {
    final liquidLitres = (cryogenicTankCapacityKilolitres * 1000.0) * (currentLiquidOxygenLevelPercent / 100.0);
    final cryogenicGas = liquidLitres * 860.0;
    // Each D-Type jumbo cylinder holds approx 7000 Litres of gaseous O2
    final manifoldGas = manifoldDTypeCylinderCount * 7000.0;
    return cryogenicGas + manifoldGas;
  }

  /// Total Oxygen Consumption Rate in Litres/Minute
  /// (Ventilator ~ 15 L/min; HFNC/Mask ~ 10 L/min)
  double get totalConsumptionRateLitresPerMinute {
    return (totalOccupiedIcuVentilatorBeds * 15.0) + (totalOccupiedHighFlowOxygenBeds * 10.0);
  }

  /// Autonomy Hours remaining before complete depletion
  double get remainingAutonomyHours {
    if (totalConsumptionRateLitresPerMinute <= 0.0) return 999.0;
    final totalMinutes = totalGaseousOxygenLitres / totalConsumptionRateLitresPerMinute;
    return (totalMinutes / 60.0).clamp(0.0, 999.0);
  }

  /// True if LMO tanker refilling is critically urgent (Autonomy < 24 hours per MoHFW standard)
  bool get isCriticalRefillAlert => remainingAutonomyHours < 24.0;
}
