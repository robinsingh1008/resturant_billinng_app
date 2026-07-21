import 'package:get_it/get_it.dart';
import 'package:resturent_billinng_app/core/repositories/menu_repository.dart';
import 'package:resturent_billinng_app/core/repositories/order_repository.dart';
import 'package:resturent_billinng_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:resturent_billinng_app/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:resturent_billinng_app/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/reports/presentation/bloc/reports_bloc.dart';

final sl = GetIt.instance;

void configureDependencies() {
  if (sl.isRegistered<OnboardingBloc>()) return;

  sl.registerLazySingleton(MenuRepository.new);
  sl.registerLazySingleton(OrderRepository.new);
  sl.registerFactory(OnboardingBloc.new);
  sl.registerFactory(() => HomeBloc(sl()));
  sl.registerFactory(() => MenuBloc(sl()));
  sl.registerFactory(() => OrdersBloc(sl(), sl()));
  sl.registerFactory(() => ReportsBloc(sl()));
}
