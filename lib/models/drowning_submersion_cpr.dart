/// Loop 159: Coastal & Floodwater Drowning Hypoxic Arrest & Resuscitation Model
/// Aligned with International Life Saving Federation (ILSF), European Resuscitation Council (ERC) & AHA Drowning Guidelines.

class DrowningSubmersionCpr {
  final double submersionDurationMinutes;
  final bool isVictimApneicOrPulseless;
  final bool isWaterFrothInAirwayPresent;
  final bool isCervicalSpineTraumaSuspected; // e.g. shallow water diving injury
  final double victimCoreTemperatureCelsius;

  const DrowningSubmersionCpr({
    required this.submersionDurationMinutes,
    required this.isVictimApneicOrPulseless,
    required this.isWaterFrothInAirwayPresent,
    required this.isCervicalSpineTraumaSuspected,
    required this.victimCoreTemperatureCelsius,
  });

  /// Primary Pathophysiology: Drowning cardiac arrest is primary HYPOXIA (asphyxia), not primary ventricular fibrillation.
  /// Airway and ventilation take precedence over compression-only CPR!
  int get initialRescueBreathsCount => 5;

  /// Compression to Ventilation Ratio
  int get compressionRatio => 30;
  int get ventilationRatio => 2;

  /// Tactical Drowning Resuscitation Protocol
  String get tacticalResuscitationProtocol {
    if (isVictimApneicOrPulseless) {
      return 'HYPOXIC ARREST PROTOCOL: Deliver 5 INITIAL RESCUE BREATHS FIRST to re-oxygenate lungs, followed by standard 30 compressions : 2 breaths CPR with high-flow supplemental oxygen and AED!';
    }
    return 'Spontaneous breathing present: Place in recovery position on side to drain airway secretions, administer humidified oxygen via non-rebreather mask, monitor for acute pulmonary edema.';
  }

  /// Airway Froth Management Rule
  String get airwayFrothManagementRule {
    if (isWaterFrothInAirwayPresent) {
      return 'FROTH IN MOUTH: Do NOT waste time attempting to suction pulmonary edema foam deep in throat; wipe mouth quickly and continue positive pressure ventilations directly through froth.';
    }
    return 'Airway clear. Maintain jaw-thrust maneuver if cervical spine trauma suspected.';
  }

  /// Secondary Drowning / Pulmonary Edema Warning
  String get secondaryDrowningWarning =>
      'CRITICAL POST-RESCUE RULE: Any drowning victim who inhaled water MUST be hospitalized for minimum 6-8 hours monitoring, even if fully conscious, due to risk of delayed acute respiratory distress syndrome (ARDS) and surfactant washout.';
}
