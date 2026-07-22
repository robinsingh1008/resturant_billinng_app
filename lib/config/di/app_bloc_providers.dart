import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';
import 'package:resturent_billinng_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:resturent_billinng_app/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/reports/presentation/bloc/reports_bloc.dart';

class AppBlocProviders extends StatelessWidget {
  const AppBlocProviders({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeBloc>()),
        BlocProvider(create: (_) => sl<MenuBloc>()),
        BlocProvider(create: (_) => sl<OrdersBloc>()),
        BlocProvider(create: (_) => sl<ReportsBloc>()),
      ],
      child: child,
    );
  }
}
