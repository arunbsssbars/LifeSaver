/// Model representing Amateur HAM Radio Disaster Operations & Wireless Planning & Coordination (WPC)
/// statutory emergency communications protocols for India (VU callsign zone).
class HamRadioFrequency {
  final String band;
  final String frequency;
  final String mode;
  final String primaryUse;
  final String regionalCoverage;

  const HamRadioFrequency({
    required this.band,
    required this.frequency,
    required this.mode,
    required this.primaryUse,
    required this.regionalCoverage,
  });

  static const List<HamRadioFrequency> disasterNets = [
    HamRadioFrequency(
      band: '40 Meter HF',
      frequency: '7.050 MHz / 7.100 MHz',
      mode: 'LSB (Lower Sideband)',
      primaryUse: 'National Disaster Emergency Net (IARU Region 3 Emergency Frequency)',
      regionalCoverage: 'All-India Inter-State Emergency Comms during total cellular blackout',
    ),
    HamRadioFrequency(
      band: '20 Meter HF',
      frequency: '14.150 MHz',
      mode: 'USB (Upper Sideband)',
      primaryUse: 'Global International Humanitarian Disaster Relief Net',
      regionalCoverage: 'Inter-Continental & Maritime Search & Rescue',
    ),
    HamRadioFrequency(
      band: '2 Meter VHF',
      frequency: '145.500 MHz (Simplex)',
      mode: 'FM (Frequency Modulation)',
      primaryUse: 'National National Calling & Local Tactical Disaster Dispatch',
      regionalCoverage: 'Line-of-Sight Local Tactical (30–60 km radius around city)',
    ),
    HamRadioFrequency(
      band: '2 Meter VHF Repeater',
      frequency: '145.700 MHz (-600 kHz offset)',
      mode: 'FM (CTCSS 88.5 Hz)',
      primaryUse: 'High-Elevation Ridge Repeater for Hill Disaster Relief',
      regionalCoverage: 'Mountain valley cross-ridge coverage (100+ km)',
    ),
    HamRadioFrequency(
      band: '70 cm UHF',
      frequency: '435.000 MHz',
      mode: 'FM / Packet Data',
      primaryUse: 'Low-Earth Orbit Amateur Satellite (AO-91 / IO-86) Packet Gateway',
      regionalCoverage: 'Over-the-Horizon satellite messaging without internet',
    ),
  ];
}

class HamQCodeGuide {
  final String qCode;
  final String meaning;
  final String disasterApplication;

  const HamQCodeGuide({
    required this.qCode,
    required this.meaning,
    required this.disasterApplication,
  });

  static const List<HamQCodeGuide> essentialCodes = [
    HamQCodeGuide(
      qCode: 'QTH',
      meaning: 'What is your exact location?',
      disasterApplication: 'Transmit GPS grid square or landmark coordinates of casualties.',
    ),
    HamQCodeGuide(
      qCode: 'QRM',
      meaning: 'Is my transmission being interfered with?',
      disasterApplication: 'Report severe atmospheric noise or channel congestion.',
    ),
    HamQCodeGuide(
      qCode: 'QRT',
      meaning: 'Shall I cease transmitting?',
      disasterApplication: 'Silence non-priority traffic to allow life-critical SOS dispatch.',
    ),
    HamQCodeGuide(
      qCode: 'QRX',
      meaning: 'Stand by / When will you call me again?',
      disasterApplication: 'Order field units to stand by while emergency medical team confirms triage.',
    ),
    HamQCodeGuide(
      qCode: 'QSO',
      meaning: 'Direct communication confirmed.',
      disasterApplication: 'Confirm two-way receipt of relief manifest with DEOC.',
    ),
  ];
}
