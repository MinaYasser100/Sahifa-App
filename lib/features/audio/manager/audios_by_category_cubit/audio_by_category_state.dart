part of 'audio_by_category_cubit.dart';

@immutable
sealed class AudioByCategoryState {}

final class AudioByCategoryInitial extends AudioByCategoryState {}

final class AudioByCategoryLoading extends AudioByCategoryState {}

final class AudioByCategoryLoaded extends AudioByCategoryState {
  final List<AudioItemModel> audios;
  AudioByCategoryLoaded({required this.audios});
}

final class AudioByCategoryError extends AudioByCategoryState {
  final String message;
  AudioByCategoryError({required this.message});
}
