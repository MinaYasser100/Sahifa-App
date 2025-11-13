import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/reels/data/repo/reels_api_repo.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/ui/widgets/reels_body_view.dart';

class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ReelsViewState();
}

class _ReelsViewState extends State<ReelsView> {
  // Singleton ReelsCubit - يبقى alive طول عمر التطبيق
  static ReelsCubit? _reelsCubit;

  ReelsCubit _getOrCreateCubit() {
    _reelsCubit ??= ReelsCubit(ReelsApiRepo(DioHelper()));
    return _reelsCubit!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _getOrCreateCubit(),
      child: const ReelsBodyView(),
    );
  }
}
