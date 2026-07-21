import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/features/main/presentation/pages/main_shell_page.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/pages/onboarding_page.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const MainShellPage(),
    ),
    GoRoute(path: AppRoutes.home, redirect: (_, _) => AppRoutes.main),
    GoRoute(path: AppRoutes.menu, redirect: (_, _) => AppRoutes.main),
    GoRoute(path: AppRoutes.orders, redirect: (_, _) => AppRoutes.main),
    GoRoute(path: AppRoutes.reports, redirect: (_, _) => AppRoutes.main),
  ],
);
