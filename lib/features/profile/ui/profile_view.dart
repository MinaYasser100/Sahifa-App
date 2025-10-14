import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/theme/cubit/theme_cubit.dart';

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
              const Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      child: Icon(Icons.person, size: 50),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'User Profile',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Theme Settings Card
              Card(
                elevation: 2,
                child: ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                    size: 28,
                  ),
                  title: Text(
                    isDark ? 'Dark Mode' : 'Light Mode',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    isDark ? 'Switch to light theme' : 'Switch to dark theme',
                  ),
                  trailing: Switch(
                    value: isDark,
                    onChanged: (value) {
                      themeCubit.toggleTheme();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Additional Settings
              Card(
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings, size: 28),
                      title: const Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to settings
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.language, size: 28),
                      title: const Text(
                        'Language',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to language settings
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
