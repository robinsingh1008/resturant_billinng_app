import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:resturent_billinng_app/app/app.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  configureDependencies();
  runApp(const MyApp());
}
