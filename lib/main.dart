import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/app/app.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}
