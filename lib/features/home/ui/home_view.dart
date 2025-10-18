import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/home/data/repo/banner_repo.dart';
import 'package:sahifa/features/home/manger/cubit/banners_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/custom_home_drawer.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return BlocProvider(
      create: (context) => BannersCubit(BannerRepoImpl())..fetchBanners(),
      child: Scaffold(
        key: ValueKey(currentLocale.languageCode),
        drawer: CustomHomeDrawer(),
        appBar: HomeAppBar(),
        body: HomeBodyView(),
      ),
    );
  }
}
