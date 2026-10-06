import 'dart:math' as math;

/// Model representing NDMA Early Warning Acoustic Siren Propagation & Decibel Attenuation.
class SirenAcousticAssessment {
  final double sirenSourceSoundPowerDb; // e.g., 130 dB at 1 meter
  final double ambientBackgroundNoiseDb; // e.g., 65 dB in urban traffic
  final double airTemperatureC;
  final double relativeHumidityPercent;

  const SirenAcousticAssessment({
    required this.sirenSourceSoundPowerDb,
    required this.ambientBackgroundNoiseDb,
    required this.airTemperatureC,
    required this.relativeHumidityPercent,
  });

  /// Computes sound pressure level (SPL) in dB at distance r in meters
  /// Lp = Lw - 20*log10(r) - (alpha * r / 1000)
  double calculateDecibelsAtDistance({required double distanceMeters}) {
    if (distanceMeters <= 1.0) return sirenSourceSoundPowerDb;
    // Atmospheric absorption coefficient alpha approx 5 dB/km
    final geometricAttenuation = 20.0 * (math.log(distanceMeters) / math.ln10);
    final atmosphericAbsorption = (5.0 * distanceMeters) / 1000.0;
    return (sirenSourceSoundPowerDb - geometricAttenuation - atmosphericAbsorption).clamp(0.0, 150.0);
  }

  /// Calculates effective audible warning radius in meters (where Signal >= Ambient Noise + 10 dB)
  double calculateAudibleRadiusMeters() {
    final targetSpl = ambientBackgroundNoiseDb + 10.0;
    // Iterative search for radius
    double r = 10.0;
    while (r < 5000.0) {
      if (calculateDecibelsAtDistance(distanceMeters: r) <= targetSpl) {
        return r;
      }
      r += 10.0;
    }
    return 5000.0;
  }
}
