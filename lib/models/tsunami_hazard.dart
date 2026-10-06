/// Model representing Indian Tsunami Early Warning Centre (ITEWC / INCOIS, Hyderabad)
/// operational tsunami warning protocols for Indian Ocean rim countries.
enum TsunamiThreatStatus {
  noThreat(
    code: 'TSUNAMI ALL CLEAR',
    description: 'No tsunamigenic undersea earthquake or sea-level anomaly detected.',
    colorValue: 0xFF10B981,
  ),
  tsunamiWatch(
    code: 'TSUNAMI WATCH',
    description: 'Undersea earthquake M6.5+ detected in Andaman-Sumatra or Makran trench. Assessing tsunami potential.',
    colorValue: 0xFFFBBF24,
  ),
  tsunamiAlert(
    code: 'TSUNAMI ALERT',
    description: 'Tsunami confirmed on BPL/DART buoys. Coastal sea surges expected. Stay off beaches and harbors.',
    colorValue: 0xFFF97316,
  ),
  tsunamiWarning(
    code: 'TSUNAMI WARNING (EVACUATE)',
    description: 'Major destructive tsunami wave arrival imminent! Inundation of low-lying coastal belt underway.',
    colorValue: 0xFFEF4444,
  );

  final String code;
  final String description;
  final int colorValue;

  const TsunamiThreatStatus({
    required this.code,
    required this.description,
    required this.colorValue,
  });
}

class TsunamiAssessment {
  final TsunamiThreatStatus status;
  final double estimatedWaveHeightMeters;
  final int estimatedArrivalMinutes;
  final double minimumEvacuationElevationMeters;
  final List<String> affectedCoastalStates;
  final List<String> survivalActionDirectives;

  const TsunamiAssessment({
    required this.status,
    required this.estimatedWaveHeightMeters,
    required this.estimatedArrivalMinutes,
    required this.minimumEvacuationElevationMeters,
    required this.affectedCoastalStates,
    required this.survivalActionDirectives,
  });

  /// Evaluates Tsunami threat based on earthquake magnitude, depth, and coastal proximity
  static TsunamiAssessment evaluateUnderseaEvent({
    required double magnitude,
    required double depthKm,
    required bool isUnderseaOrCoastal,
    required double distanceFromEpicenterKm,
  }) {
    if (!isUnderseaOrCoastal || magnitude < 6.5) {
      return const TsunamiAssessment(
        status: TsunamiThreatStatus.noThreat,
        estimatedWaveHeightMeters: 0.0,
        estimatedArrivalMinutes: 0,
        minimumEvacuationElevationMeters: 0.0,
        affectedCoastalStates: [],
        survivalActionDirectives: [
          'No tsunami threat to Indian Ocean and Bay of Bengal coastlines.',
        ],
      );
    }

    TsunamiThreatStatus status = TsunamiThreatStatus.tsunamiWatch;
    double waveHeight = 0.5;
    double minElevation = 10.0;

    if (magnitude >= 8.0 && depthKm <= 60.0) {
      status = TsunamiThreatStatus.tsunamiWarning;
      waveHeight = 8.5;
      minElevation = 20.0; // 20m above sea level or 2km inland
    } else if (magnitude >= 7.5 && depthKm <= 80.0) {
      status = TsunamiThreatStatus.tsunamiAlert;
      waveHeight = 3.2;
      minElevation = 15.0;
    }

    // Tsunami speed in deep ocean ~700-800 km/h
    final arrivalMins = ((distanceFromEpicenterKm / 750.0) * 60).round().clamp(5, 720);

    final directives = <String>[];
    if (status == TsunamiThreatStatus.tsunamiWarning) {
      directives.add('🚨 IMMEDIATE COASTAL EVACUATION: Move inland at least 2 km or to ground at least 20m high.');
      directives.add('If you feel strong shaking or observe sudden ocean pullback / reef exposure, run to high ground immediately without waiting for sirens.');
      directives.add('Never go to the beach to watch waves. Tsunami moves faster than a sprinting human.');
      directives.add('Wait for official all-clear from INCOIS/NDMA; subsequent waves are often larger than the first.');
    } else if (status == TsunamiThreatStatus.tsunamiAlert) {
      directives.add('Stay off coastal beaches, marine drives, harbors, and tidal inlets.');
      directives.add('Boats in deep ocean (>100m depth) should remain in deep sea rather than returning to shallow port.');
      directives.add('Prepare emergency grab bag and monitor local coastal warning sirens.');
    } else {
      directives.add('Ocean bottom pressure recorder (DART) telemetry active. Monitor INCOIS bulletins.');
    }

    return TsunamiAssessment(
      status: status,
      estimatedWaveHeightMeters: waveHeight,
      estimatedArrivalMinutes: arrivalMins,
      minimumEvacuationElevationMeters: minElevation,
      affectedCoastalStates: const [
        'Andaman & Nicobar Islands',
        'Tamil Nadu & Puducherry',
        'Andhra Pradesh',
        'Odisha',
        'Kerala',
      ],
      survivalActionDirectives: directives,
    );
  }
}
