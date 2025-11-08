import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_loading_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_error_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/banner_empty_state.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/custom_tablet_banners_horizontal_list.dart';

class CustomTabletBannerSection extends StatelessWidget {
  const CustomTabletBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannersCubit, BannersState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: _buildStateWidget(state),
        );
      },
    );
  }

  Widget _buildStateWidget(BannersState state) {
    if (state is BannersLoading) {
      return const BannerLoadingState();
    }
    if (state is BannersError) {
      return BannerErrorState(message: state.message);
    }
    if (state is BannersLoaded) {
      if (state.banners.isEmpty) {
        return const BannerEmptyState();
      }
      return CustomTabletBannersHorizontalList(banners: state.banners);
    }
    return const SizedBox.shrink();
  }
}
