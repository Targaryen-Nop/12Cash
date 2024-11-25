import 'dart:convert';

import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/manage/ManageScreen.dart';
import 'package:_12sale_app/core/page/report/ReportScreen.dart';
import 'package:_12sale_app/core/page/route/RouteScreen.dart';
import 'package:_12sale_app/core/page/setting/SettingScreen.dart';
import 'package:_12sale_app/core/page/store/StoreScreen.dart';
// import 'package:_12sale_app/page/TestTabel.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/components/Header.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final int index;
  final String? imagePath;

  const HomeScreen({
    super.key,
    required this.index,
    this.imagePath,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _jsonString;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboardscreen(),
    Routescreen(),
    ShopScreen(),
    ReportScreen(),
    ManageScreen(),
    SettingScreen(),
  ];

  static const List<Widget> _widgetOptionsHeader = <Widget>[
    DashboardHeader(),
    RouteHeader(),
    ShopHeader(),
    ReportHeader(),
    ManageHeader(),
    SettingHeader(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["menu"];
    });
  }

  List<Order> _orders = <Order>[];

  Future<void> _clearOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders'); // Clear orders from SharedPreferences
    // await prefs.remove('ท'); // Clear orders from SharedPreferences
    setState(() {
      _orders.clear(); // Clear orders in the UI
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index; //_selectedIndex
    super.initState();
    _loadJson();
    _clearOrders();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Header(
        leading: Center(child: _widgetOptions.elementAt(_selectedIndex)),
        leading2: _widgetOptionsHeader.elementAt(_selectedIndex),
      ),
      // body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Styles.primaryColor, // Primary color of the navigation bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 10, // Soft blur effect
              spreadRadius: 2, // Spread of the shadow
              offset: Offset(0, -3), // Shadow positioned upwards
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.home,
                ),
                label: _jsonString?['home'] ?? 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.route_rounded,
                ),
                label: _jsonString?['route'] ?? 'Route',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.storefront,
                ),
                label: _jsonString?['shop'] ?? 'Shop',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.inventory_rounded,
                ),
                label: _jsonString?['report'] ?? 'Report',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.inventory,
                ),
                label: _jsonString?['manage'] ?? 'Manage',
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.more_horiz,
                ),
                label: _jsonString?['more'] ?? 'More',
              ),
            ],
            selectedLabelStyle: Styles.white18(context),
            iconSize: screenWidth / 20,
            currentIndex: _selectedIndex,
            selectedItemColor: Styles.white,
            backgroundColor: Styles.primaryColor,
            unselectedItemColor: Styles.grey,
            unselectedLabelStyle: Styles.grey12(context),
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
