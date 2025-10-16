import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahifa/core/caching/shared/shared_perf_helper.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/app_router.dart';
import 'package:sahifa/core/theme/cubit/theme_cubit.dart';
import 'package:sahifa/core/utils/constant.dart';
import 'package:sahifa/core/utils/theme_data_func.dart';
import 'package:sahifa/core/utils/timeago_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();
  await SharedPrefHelper.instance.init();
  await EasyLocalization.ensureInitialized();
  initTimeago(); // Initialize timeago with Arabic locale
  _configureEasyLoading(); // Configure EasyLoading
  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale(ConstantVariable.englishLangCode),
        Locale(ConstantVariable.arabicLangCode),
      ], // اللغات المدعومة
      path: 'assets/localization', // مسار الملفات
      fallbackLocale: const Locale(ConstantVariable.englishLangCode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return ScreenUtilInit(
            child: MaterialApp.router(
              locale: context.locale, // استخدم اللغة الحالية
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
            ),
          );
        },
      ),
    );
  }
}

void _configureEasyLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = const Color(0xFF2196F3)
    ..backgroundColor = Colors.white
    ..indicatorColor = const Color(0xFF2196F3)
    ..textColor = const Color(0xFF2196F3)
    ..maskColor = Colors.black.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
