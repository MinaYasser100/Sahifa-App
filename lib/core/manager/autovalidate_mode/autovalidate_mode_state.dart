part of 'autovalidate_mode_cubit.dart';

@immutable
sealed class AutovalidateModeState {}

final class AutovalidateModeInitial extends AutovalidateModeState {}

final class AutovalidateModeChanged extends AutovalidateModeState {}
