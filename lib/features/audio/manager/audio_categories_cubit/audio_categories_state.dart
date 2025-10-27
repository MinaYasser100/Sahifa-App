part of 'audio_categories_cubit.dart';

@immutable
sealed class AudioCategoriesState {}

final class AudioCategoriesInitial extends AudioCategoriesState {}

final class AudioCategoriesLoading extends AudioCategoriesState {}

final class AudioCategoriesLoaded extends AudioCategoriesState {
  final List<ParentCategory> categories;

  AudioCategoriesLoaded({required this.categories});
}

final class AudioCategoriesError extends AudioCategoriesState {
  final String message;

  AudioCategoriesError({required this.message});
}