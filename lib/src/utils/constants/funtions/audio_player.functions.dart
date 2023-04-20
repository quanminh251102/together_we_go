import 'package:just_audio/just_audio.dart' as Audio;
import 'package:audio_session/audio_session.dart';

Audio.AudioPlayer _audioPlayer = new Audio.AudioPlayer();

// audio_play("assets/audios/file.mp3");
Future<void> audio_play(String url) async {
  final session = await AudioSession.instance;
  await session.configure(const AudioSessionConfiguration(
    androidAudioAttributes: AndroidAudioAttributes(
      usage: AndroidAudioUsage.voiceCommunicationSignalling,
    ),
  ));

  _audioPlayer = Audio.AudioPlayer();
  await _audioPlayer.setAsset(url);
  await _audioPlayer.setLoopMode(Audio.LoopMode.one);
  await _audioPlayer.setVolume(1.0);
  _audioPlayer.play();
}

void audio_stop() {
  _audioPlayer.stop();
  _audioPlayer.dispose();
}
