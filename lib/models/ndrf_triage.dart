/// Model representing NDRF & NDMA Incident Command System (ICS)
/// START (Simple Triage and Rapid Treatment) Disaster Field Casualty Classification.
enum TriageTagColor {
  redImmediate(
    category: 'RED (Priority 1 - Immediate)',
    clinicalDefinition: 'Life-threatening injury with high survival probability if treated immediately (Airway compromise, tension pneumothorax, arterial hemorrhage).',
    actionCode: 'Immediate Evac to Advanced Medical Post (AMP)',
    colorValue: 0xFFEF4444,
  ),
  yellowDelayed(
    category: 'YELLOW (Priority 2 - Delayed)',
    clinicalDefinition: 'Serious injury not immediately life-threatening; can tolerate short delay (Closed fractures, large burns without airway compromise).',
    actionCode: 'Urgent Care within 2–4 Hours',
    colorValue: 0xFFF59E0B,
  ),
  greenMinor(
    category: 'GREEN (Priority 3 - Minor)',
    clinicalDefinition: 'Walking wounded with minor lacerations, sprains, or minor contusions.',
    actionCode: 'Self-Care / First Aid Post',
    colorValue: 0xFF10B981,
  ),
  blackExpectant(
    category: 'BLACK (Priority 0 - Expectant / Deceased)',
    clinicalDefinition: 'Unresponsive patient with no spontaneous respirations after opening airway, or catastrophic non-survivable trauma.',
    actionCode: 'Palliative Comfort / Dignified Morgue Protocol',
    colorValue: 0xFF334155,
  );

  final String category;
  final String clinicalDefinition;
  final String actionCode;
  final int colorValue;

  const TriageTagColor({
    required this.category,
    required this.clinicalDefinition,
    required this.actionCode,
    required this.colorValue,
  });
}

class StartTriageEvaluator {
  /// Executes the clinical START algorithm
  static TriageTagColor evaluate({
    required bool canWalk,
    required bool isBreathingAfterAirwayReposition,
    required double respiratoryRatePerMinute,
    required bool radialPulsePresentOrCapillaryRefillUnder2Sec,
    required bool obeysSimpleCommands,
  }) {
    // Step 1: Walking wounded check
    if (canWalk) {
      return TriageTagColor.greenMinor;
    }

    // Step 2: Spontaneous breathing check
    if (!isBreathingAfterAirwayReposition) {
      return TriageTagColor.blackExpectant;
    }

    // Step 3: Respiratory rate (<10 or >30 per min is RED)
    if (respiratoryRatePerMinute > 30 || respiratoryRatePerMinute < 10) {
      return TriageTagColor.redImmediate;
    }

    // Step 4: Perfusion check (Absent radial pulse or Capillary refill > 2 sec is RED)
    if (!radialPulsePresentOrCapillaryRefillUnder2Sec) {
      return TriageTagColor.redImmediate;
    }

    // Step 5: Mental status (Cannot obey commands is RED)
    if (!obeysSimpleCommands) {
      return TriageTagColor.redImmediate;
    }

    // Otherwise patient is stable for delayed treatment
    return TriageTagColor.yellowDelayed;
  }
}
