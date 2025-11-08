part of 'audio_by_category_cubit.dart';

@immutable
sealed class AudioByCategoryState {}

final class AudioByCategoryInitial extends AudioByCategoryState {}

final class AudioByCategoryLoading extends AudioByCategoryState {}

final class AudioByCategoryLoaded extends AudioByCategoryState {
  final List<AudioItemModel> audios;
  final bool hasMorePages;

  AudioByCategoryLoaded({required this.audios, required this.hasMorePages});
}

final class AudioByCategoryLoadingMore extends AudioByCategoryState {
  final List<AudioItemModel> audios;
  final bool hasMorePages;

  AudioByCategoryLoadingMore({
    required this.audios,
    required this.hasMorePages,
  });
}

final class AudioByCategoryError extends AudioByCategoryState {
  final String message;
  AudioByCategoryError({required this.message});
}
