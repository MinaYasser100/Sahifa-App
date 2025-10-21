import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahifa/core/internet_check/cubit/internet_check__cubit.dart';
import 'package:sahifa/core/routing/app_router.dart';
import 'package:sahifa/core/theme/theme_cubit/theme_cubit.dart';
import 'package:sahifa/core/utils/theme_data_func.dart';
import 'package:sahifa/core/widgets/no_internet_screen.dart';

class AlThawraApp extends StatelessWidget {
  const AlThawraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return ScreenUtilInit(
          child: BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivityState) {
              // Show NoInternetScreen if disconnected
              if (connectivityState is ConnectivityDisconnected) {
                return MaterialApp(
                  locale: context.locale,
                  supportedLocales: context.supportedLocales,
                  localizationsDelegates: context.localizationDelegates,
                  debugShowCheckedModeBanner: false,
                  theme: themeDataFunc(),
                  darkTheme: darkThemeDataFunc(),
                  themeMode: themeState is ThemeDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
                  home: const NoInternetScreen(),
                );
              }

              // Show normal app if connected
              return MaterialApp.router(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                debugShowCheckedModeBanner: false,
                theme: themeDataFunc(),
                darkTheme: darkThemeDataFunc(),
                themeMode: themeState is ThemeDark
                    ? ThemeMode.dark
                    : ThemeMode.light,
                routerConfig: AppRouter.router,
                builder: EasyLoading.init(),
              );
            },
          ),
        );
      },
    );
  }
}
