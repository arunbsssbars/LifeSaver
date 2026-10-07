/// Trigeneration energy efficiency performance per BEE / MNRE disaster microgrid standards.
enum CchpEfficiencyGrade {
  highEfficiencyTriGeneration,
  moderateHeatRecovery,
  degradedThermalEfficiency,
  generatorOnlySubOptimal,
}

/// Operational and thermodynamic energy model for Field Hospital Tri-Generation Micro-CCHP Systems.
///
/// Implements Bureau of Energy Efficiency (BEE) and MNRE disaster resilience standards.
/// Formulates:
/// - Electrical power output: P_el = FuelInput * eta_electric
/// - Waste heat recovery for cooling (Absorption Chiller COP ~ 0.70) for vaccine/blood storage: Q_cooling = Q_exhaust * COP_chiller
/// - Waste heat recovery for hot water / medical sterilization: Q_thermal = Q_jacket * eta_heat_exchanger
/// - Primary Energy Savings (PES) % = (1 - (Fuel_CCHP / (P_el/eta_ref_el + Q_th/eta_ref_th + Q_c/COP_ref_c))) * 100
class DisasterCchpTrigeneration {
  final String fieldHospitalUnitTag;
  final double fuelThermalInputKilowatts; // Total fuel energy rate (kW_th)
  final double electricalPowerOutputKw; // P_el generated
  final double recoveredCoolingCapacityKw; // Chilled water output for cold storage & ICU
  final double recoveredHeatingCapacityKw; // Hot water for decontamination/autoclave
  final double dieselFuelStorageRemainingLitres;
  final double fuelConsumptionLitresPerHour;
  final bool isAbsorptionChillerOnline;
  final bool isThermalStorageTankPressurized;

  const DisasterCchpTrigeneration({
    required this.fieldHospitalUnitTag,
    required this.fuelThermalInputKilowatts,
    required this.electricalPowerOutputKw,
    required this.recoveredCoolingCapacityKw,
    required this.recoveredHeatingCapacityKw,
    required this.dieselFuelStorageRemainingLitres,
    required this.fuelConsumptionLitresPerHour,
    this.isAbsorptionChillerOnline = true,
    this.isThermalStorageTankPressurized = true,
  });

  /// Electrical generation efficiency (typically 32% - 38%).
  double get electricalEfficiencyPercent {
    if (fuelThermalInputKilowatts <= 0.0) return 0.0;
    return (electricalPowerOutputKw / fuelThermalInputKilowatts) * 100.0;
  }

  /// Overall combined trigeneration energy utilization efficiency (Electrical + Cooling + Heating) (typically 70% - 85%).
  double get totalThermalUtilizationEfficiencyPercent {
    if (fuelThermalInputKilowatts <= 0.0) return 0.0;
    final totalUsefulEnergy = electricalPowerOutputKw + recoveredCoolingCapacityKw + recoveredHeatingCapacityKw;
    return (totalUsefulEnergy / fuelThermalInputKilowatts) * 100.0;
  }

  /// Primary Energy Savings (PES) percentage relative to separate power grid, chiller, and boiler.
  double get primaryEnergySavingsPercent {
    // Reference efficiencies: eta_el_ref = 0.40, eta_th_ref = 0.85, COP_ref = 3.0
    const double etaElRef = 0.40;
    const double etaThRef = 0.85;
    const double copRef = 3.0;

    final separateFuelEquivalent = (electricalPowerOutputKw / etaElRef) +
        (recoveredHeatingCapacityKw / etaThRef) +
        (recoveredCoolingCapacityKw / (copRef * etaElRef));

    if (separateFuelEquivalent <= 0.0 || fuelThermalInputKilowatts <= 0.0) return 0.0;
    final pes = (1.0 - (fuelThermalInputKilowatts / separateFuelEquivalent)) * 100.0;
    return pes.clamp(0.0, 50.0);
  }

  /// Generator and thermal supply continuous autonomy hours.
  double get operatingAutonomyHours {
    if (fuelConsumptionLitresPerHour <= 0.0) return 0.0;
    return dieselFuelStorageRemainingLitres / fuelConsumptionLitresPerHour;
  }

  /// Evaluates trigeneration performance grade.
  CchpEfficiencyGrade get efficiencyGrade {
    if (!isAbsorptionChillerOnline && recoveredHeatingCapacityKw <= 0.0) {
      return CchpEfficiencyGrade.generatorOnlySubOptimal;
    }
    if (totalThermalUtilizationEfficiencyPercent >= 75.0 && primaryEnergySavingsPercent >= 20.0) {
      return CchpEfficiencyGrade.highEfficiencyTriGeneration;
    }
    if (totalThermalUtilizationEfficiencyPercent >= 55.0) {
      return CchpEfficiencyGrade.moderateHeatRecovery;
    }
    return CchpEfficiencyGrade.degradedThermalEfficiency;
  }

  /// Checks whether the system meets the BEE disaster hospital 48-hour continuous trigeneration compliance.
  bool get isDisasterTrigenerationCompliant {
    return operatingAutonomyHours >= 48.0 &&
        efficiencyGrade == CchpEfficiencyGrade.highEfficiencyTriGeneration;
  }
}
