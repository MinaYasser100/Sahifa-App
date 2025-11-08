import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:animate_do/animate_do.dart';
import 'package:sahifa/core/utils/colors.dart';

class BannerLoadingState extends StatelessWidget {
  const BannerLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        height: 240,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ColorsTheme().primaryColor.withValues(alpha: 0.05),
              ColorsTheme().primaryColor.withValues(alpha: 0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LoadingIcon(),
            const SizedBox(height: 20),
            Text(
              'Loading banners...'.tr(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: ColorsTheme().primaryColor,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 60,
              child: LinearProgressIndicator(
                backgroundColor: ColorsTheme().primaryColor.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ColorsTheme().primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingIcon extends StatelessWidget {
  const _LoadingIcon();

  @override
  Widget build(BuildContext context) {
    return Pulse(
      infinite: true,
      duration: const Duration(milliseconds: 1500),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.article_outlined,
          size: 48,
          color: ColorsTheme().primaryColor,
        ),
      ),
    );
  }
}
