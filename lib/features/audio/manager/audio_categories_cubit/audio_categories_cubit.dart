import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/audio/data/repo/audio_categories_repo.dart';

part 'audio_categories_state.dart';

class AudioCategoriesCubit extends Cubit<AudioCategoriesState> {
  AudioCategoriesCubit(this._audioCategoriesRepo)
    : super(AudioCategoriesInitial());
  final AudioCategoriesRepo _audioCategoriesRepo;
  Future<void> fetchAudioCategories({required String language}) async {
    if (isClosed) return;
    
    emit(AudioCategoriesLoading());
    final result = await _audioCategoriesRepo.fetchAudioCategories(language);
    
    if (isClosed) return;
    
    result.fold(
      (failure) {
        if (!isClosed) emit(AudioCategoriesError(message: failure));
      },
      (categories) {
        if (!isClosed) emit(AudioCategoriesLoaded(categories: categories));
      },
    );
  }
}
