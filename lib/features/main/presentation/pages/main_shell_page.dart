import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resturent_billinng_app/core/di/injection_container.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:resturent_billinng_app/features/home/presentation/pages/home_page.dart';
import 'package:resturent_billinng_app/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:resturent_billinng_app/features/menu/presentation/pages/menu_page.dart';
import 'package:resturent_billinng_app/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:resturent_billinng_app/features/orders/presentation/pages/orders_page.dart';
import 'package:resturent_billinng_app/features/reports/presentation/bloc/reports_bloc.dart';
import 'package:resturent_billinng_app/features/reports/presentation/pages/reports_page.dart';

class MainShellPage extends StatefulWidget {
  const MainShellPage({super.key});

  @override
  State<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends State<MainShellPage> {
  int _index = 0;

  void _startOrder(BuildContext context, OrderType type) {
    context.read<OrdersBloc>().add(OrderTypeStarted(type));
    setState(() => _index = 2);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<HomeBloc>()..add(const HomeStarted())),
        BlocProvider(create: (_) => sl<MenuBloc>()..add(const MenuStarted())),
        BlocProvider(
          create: (_) => sl<OrdersBloc>()..add(const OrdersStarted()),
        ),
        BlocProvider(
          create: (_) => sl<ReportsBloc>()..add(const ReportsStarted()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final pages = [
            HomePage(onStartOrder: (type) => _startOrder(context, type)),
            const MenuPage(),
            const OrdersPage(),
            const ReportsPage(),
          ];

          return Scaffold(
            body: IndexedStack(index: _index, children: pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) {
                setState(() => _index = value);
                if (value == 0) {
                  context.read<HomeBloc>().add(const HomeStarted());
                }
                if (value == 1) {
                  context.read<MenuBloc>().add(const MenuStarted());
                }
                if (value == 2) {
                  context.read<OrdersBloc>().add(const OrdersStarted());
                }
                if (value == 3) {
                  context.read<ReportsBloc>().add(const ReportsStarted());
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.restaurant_menu),
                  label: 'Menu',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long),
                  label: 'Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart),
                  label: 'Reports',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
