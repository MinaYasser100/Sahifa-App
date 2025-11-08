import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/internet_check/cubit/internet_check__cubit.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? ColorsTheme().backgroundColor
          : ColorsTheme().whiteColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // No Internet Icon
                FadeInDown(
                  child: Icon(
                    Icons.wifi_off_rounded,
                    size: 120,
                    color: ColorsTheme().primaryColor.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                FadeInRight(
                  child: Text(
                    'no_internet_connection'.tr(),
                    style: AppTextStyles.styleBold24sp(context).copyWith(
                      color: isDarkMode
                          ? ColorsTheme().whiteColor
                          : ColorsTheme().blackColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                FadeInLeft(
                  child: Text(
                    'please_check_your_internet_connection'.tr(),
                    style: AppTextStyles.styleRegular16sp(context).copyWith(
                      color: isDarkMode
                          ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
                          : ColorsTheme().blackColor.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                // Try Again Button
                FadeInRight(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        // Re-check connectivity
                        final cubit = context.read<ConnectivityCubit>();
                        await cubit.checkConnectivity();
                      },
                      icon: const Icon(Icons.refresh_rounded, size: 24),
                      label: Text(
                        'try_again'.tr(),
                        style: AppTextStyles.styleBold18sp(
                          context,
                        ).copyWith(color: ColorsTheme().whiteColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsTheme().primaryColor,
                        foregroundColor: ColorsTheme().whiteColor,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tips
                FadeInUp(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ColorsTheme().primaryDark.withValues(alpha: 0.3)
                          : ColorsTheme().primaryLight.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'troubleshooting_tips'.tr(),
                          style: AppTextStyles.styleBold16sp(context).copyWith(
                            color: isDarkMode
                                ? ColorsTheme().whiteColor
                                : ColorsTheme().primaryColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildTip(
                          context,
                          'check_wifi_or_mobile_data'.tr(),
                          isDarkMode,
                        ),
                        const SizedBox(height: 8),
                        _buildTip(
                          context,
                          'turn_airplane_mode_off'.tr(),
                          isDarkMode,
                        ),
                        const SizedBox(height: 8),
                        _buildTip(
                          context,
                          'check_router_or_cables'.tr(),
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTip(BuildContext context, String text, bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 20,
          color: ColorsTheme().primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.styleRegular14sp(context).copyWith(
              color: isDarkMode
                  ? ColorsTheme().whiteColor.withValues(alpha: 0.8)
                  : ColorsTheme().blackColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}
