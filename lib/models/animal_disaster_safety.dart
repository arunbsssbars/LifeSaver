/// Model representing NDMA Action Plan on Disaster Management for Animals & Livestock
/// and National Snakebite Management Protocol (Anti-Snake Venom - ASV guidance).
class AnimalDisasterProtocol {
  final String title;
  final String targetGroup;
  final List<String> protocols;

  const AnimalDisasterProtocol({
    required this.title,
    required this.targetGroup,
    required this.protocols,
  });

  static const List<AnimalDisasterProtocol> actionPlans = [
    AnimalDisasterProtocol(
      title: 'Livestock Flood & Cyclone Evacuation SOP',
      targetGroup: 'Cattle, Buffaloes, Goats, Poultry',
      protocols: [
        'CRITICAL: UNTIE ALL LIVESTOCK if rising floodwaters approach. Tied cattle drown when waters rise.',
        'Herding to designated high-ground cattle shelters (*Khurak/Pashu Rahat Shivir*) pre-identified by SDMA.',
        'Keep dry fodder bundles (*Bhusa/Kadbi*) wrapped in tarpaulin on elevated wooden platforms.',
        'Vaccinate surviving livestock against Hemorrhagic Septicemia (HS) and Anthrax immediately post-flood.',
      ],
    ),
    AnimalDisasterProtocol(
      title: 'Disaster Zone Snakebite Management (ASV Protocol)',
      targetGroup: 'Humans, Pets & Working Animals',
      protocols: [
        'DO NOT tie arterial tourniquets, cut the wound, or attempt suction (causes necrosis and gangrene).',
        'DO NOT apply ice packs, potassium permanganate, or herbal pastes.',
        'IMMOBILIZE the bitten limb with a splint, keeping it at heart level.',
        'RUSH to the nearest Community Health Centre (CHC) or District Hospital for Polyvalent Anti-Snake Venom (ASV) infusion.',
        'The Big Four venomous snakes of India: Russell\'s Viper, Saw-scaled Viper, Spectacled Cobra, Common Krait.',
      ],
    ),
    AnimalDisasterProtocol(
      title: 'Companion Animal & Pet Rescue Guidelines',
      targetGroup: 'Dogs, Cats & Companion Pets',
      protocols: [
        'Ensure pets wear water-resistant ID collars with owner mobile numbers.',
        'Include 5 days of dry pet food, collapsible bowls, and leashes/muzzles in the family survival kit.',
        'Never leave pets tied to outdoor posts or locked inside confined sheds during storms or floods.',
      ],
    ),
  ];
}
