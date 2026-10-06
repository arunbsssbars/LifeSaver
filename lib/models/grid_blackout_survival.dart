/// Model representing Central Electricity Authority (CEA) & POSOCO (Grid-India)
/// Grid Islanding, Black Sky Outage & Essential Load Priority Hierarchies.
enum GridFrequencyHealth {
  nominal(
    band: '49.90 Hz – 50.05 Hz (Normal Stable)',
    action: 'Grid supply nominal and balanced across inter-regional corridors.',
    colorValue: 0xFF10B981,
  ),
  underFrequencyWarning(
    band: '49.50 Hz – 49.89 Hz (Generation Deficit)',
    action: 'Automatic Under-Frequency Load Shedding (UFLS Stage 1) active.',
    colorValue: 0xFFFBBF24,
  ),
  criticalTripRisk(
    band: '< 48.80 Hz (Imminent Cascading Collapse)',
    action: 'Grid islanding relays trip! Major state-wide blackout in progress.',
    colorValue: 0xFFEF4444,
  );

  final String band;
  final String action;
  final int colorValue;

  const GridFrequencyHealth({
    required this.band,
    required this.action,
    required this.colorValue,
  });
}

class BlackoutPreparednessGuide {
  static const List<String> criticalShelterPriorityLoads = [
    'Level 1 (Immediate Non-Negotiable): ICU Ventilators, Oxygen Concentrators, Blood Bank Refrigeration, Emergency Operation Theatres.',
    'Level 2 (Command & Comms): DEOC VHF/HF Base Stations, Satellite Gateways, Aapda Mitra Dispatch Radios.',
    'Level 3 (Water & Life Support): Municipal Potable Water Booster Pumps, Sewage Lifting Stations, High-Mast Perimeter Security Lighting.',
    'Level 4 (Public Infrastructure): Railway Signaling, Air Traffic Control (ATC), Fire Station Sluice Gates.',
  ];

  static const List<String> citizenBlackoutSurvivalSteps = [
    'Keep refrigerators and freezers CLOSED: An unopened refrigerator keeps food cold for 4 hours; a full freezer for 48 hours.',
    'Unplug major inductive appliances (ACs, microwave ovens, washing machines) to prevent damage from massive voltage spikes upon power restoration.',
    'Use LED lanterns or flashlights instead of candles to eliminate fire hazard in earthquake/flood debris zones.',
    'Conserve mobile phone battery: Enable Extreme Battery Saver mode, turn off GPS/Bluetooth/Wi-Fi when not in active use, reduce screen brightness to minimum.',
  ];
}
