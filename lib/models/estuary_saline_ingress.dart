/// Model representing Central Ground Water Board (CGWB) & CPHEEO
/// Coastal Aquifer Saline Water Ingress & Drinking Water Salinization Triage.
enum SalineIngressSeverity {
  freshwaterPotable('Potable Freshwater (TDS < 500 mg/L, EC < 750 µS/cm)', 0xFF10B981),
  moderateBrackish('Moderate Salinity (TDS 500-1500 mg/L) - RO Desalination Recommended', 0xFFFBBF24),
  severeSaline('Severe Ingress (TDS > 1500 mg/L) - Direct Human Consumption Prohibited', 0xFFEF4444);

  final String alertMessage;
  final int colorValue;
  const SalineIngressSeverity(this.alertMessage, this.colorValue);
}

class EstuarySalineIngressMonitoring {
  final String coastalWardId;
  final double groundwaterTableHeadMetersAboveSeaLevel;
  final double totalDissolvedSolidsMgPerLitre;
  final double electricalConductivityMicroSiemensPerCm;
  final double chlorideConcentrationMgPerLitre;

  const EstuarySalineIngressMonitoring({
    required this.coastalWardId,
    required this.groundwaterTableHeadMetersAboveSeaLevel,
    required this.totalDissolvedSolidsMgPerLitre,
    required this.electricalConductivityMicroSiemensPerCm,
    required this.chlorideConcentrationMgPerLitre,
  });

  /// Ghyben-Herzberg hydrostatic seawater interface depth (Z = 40 * hf)
  /// For every 1 meter freshwater head above sea level, freshwater lens extends 40 meters below sea level
  double get seawaterInterfaceDepthBelowSeaLevelMeters {
    if (groundwaterTableHeadMetersAboveSeaLevel <= 0.0) return 0.0;
    return groundwaterTableHeadMetersAboveSeaLevel * 40.0;
  }

  /// Evaluates saline ingress severity level
  SalineIngressSeverity get ingressSeverity {
    if (totalDissolvedSolidsMgPerLitre >= 1500.0 || chlorideConcentrationMgPerLitre >= 1000.0) {
      return SalineIngressSeverity.severeSaline;
    } else if (totalDissolvedSolidsMgPerLitre >= 500.0 || chlorideConcentrationMgPerLitre >= 250.0) {
      return SalineIngressSeverity.moderateBrackish;
    }
    return SalineIngressSeverity.freshwaterPotable;
  }

  /// True if coastal tube wells must be shut off to prevent irreversible aquifer salinization
  bool get isTubeWellExtractionHaltMandated => groundwaterTableHeadMetersAboveSeaLevel <= 0.2;
}
