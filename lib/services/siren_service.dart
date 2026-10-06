import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class SirenService {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _isPlaying = false;
  static Timer? _pulseTimer;

  static bool get isPlaying => _isPlaying;

  /// Starts emergency siren audio loop
  static Future<void> startSiren() async {
    if (_isPlaying) return;
    _isPlaying = true;

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      // Online siren audio link for alarm testing
      await _audioPlayer.play(
        UrlSource('https://actions.google.com/sounds/v1/alarms/alarm_clock.ogg'),
      );
    } catch (e) {
      // If network audio stream fails, keep state active for UI flashing
    }
  }

  /// Stops emergency siren
  static Future<void> stopSiren() async {
    _isPlaying = false;
    _pulseTimer?.cancel();
    try {
      await _audioPlayer.stop();
    } catch (_) {}
  }

  static void dispose() {
    _pulseTimer?.cancel();
    _audioPlayer.dispose();
  }
}
