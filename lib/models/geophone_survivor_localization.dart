import 'dart:math' as math;

/// Model representing NDRF Urban Search and Rescue (USAR) & INSARAG
/// Seismic Acoustic Geophone Survivor Localization & Time-Difference-of-Arrival (TDOA) Triangulation.
class GeophoneSurvivorLocalization {
  final String collapseSiteId;
  final double sensor1SignalAmplitudeMicroVolts;
  final double sensor2SignalAmplitudeMicroVolts;
  final double sensor3SignalAmplitudeMicroVolts;
  final double detectedTappingFrequencyHz; // Typically 1 to 5 Hz for conscious human tapping
  final double timeDifferenceOfArrivalMs;
  final double concreteSeismicVelocityMetersPerSec; // Typically 3000 to 4000 m/s in reinforced concrete debris

  const GeophoneSurvivorLocalization({
    required this.collapseSiteId,
    required this.sensor1SignalAmplitudeMicroVolts,
    required this.sensor2SignalAmplitudeMicroVolts,
    required this.sensor3SignalAmplitudeMicroVolts,
    required this.detectedTappingFrequencyHz,
    required this.timeDifferenceOfArrivalMs,
    required this.concreteSeismicVelocityMetersPerSec,
  });

  /// Peak Signal-to-Noise Ratio (SNR) in Microvolts
  double get peakSignalAmplitudeMicroVolts {
    return math.max(sensor1SignalAmplitudeMicroVolts, math.max(sensor2SignalAmplitudeMicroVolts, sensor3SignalAmplitudeMicroVolts));
  }

  /// Estimated distance offset to trapped survivor in meters: d = v * (Delta t / 1000)
  double get estimatedSurvivorDistanceOffsetMeters {
    final timeSec = timeDifferenceOfArrivalMs / 1000.0;
    return (concreteSeismicVelocityMetersPerSec * timeSec).clamp(0.5, 30.0);
  }

  /// True if rhythmic tapping pattern matches conscious entombed survivor (1.0 to 5.0 Hz and SNR > 15 µV)
  bool get isConsciousHumanTappingPattern {
    return detectedTappingFrequencyHz >= 1.0 && detectedTappingFrequencyHz <= 5.0 && peakSignalAmplitudeMicroVolts >= 15.0;
  }

  /// True if acoustic hailing / camera search probe insertion is statutory mandated at triangulated coordinate
  bool get isSearchCamProbeInsertionMandated => isConsciousHumanTappingPattern && estimatedSurvivorDistanceOffsetMeters <= 15.0;
}
