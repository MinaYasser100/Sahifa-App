import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';

abstract class AppRouter {
  static final router = GoRouter(
    initialLocation: Routes.registerView,
    routes: [
      // Register view
      // GoRoute(
      //   path: Routes.registerView,
      //   pageBuilder: (context, state) => fadeTransitionPage(RegisterView()),
      // ),

      // GoRoute(
      //   path: Routes.classesView,
      //   pageBuilder: (context, state) {
      //     final level = state.extra as LevelModel?;
      //     if (level == null) throw Exception('Level is not found');
      //     return fadeTransitionPage(ClassesView(level: level));
      //   },
      // ),
    ],
  );
}
