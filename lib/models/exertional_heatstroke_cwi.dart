/// Loop 158: Exertional Heatstroke Rapid Cold Water Immersion (CWI) Resuscitation Model
/// Aligned with NDMA National Heat Action Plan, MoHFW & Wilderness Medical Society (WMS) Guidelines.

class ExertionalHeatstrokeCwi {
  final double coreBodyTemperatureCelsius; // Rectal / esophageal core temp (> 40.0°C / 104°F)
  final bool hasCentralNervousSystemDysfunction; // Delirium, seizure, stupor, coma
  final double minutesUntilCoolingInitiated;
  final bool isIceWaterBathAvailable;
  final double waterTubTemperatureCelsius; // Target 1°C - 15°C for rapid conduction

  const ExertionalHeatstrokeCwi({
    required this.coreBodyTemperatureCelsius,
    required this.hasCentralNervousSystemDysfunction,
    required this.minutesUntilCoolingInitiated,
    required this.isIceWaterBathAvailable,
    required this.waterTubTemperatureCelsius,
  });

  /// Heatstroke Diagnosis: Core Temp >= 40.0°C + CNS Dysfunction
  bool get isTrueHeatstrokeEmergency =>
      coreBodyTemperatureCelsius >= 40.0 && hasCentralNervousSystemDysfunction;

  /// Cooling Rate (°C per minute): Cold water immersion cools at 0.15 - 0.25°C/min (fastest medical method)
  double get estimatedCoolingRateCPerMin {
    if (isIceWaterBathAvailable && waterTubTemperatureCelsius <= 10.0) {
      return 0.20; // Rapid conduction
    } else if (isIceWaterBathAvailable) {
      return 0.15;
    } else {
      return 0.05; // Evaporative misting only
    }
  }

  /// Target Core Temperature to cease active immersion (to prevent hypothermic overshoot)
  static const double cessationTargetTemperatureCelsius = 38.6;

  /// Estimated minutes to reach safe temperature (38.6°C)
  double get estimatedCoolingDurationMinutes {
    final tempDiff = coreBodyTemperatureCelsius - cessationTargetTemperatureCelsius;
    if (tempDiff <= 0) return 0.0;
    return tempDiff / estimatedCoolingRateCPerMin;
  }

  /// Clinical Resuscitation Protocol ("Cool First, Transport Second")
  String get clinicalResuscitationProtocol {
    if (isTrueHeatstrokeEmergency) {
      if (isIceWaterBathAvailable) {
        return 'COOL FIRST, TRANSPORT SECOND: Submerge torso and limbs in ice-water tub (${waterTubTemperatureCelsius.toStringAsFixed(0)}°C) with head supported. Stir water continuously to maintain thermal gradient for ~${estimatedCoolingDurationMinutes.toStringAsFixed(0)} mins until core temp reaches 38.6°C.';
      } else {
        return 'TACO METHOD (Tarp-Assisted Cooling): Place victim in waterproof tarp with 4-5 bags of crushed ice and cold water, oscillate tarp back and forth to circulate cold slurry over skin, apply cold wet towels to neck, axillae, and groin.';
      }
    }
    return 'Heat exhaustion: Move to shaded air-conditioned area, elevate legs, sip chilled oral rehydration salts (ORS), monitor vitals.';
  }

  /// Critical Clinical Contraindications
  String get clinicalContraindicationWarning =>
      'STRICT WARNING: Do NOT administer Paracetamol/Acetaminophen or Aspirin (antipyretics are ineffective in heatstroke and worsen liver/renal injury & coagulopathy).';
}
