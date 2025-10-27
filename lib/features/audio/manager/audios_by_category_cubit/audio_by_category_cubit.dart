import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/features/audio/data/repo/audios_by_category_repo.dart';

part 'audio_by_category_state.dart';

class AudioByCategoryCubit extends Cubit<AudioByCategoryState> {
  AudioByCategoryCubit(this._audiosByCategoryRepoImpl)
    : super(AudioByCategoryInitial());

  final AudiosByCategoryRepoImpl _audiosByCategoryRepoImpl;

  Future<void> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
  }) async {
    emit(AudioByCategoryLoading());
    final result = await _audiosByCategoryRepoImpl.fetchAudiosByCategory(
      categorySlug: categorySlug,
      language: language,
    );

    result.fold(
      (failure) {
        emit(AudioByCategoryError(message: failure));
      },
      (audios) {
        emit(AudioByCategoryLoaded(audios: audios.audios ?? []));
      },
    );
  }
}
