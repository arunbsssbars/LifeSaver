/// Model representing CSIR-NEERI & Bureau of Indian Standards (IS 10500:2012)
/// Community Emergency Water Treatment Coagulation, Turbidity & Heavy Metal (Arsenic/Iron) Removal.
class CommunityWaterCoagulationAudit {
  final String treatmentPlantLocation;
  final double rawWaterTurbidityNtu;
  final double alumOrPacDosageMgPerLitre;
  final double rawWaterArsenicMgPerLitre; // IS 10500 limit <= 0.01 mg/L
  final double rawWaterIronMgPerLitre; // IS 10500 limit <= 0.3 mg/L
  final double flocculatorHydraulicRetentionMinutes;

  const CommunityWaterCoagulationAudit({
    required this.treatmentPlantLocation,
    required this.rawWaterTurbidityNtu,
    required this.alumOrPacDosageMgPerLitre,
    required this.rawWaterArsenicMgPerLitre,
    required this.rawWaterIronMgPerLitre,
    required this.flocculatorHydraulicRetentionMinutes,
  });

  /// Settled Post-Clarification Turbidity in NTU (Alum/PAC coagulation reduces turbidity by 95% if retention >= 20 mins)
  double get estimatedTreatedTurbidityNtu {
    if (flocculatorHydraulicRetentionMinutes < 10.0) return rawWaterTurbidityNtu * 0.4;
    return (rawWaterTurbidityNtu * 0.05).clamp(0.5, 10.0);
  }

  /// Arsenic Co-precipitation Removal Efficiency (Alum/PAC coagulation removes up to 90% of As(V) via ferric/alum flocs)
  double get estimatedTreatedArsenicMgPerLitre {
    return (rawWaterArsenicMgPerLitre * 0.10).clamp(0.001, 1.0);
  }

  /// Iron Precipitation Removal Efficiency (Aeration + coagulation achieves 95% Fe removal)
  double get estimatedTreatedIronMgPerLitre {
    return (rawWaterIronMgPerLitre * 0.05).clamp(0.01, 5.0);
  }

  /// True if treated water meets statutory IS 10500 drinking water potable limits
  bool get isPotableStandardAchieved {
    return estimatedTreatedTurbidityNtu <= 5.0 &&
        estimatedTreatedArsenicMgPerLitre <= 0.01 &&
        estimatedTreatedIronMgPerLitre <= 0.3;
  }
}
