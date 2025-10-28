import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';

abstract class AudioPlayerRepo {
  Future<Either<String, AudioPlayer>> initializeAudio(String audioUrl);
  Future<Either<String, void>> play();
  Future<Either<String, void>> pause();
  Future<Either<String, void>> seekTo(Duration position);
  Future<Either<String, void>> setSpeed(double speed);
  Future<Either<String, void>> setVolume(double volume);
  Future<Either<String, void>> stop();
  Future<Either<String, Duration?>> getAudioDuration(String audioUrl);
  Stream<Duration> get positionStream;
  Stream<Duration?> get durationStream;
  Stream<PlayerState> get playerStateStream;
  Duration get currentPosition;
  Duration? get duration;
  bool get isPlaying;
  Future<void> dispose();
}

class AudioPlayerRepoImpl implements AudioPlayerRepo {
  AudioPlayerRepoImpl() {
    _initAudioSession();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Duration get currentPosition => _audioPlayer.position;

  @override
  Duration? get duration => _audioPlayer.duration;

  @override
  bool get isPlaying => _audioPlayer.playing;

  @override
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  @override
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  @override
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Future<void> _initAudioSession() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
    } catch (e) {
      // Silent fail - audio session is optional
    }
  }

  @override
  Future<Either<String, AudioPlayer>> initializeAudio(String audioUrl) async {
    try {
      await _audioPlayer.setUrl(audioUrl);
      return Right(_audioPlayer);
    } catch (e) {
      return const Left('فشل تحميل الملف الصوتي');
    }
  }

  @override
  Future<Either<String, void>> play() async {
    try {
      await _audioPlayer.play();
      return const Right(null);
    } catch (e) {
      return const Left('فشل تشغيل الصوت');
    }
  }

  @override
  Future<Either<String, void>> pause() async {
    try {
      await _audioPlayer.pause();
      return const Right(null);
    } catch (e) {
      return const Left('فشل إيقاف الصوت مؤقتاً');
    }
  }

  @override
  Future<Either<String, void>> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      return const Right(null);
    } catch (e) {
      return const Left('فشل الانتقال إلى الموضع المحدد');
    }
  }

  @override
  Future<Either<String, void>> setSpeed(double speed) async {
    try {
      await _audioPlayer.setSpeed(speed);
      return const Right(null);
    } catch (e) {
      return const Left('فشل تغيير سرعة التشغيل');
    }
  }

  @override
  Future<Either<String, void>> setVolume(double volume) async {
    try {
      await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
      return const Right(null);
    } catch (e) {
      return const Left('فشل تغيير مستوى الصوت');
    }
  }

  @override
  Future<Either<String, void>> stop() async {
    try {
      await _audioPlayer.stop();
      return const Right(null);
    } catch (e) {
      return const Left('فشل إيقاف الصوت');
    }
  }

  @override
  Future<Either<String, Duration?>> getAudioDuration(String audioUrl) async {
    try {
      // Create a temporary player to get duration without affecting current playback
      final tempPlayer = AudioPlayer();
      await tempPlayer.setUrl(audioUrl);
      final duration = tempPlayer.duration;
      await tempPlayer.dispose();
      return Right(duration);
    } catch (e) {
      return const Left('فشل الحصول على مدة الملف الصوتي');
    }
  }

  @override
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
