import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/additional_setting_model/additional_setting_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/cubit/theme_cubit.dart';

import 'widgets/additonal_settings_item.dart';
import 'widgets/theme_settings_card.dart';
import 'widgets/user_profile_sectrion.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
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
                          title: 'Edit Information',
                          isDark: isDark,
                          onTap: () {
                            context.push(Routes.editInfoView);
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      AdditionalSettingsItem(
                        model: AdditionalSettingModel(
                          icon: Icons.favorite,
                          title: 'My Favorites',
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
                          title: 'Language',
                          isDark: isDark,
                          onTap: () {
                            // Navigate to language settings
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
