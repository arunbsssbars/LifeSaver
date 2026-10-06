/// Model representing NDMA Hospital Safety Guidelines & WHO Hospital Safety Index (HSI).
enum HospitalSafetyCategory {
  categoryA(
    rating: 'Category A (HSI: 0.66 – 1.00)',
    status: 'High Resilience Safe Hospital',
    action: 'Hospital is likely to remain operational and continue emergency healthcare during major disasters.',
    colorValue: 0xFF10B981,
  ),
  categoryB(
    rating: 'Category B (HSI: 0.36 – 0.65)',
    status: 'Moderate Resilience (Interventions Needed)',
    action: 'Hospital will withstand disaster, but equipment and non-structural elements may fail without mitigation.',
    colorValue: 0xFFFBBF24,
  ),
  categoryC(
    rating: 'Category C (HSI: 0.00 – 0.35)',
    status: 'High Vulnerability (Urgent Remediation Required)',
    action: 'Hospital is at high risk of structural/functional collapse. Patients and staff safety compromised.',
    colorValue: 0xFFEF4444,
  );

  final String rating;
  final String status;
  final String action;
  final int colorValue;

  const HospitalSafetyCategory({
    required this.rating,
    required this.status,
    required this.action,
    required this.colorValue,
  });
}

class HospitalResilienceProfile {
  final String hospitalName;
  final int bedCapacity;
  final double structuralScore; // 0.0 to 1.0
  final double nonStructuralScore; // 0.0 to 1.0
  final double emergencyManagementScore; // 0.0 to 1.0
  final int dieselGeneratorFuelReserveHours; // statutory 72h minimum
  final int liquidMedicalOxygenReserveDays;

  const HospitalResilienceProfile({
    required this.hospitalName,
    required this.bedCapacity,
    required this.structuralScore,
    required this.nonStructuralScore,
    required this.emergencyManagementScore,
    required this.dieselGeneratorFuelReserveHours,
    required this.liquidMedicalOxygenReserveDays,
  });

  /// Composite Hospital Safety Index (weighted: 50% structural, 30% non-structural, 20% management)
  double get hospitalSafetyIndex {
    return (structuralScore * 0.50) + (nonStructuralScore * 0.30) + (emergencyManagementScore * 0.20);
  }

  HospitalSafetyCategory get category {
    final hsi = hospitalSafetyIndex;
    if (hsi >= 0.66) return HospitalSafetyCategory.categoryA;
    if (hsi >= 0.36) return HospitalSafetyCategory.categoryB;
    return HospitalSafetyCategory.categoryC;
  }

  /// True if essential reserves meet statutory 72-hour disaster autonomy
  bool get hasSufficient72HourReserves => dieselGeneratorFuelReserveHours >= 72 && liquidMedicalOxygenReserveDays >= 3;
}
