import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sahifa/features/audio/data/repo/audio_player_repo.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit(this._audioPlayerRepo) : super(AudioPlayerInitial());

  final AudioPlayerRepo _audioPlayerRepo;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _durationSubscription;

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _currentSpeed = 1.0;

  // Getters
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  double get currentSpeed => _currentSpeed;
  bool get isPlaying => _audioPlayerRepo.isPlaying;

  Future<void> initializeAudio(String audioUrl) async {
    emit(AudioPlayerLoading());

    final result = await _audioPlayerRepo.initializeAudio(audioUrl);

    result.fold((error) => emit(AudioPlayerError(message: error)), (_) {
      // Listen to position changes
      _positionSubscription = _audioPlayerRepo.positionStream.listen((
        position,
      ) {
        _currentPosition = position;
        _emitCurrentState();
      });

      // Listen to duration changes
      _durationSubscription = _audioPlayerRepo.durationStream.listen((
        duration,
      ) {
        if (duration != null) {
          _totalDuration = duration;
          _emitCurrentState();
        }
      });

      // Listen to player state changes
      _playerStateSubscription = _audioPlayerRepo.playerStateStream.listen((
        playerState,
      ) {
        if (playerState.processingState == ProcessingState.completed) {
          emit(AudioPlayerCompleted());
        } else if (playerState.processingState == ProcessingState.buffering) {
          emit(
            AudioPlayerBuffering(
              position: _currentPosition,
              duration: _totalDuration,
            ),
          );
        }
      });

      emit(
        AudioPlayerPaused(
          position: Duration.zero,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      );
    });
  }

  void _emitCurrentState() {
    if (_audioPlayerRepo.isPlaying) {
      emit(
        AudioPlayerPlaying(
          position: _currentPosition,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      );
    } else {
      emit(
        AudioPlayerPaused(
          position: _currentPosition,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      );
    }
  }

  Future<void> playAudio() async {
    final result = await _audioPlayerRepo.play();
    result.fold(
      (error) => emit(AudioPlayerError(message: error)),
      (_) => emit(
        AudioPlayerPlaying(
          position: _currentPosition,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      ),
    );
  }

  Future<void> pauseAudio() async {
    final result = await _audioPlayerRepo.pause();
    result.fold(
      (error) => emit(AudioPlayerError(message: error)),
      (_) => emit(
        AudioPlayerPaused(
          position: _currentPosition,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      ),
    );
  }

  Future<void> togglePlayPause() async {
    if (_audioPlayerRepo.isPlaying) {
      await pauseAudio();
    } else {
      await playAudio();
    }
  }

  Future<void> seekTo(Duration position) async {
    final result = await _audioPlayerRepo.seekTo(position);
    result.fold((error) => emit(AudioPlayerError(message: error)), (_) {
      _currentPosition = position;
      _emitCurrentState();
    });
  }

  Future<void> seekForward(int seconds) async {
    final newPosition = _currentPosition + Duration(seconds: seconds);
    if (newPosition < _totalDuration) {
      await seekTo(newPosition);
    } else {
      await seekTo(_totalDuration);
    }
  }

  Future<void> seekBackward(int seconds) async {
    final newPosition = _currentPosition - Duration(seconds: seconds);
    if (newPosition > Duration.zero) {
      await seekTo(newPosition);
    } else {
      await seekTo(Duration.zero);
    }
  }

  Future<void> setSpeed(double speed) async {
    final result = await _audioPlayerRepo.setSpeed(speed);
    result.fold((error) => emit(AudioPlayerError(message: error)), (_) {
      _currentSpeed = speed;
      _emitCurrentState();
    });
  }

  Future<void> setVolume(double volume) async {
    final result = await _audioPlayerRepo.setVolume(volume);
    result.fold(
      (error) => emit(AudioPlayerError(message: error)),
      (_) {}, // Volume change doesn't need state update
    );
  }

  Future<void> stopAudio() async {
    final result = await _audioPlayerRepo.stop();
    result.fold(
      (error) => emit(AudioPlayerError(message: error)),
      (_) => emit(
        AudioPlayerPaused(
          position: Duration.zero,
          duration: _totalDuration,
          speed: _currentSpeed,
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    } else {
      return '$minutes:${twoDigits(seconds)}';
    }
  }

  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _playerStateSubscription?.cancel();
    await _durationSubscription?.cancel();
    await _audioPlayerRepo.dispose();
    return super.close();
  }
}
