import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/manager/banners_cubit/banners_cubit.dart';

class BannerErrorState extends StatelessWidget {
  const BannerErrorState({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: Container(
        width: double.infinity,
        height: 240,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsTheme().errorColor.withValues(alpha: 0.1),
              ColorsTheme().errorColor.withValues(alpha: 0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorsTheme().errorColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoomIn(
              duration: const Duration(milliseconds: 500),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorsTheme().errorColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.newspaper_outlined,
                  size: 40,
                  color: ColorsTheme().errorColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Load Banners'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorsTheme().errorColor.withValues(alpha: 0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unable to fetch banners.\nPlease try again.'.tr(),
                textAlign: TextAlign.center,
                style: AppTextStyles.styleMedium14sp(context).copyWith(
                  color: ColorsTheme().errorColor.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 20),
            _RetryButton(),
          ],
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  const _RetryButton();

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);
    return ElasticIn(
      delay: const Duration(milliseconds: 300),
      child: ElevatedButton.icon(
        onPressed: () {
          context.read<BannersCubit>().refreshBanners(language);
        },
        icon: const Icon(Icons.refresh_rounded, size: 20),
        label: Text(
          'Try Again'.tr(),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsTheme().errorColor,
          foregroundColor: ColorsTheme().whiteColor,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: ColorsTheme().errorColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
