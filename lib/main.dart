import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sahifa/al_thawra_app.dart';
import 'package:sahifa/core/caching/shared/shared_perf_helper.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/internet_check/cubit/internet_check__cubit.dart';
import 'package:sahifa/core/theme/cubit/theme_cubit.dart';
import 'package:sahifa/core/utils/constant.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => ConnectivityCubit()),
      ],
      child: AlThawraApp(),
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
    ..maskColor = Colors.black.withValues(alpha: 0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}
