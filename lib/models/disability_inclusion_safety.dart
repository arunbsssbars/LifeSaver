/// Model representing NDMA National Guidelines on Disability-Inclusive Disaster Risk Reduction (DiDRR)
/// for Persons with Disabilities (Divyangjan) and vulnerable demographics.
enum DisabilityCategory {
  locomotor('Locomotor Disability / Wheelchair User'),
  visualImpairment('Visual Impairment / Blindness'),
  hearingImpairment('Hearing & Speech Impairment / Deaf'),
  intellectualNeurodivergent('Intellectual / Neurodivergent / Autism'),
  chronicMedicalNeeds('Chronic Life-Support / Dialysis / Oxygen Dependency');

  final String label;
  const DisabilityCategory(this.label);
}

class DisabilityEvacuationGuide {
  final DisabilityCategory category;
  final String title;
  final List<String> mandatoryAccommodations;

  const DisabilityEvacuationGuide({
    required this.category,
    required this.title,
    required this.mandatoryAccommodations,
  });

  static const List<DisabilityEvacuationGuide> inclusionProtocols = [
    DisabilityEvacuationGuide(
      category: DisabilityCategory.locomotor,
      title: 'Wheelchair & Locomotor Mobility Protocol',
      mandatoryAccommodations: [
        'Never separate a person from their wheelchair, crutches, or prosthetic device during transport.',
        'Evacuation paths must utilize ramps with slope ratio not exceeding 1:12.',
        'If carrying down stairs, use dedicated 2-person evacuation chair or blanket drag with head support.',
      ],
    ),
    DisabilityEvacuationGuide(
      category: DisabilityCategory.visualImpairment,
      title: 'Visual Impairment & Guide Dog Safety',
      mandatoryAccommodations: [
        'Verbally identify yourself and offer your elbow for sighted guide assistance; do NOT pull them by the wrist.',
        'Describe terrain obstacles, steps up/down, and narrow doorways clearly in advance.',
        'Evacuate guide animals alongside the individual; service dogs are legally allowed inside relief shelters.',
      ],
    ),
    DisabilityEvacuationGuide(
      category: DisabilityCategory.hearingImpairment,
      title: 'Deaf / Hard of Hearing Visual Strobe Alerts',
      mandatoryAccommodations: [
        'Use high-intensity flashing LED strobes and bold written cards (audio sirens are ineffective).',
        'Maintain face-to-face visual eye contact with clear enunciation for lip reading.',
        'Utilize simple standardized hand gestures or the app\'s visual SOS phrase flashcards.',
      ],
    ),
    DisabilityEvacuationGuide(
      category: DisabilityCategory.chronicMedicalNeeds,
      title: 'Cold-Chain Medication & Power-Dependent Medical Support',
      mandatoryAccommodations: [
        'Ensure insulin and vaccines are transported in insulated ice-pack vaccine carriers (2°C to 8°C).',
        'Priority tagging for emergency shelter backup generators (oxygen concentrators, home dialysis).',
        'Maintain a 14-day supply of life-maintaining prescription medications in waterproof pouch.',
      ],
    ),
  ];
}
