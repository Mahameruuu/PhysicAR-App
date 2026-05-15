import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static const String _correctAsset = 'sounds/correct.mp3';
  static const String _wrongAsset = 'sounds/wrong.mp3';

  SoundService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  final AudioPlayer _player = AudioPlayer();

  Future<void> playCorrect() {
    return _play(_correctAsset);
  }

  Future<void> playWrong() {
    return _play(_wrongAsset);
  }

  Future<void> _play(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Keep the quiz flow running even when audio assets are missing locally.
    }
  }

  Future<void> dispose() {
    return _player.dispose();
  }
}
