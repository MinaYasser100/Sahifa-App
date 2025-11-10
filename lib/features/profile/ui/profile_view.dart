import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/additional_setting_model/additional_setting_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/services/auth_service.dart';
import 'package:sahifa/core/theme/theme_cubit/theme_cubit.dart';
import 'package:sahifa/core/widgets/adaptive_layout.dart';
import 'package:sahifa/features/profile/data/repo/profile_user_repo.dart';
import 'package:sahifa/features/profile/manager/profile_user_cubit/profile_user_cubit.dart';

import 'widgets/additonal_settings_item.dart';
import 'widgets/app_info_section.dart';
import 'widgets/language_bottom_sheet.dart';
import 'widgets/logout_button.dart';
import 'widgets/tablet_profile_body.dart';
import 'widgets/theme_settings_card.dart';
import 'widgets/user_profile_sectrion.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ProfileUserCubit(getIt<ProfileUserRepoImpl>());
        // Fetch profile immediately when cubit is created
        _loadUserProfile(cubit);
        return cubit;
      },
      child: AdaptiveLayout(
        mobileLayout: (context) => _MobileProfileView(),
        tabletLayout: (context) => const TabletProfileBody(),
        desktopLayout: (context) => const TabletProfileBody(),
      ),
    );
  }

  Future<void> _loadUserProfile(ProfileUserCubit cubit) async {
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    final userName = userInfo['name'];

    if (userName != null && userName.isNotEmpty) {
      cubit.fetchUserProfile(userName);
    }
  }
}

class _MobileProfileView extends StatelessWidget {
  const _MobileProfileView();

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      key: ValueKey(currentLocale.languageCode),
      appBar: AppBar(title: Text('profile'.tr())),
      body: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          final themeCubit = context.read<ThemeCubit>();
          final isDark = themeCubit.isDarkMode;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Profile Section
              UserProfileSection(isDark: isDark),
              const SizedBox(height: 32),

              // Theme Settings Card
              ThemeSettingsCard(isDark: isDark, themeCubit: themeCubit),

              const SizedBox(height: 16),

              // Additional Settings
              FadeInLeft(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: Column(
                    children: [
                      AdditionalSettingsItem(
                        model: AdditionalSettingModel(
                          icon: Icons.edit,
                          title: 'edit_information'.tr(),
                          isDark: isDark,
                          onTap: () async {
                            // Navigate to EditInfoView and wait for result
                            final result = await context.push(
                              Routes.editInfoView,
                            );

                            // If update was successful, refresh profile
                            if (result == true && context.mounted) {
                              final authService = AuthService();
                              final userInfo = await authService.getUserInfo();
                              final userName = userInfo['name'];

                              if (userName != null && userName.isNotEmpty) {
                                context
                                    .read<ProfileUserCubit>()
                                    .fetchUserProfile(userName);
                              }
                            }
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      AdditionalSettingsItem(
                        model: AdditionalSettingModel(
                          icon: Icons.favorite,
                          title: 'my_favorites'.tr(),
                          isDark: isDark,
                          onTap: () {
                            context.push(Routes.favoritesView);
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      AdditionalSettingsItem(
                        model: AdditionalSettingModel(
                          icon: Icons.language,
                          title: 'language'.tr(),
                          isDark: isDark,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              builder: (context) => const LanguageBottomSheet(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // App Info Section
              FadeInLeft(
                delay: const Duration(milliseconds: 100),
                child: AppInfoSection(isDark: isDark),
              ),

              const SizedBox(height: 24),

              // Logout Button
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: const LogoutButton(),
              ),

              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }
}
