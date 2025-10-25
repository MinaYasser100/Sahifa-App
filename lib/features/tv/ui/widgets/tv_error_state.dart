import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/tv/manager/tv_cubit/tv_cubit.dart';

class TvErrorState extends StatelessWidget {
  const TvErrorState({
    super.key,
    required this.errorText,
    required this.language,
  });
  final String errorText;
  final String language;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Icon(
                FontAwesomeIcons.circleExclamation,
                size: 64,
                color: ColorsTheme().errorIconColor,
              ),
            ),
            const SizedBox(height: 24),
            FadeInRight(
              child: Text(
                errorText,
                style: AppTextStyles.styleBold18sp(context),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            FadeInLeft(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<TvCubit>().fetchVideos(language: language);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text('retry'.tr()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsTheme().primaryColor,
                  foregroundColor: ColorsTheme().whiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
