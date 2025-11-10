import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reels_body_view.dart';

class ReelsView extends StatelessWidget {
  const ReelsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReelsCubit(ReelsApiRepo(DioHelper())),
      child: const ReelsBodyView(),
    );
  }
}
