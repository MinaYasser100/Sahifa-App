import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'galaries_posts_state.dart';

class GalariesPostsCubit extends Cubit<GalariesPostsState> {
  GalariesPostsCubit() : super(GalariesPostsInitial());
}
