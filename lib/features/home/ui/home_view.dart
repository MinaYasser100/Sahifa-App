import 'package:flutter/material.dart';
import 'package:sahifa/features/home/ui/widgets/home_app_bar.dart';
import 'package:sahifa/features/home/ui/widgets/home_body_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: HomeAppBar(), body: HomeBodyView());
  }
}
