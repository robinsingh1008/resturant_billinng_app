import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:resturent_billinng_app/app/app_theme.dart';
import 'package:resturent_billinng_app/config/di/app_bloc_providers.dart';
import 'package:resturent_billinng_app/config/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('bn'),
        Locale('kn'),
        Locale('ta'),
        Locale('te'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AppBlocProviders(child: _AppView()),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant Billing App',
      theme: AppTheme.light(),
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      routerConfig: appRouter,
    );
  }
}
