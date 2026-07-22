import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/business_category.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/business_setup.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/language_screen.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/login_screen.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/otp_screen.dart';
import 'package:resturent_billinng_app/features/auth/presentation/pages/splash_screen.dart';
import 'package:resturent_billinng_app/widgets/bottom_tab.dart';

import 'app_routes.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpScreen,
      builder: (context, state) =>
          OtpScreen(phoneNumber: state.uri.queryParameters['phone'] ?? ''),
    ),
    GoRoute(
      path: AppRoutes.language,
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: AppRoutes.category,
      builder: (context, state) => const BusinessCategoryScreen(),
    ),
    GoRoute(
      path: AppRoutes.setup,
      builder: (context, state) => const BusinessSetupScreen(),
    ),
    GoRoute(
      path: AppRoutes.main,
      builder: (context, state) => const BottomTab(selectedIndex: 0),
    ),
  ],
);
