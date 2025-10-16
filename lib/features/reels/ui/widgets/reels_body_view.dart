import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_cubit.dart';
import 'package:sahifa/features/reels/manager/reels_cubit/reels_state.dart';
import 'package:sahifa/features/reels/ui/widgets/reel_item.dart';

class ReelsBodyView extends StatefulWidget {
  const ReelsBodyView({super.key});

  @override
  State<ReelsBodyView> createState() => _ReelsBodyViewState();
}

class _ReelsBodyViewState extends State<ReelsBodyView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Load reels when page opens
    context.read<ReelsCubit>().loadReels();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: BlocBuilder<ReelsCubit, ReelsState>(
        builder: (context, state) {
          if (state is ReelsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: ColorsTheme().primaryColor,
              ),
            );
          }

          if (state is ReelsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: ColorsTheme().errorColor,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    state.message,
                    style: TextStyle(color: ColorsTheme().errorColor),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReelsCubit>().loadReels();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ReelsLoaded) {
            if (state.reels.isEmpty) {
              return Center(
                child: Text(
                  'No reels available',
                  style: TextStyle(
                    color: ColorsTheme().whiteColor,
                    fontSize: 16,
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => context.read<ReelsCubit>().refreshReels(),
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: state.reels.length,
                onPageChanged: (index) {
                  context.read<ReelsCubit>().changePage(index);
                },
                itemBuilder: (context, index) {
                  return ReelItem(
                    reel: state.reels[index],
                    isCurrentPage: index == state.currentIndex,
                  );
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
