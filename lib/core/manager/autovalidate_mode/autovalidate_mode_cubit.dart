import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'autovalidate_mode_state.dart';

class AutovalidateModeCubit extends Cubit<AutovalidateModeState> {
  AutovalidateModeCubit() : super(AutovalidateModeInitial());

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void changeAutovalidateMode() {
    autovalidateMode = AutovalidateMode.always;
    emit(AutovalidateModeChanged());
  }
}
