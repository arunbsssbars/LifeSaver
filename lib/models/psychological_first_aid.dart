/// Model representing NIMHANS (National Institute of Mental Health and Neuro Sciences)
/// & NDMA Guidelines on Disaster Mental Health and Psychological First Aid (PFA).
class PsychologicalFirstAidGuide {
  final String title;
  final String objective;
  final List<String> actionableInstructions;

  const PsychologicalFirstAidGuide({
    required this.title,
    required this.objective,
    required this.actionableInstructions,
  });

  static const List<PsychologicalFirstAidGuide> modules = [
    PsychologicalFirstAidGuide(
      title: 'The Core Triad: LOOK, LISTEN, LINK',
      objective: 'Provide immediate, humane, supportive, and practical care to survivors experiencing acute distress.',
      actionableInstructions: [
        'LOOK: Check for safety, people with obvious urgent basic needs, and those with severe distress reactions.',
        'LISTEN: Approach respectfully, ask what they need, listen attentively without pressuring them to talk about traumatic details.',
        'LINK: Help people access basic food/water, reunite with loved ones, connect with Aapda Mitra/NDRF relief, and access medical care.',
      ],
    ),
    PsychologicalFirstAidGuide(
      title: '5-4-3-2-1 Sensory Grounding Technique',
      objective: 'Break acute panic attacks, hyperventilation, and catastrophic dissociation.',
      actionableInstructions: [
        'Acknowledge 5 things you can SEE around you (e.g. wall, door, floor, sky, tree).',
        'Acknowledge 4 things you can physically TOUCH / FEEL (e.g. feet on ground, fabric of shirt, watch on wrist).',
        'Acknowledge 3 things you can HEAR (e.g. wind, voices, distant vehicles).',
        'Acknowledge 2 things you can SMELL (e.g. rain, earth, soap).',
        'Acknowledge 1 positive thing you can TASTE or say to yourself: "I am safe right now in this moment."',
      ],
    ),
    PsychologicalFirstAidGuide(
      title: 'Box Breathing 4-4-4-4 Anti-Panic Method',
      objective: 'Regulate autonomic nervous system and lower elevated heart rate during sirens or tremors.',
      actionableInstructions: [
        'Inhale slowly through your nose for 4 seconds.',
        'Hold your breath comfortably for 4 seconds.',
        'Exhale gently and completely through your mouth for 4 seconds.',
        'Hold your empty lungs for 4 seconds.',
        'Repeat this 4-step cycle 4 to 6 times until physiological calmness is restored.',
      ],
    ),
  ];
}
