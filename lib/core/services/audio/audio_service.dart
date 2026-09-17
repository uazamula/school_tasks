import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player = AudioPlayer();

  bool _enabled = true;

  bool get enabled => _enabled;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  Future<void> playSuccess() async {
    if (!_enabled) {
      return;
    }

    await _player.play(AssetSource('audio/ding.mp3'));
  }

  Future<void> playFailure() async {
    if (!_enabled) {
      return;
    }

    await _player.play(AssetSource('audio/failure.mp3'));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
