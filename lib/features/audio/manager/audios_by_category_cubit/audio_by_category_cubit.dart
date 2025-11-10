import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/audios_model/audio_item_model.dart';
import 'package:sahifa/features/audio/data/repo/audios_by_category_repo.dart';

part 'audio_by_category_state.dart';

class AudioByCategoryCubit extends Cubit<AudioByCategoryState> {
  AudioByCategoryCubit(this._audiosByCategoryRepoImpl)
    : super(AudioByCategoryInitial());

  final AudiosByCategoryRepoImpl _audiosByCategoryRepoImpl;

  List<AudioItemModel> _audios = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  String? _currentCategorySlug;
  String? _currentLanguage;

  Future<void> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
  }) async {
    if (isClosed) return;

    // Reset state for new category
    _audios = [];
    _currentPage = 1;
    _hasMorePages = true;
    _currentCategorySlug = categorySlug;
    _currentLanguage = language;

    emit(AudioByCategoryLoading());
    final result = await _audiosByCategoryRepoImpl.fetchAudiosByCategory(
      categorySlug: categorySlug,
      language: language,
      page: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(AudioByCategoryError(message: failure));
      },
      (audiosModel) {
        if (!isClosed) {
          _audios = audiosModel.audios ?? [];
          _hasMorePages = audiosModel.hasNextPage;
          emit(
            AudioByCategoryLoaded(audios: _audios, hasMorePages: _hasMorePages),
          );
        }
      },
    );
  }

  Future<void> loadMoreAudios() async {
    if (isClosed) return;

    if (!_hasMorePages ||
        _currentCategorySlug == null ||
        _currentLanguage == null) {
      return;
    }

    if (state is AudioByCategoryLoadingMore) {
      return; // Already loading more
    }

    emit(
      AudioByCategoryLoadingMore(audios: _audios, hasMorePages: _hasMorePages),
    );

    _currentPage++;

    final result = await _audiosByCategoryRepoImpl.fetchAudiosByCategory(
      categorySlug: _currentCategorySlug!,
      language: _currentLanguage!,
      page: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) {
          _currentPage--; // Rollback page increment
          emit(
            AudioByCategoryLoaded(audios: _audios, hasMorePages: _hasMorePages),
          );
        }
      },
      (audiosModel) {
        if (!isClosed) {
          _audios.addAll(audiosModel.audios ?? []);
          _hasMorePages = audiosModel.hasNextPage;
          emit(
            AudioByCategoryLoaded(audios: _audios, hasMorePages: _hasMorePages),
          );
        }
      },
    );
  }

  void resetState() {
    if (isClosed) return;

    _audios = [];
    _currentPage = 1;
    _hasMorePages = true;
    _currentCategorySlug = null;
    _currentLanguage = null;
    emit(AudioByCategoryInitial());
  }
}
