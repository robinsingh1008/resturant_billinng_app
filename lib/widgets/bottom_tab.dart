import 'package:flutter/material.dart';
import 'package:resturent_billinng_app/core/assets/icon_assets.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/core/models/restaurant_models.dart';
import 'package:resturent_billinng_app/features/home/presentation/pages/home_page.dart';
import 'package:resturent_billinng_app/features/menu/presentation/pages/menu_page.dart';
import 'package:resturent_billinng_app/features/orders/presentation/pages/orders_page.dart';
import 'package:resturent_billinng_app/features/reports/presentation/pages/reports_page.dart';

class BottomTab extends StatefulWidget {
  const BottomTab({super.key, required this.selectedIndex});

  final int selectedIndex;

  @override
  State<BottomTab> createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  late int _selectedIndex;
  OrderType? _menuInitialOrderType;
  int _menuOpenNonce = 0;

  List<Widget> get _widgetOptions => <Widget>[
    HomePage(onOpenMenu: _openMenuTab),
    MenuPage(
      key: ValueKey('menu-${_menuInitialOrderType?.name}-$_menuOpenNonce'),
      initialOrderType: _menuInitialOrderType,
    ),
    const OrdersPage(),
    const ReportsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = _safeIndex(widget.selectedIndex);
  }

  @override
  void didUpdateWidget(covariant BottomTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _selectedIndex = _safeIndex(widget.selectedIndex);
    }
  }

  int _safeIndex(int index) {
    if (index < 0 || index >= _widgetOptions.length) return 0;
    return index;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = _safeIndex(index);
    });
  }

  void _openMenuTab(OrderType orderType) {
    setState(() {
      _menuInitialOrderType = orderType;
      _menuOpenNonce++;
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: const MyDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(ImageTabAssets.home, height: 30),
                activeIcon: Image.asset(ImageTabAssets.colorhome, height: 30),
                label: "Home",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ImageTabAssets.menu, height: 30),
                activeIcon: Image.asset(ImageTabAssets.colormenu, height: 30),
                label: "Menu",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ImageTabAssets.orders, height: 30),
                activeIcon: Image.asset(ImageTabAssets.colororders, height: 30),
                label: "Orders",
                backgroundColor: Colors.white,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(ImageTabAssets.report, height: 25),
                activeIcon: Image.asset(ImageTabAssets.colorreport, height: 25),
                label: "Reports",
                backgroundColor: Colors.white,
              ),
            ],
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.primary,
            iconSize: 20,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(color: Colors.black26),
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
