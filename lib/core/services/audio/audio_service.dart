import 'package:audioplayers/audioplayers.dart';

class AudioService {
  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player = AudioPlayer();

  Future<void> playSuccess() async {
    await _player.play(AssetSource('audio/ding.mp3'));
  }

  Future<void> dispose() async {
    await _player.dispose();
  }
}
