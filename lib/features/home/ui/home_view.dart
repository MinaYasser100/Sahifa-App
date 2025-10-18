import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/widgets/custom_home_drawer.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;
    return Scaffold(
      key: ValueKey(currentLocale.languageCode),
      drawer: CustomHomeDrawer(),
      appBar: HomeAppBar(),
      body: HomeBodyView(),
    );
  }
}
