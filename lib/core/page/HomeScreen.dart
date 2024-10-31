import 'dart:convert';

import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/manage/ManageScreen.dart';
import 'package:_12sale_app/core/page/report/ReportScreen.dart';
import 'package:_12sale_app/core/page/route/RouteScreen.dart';
import 'package:_12sale_app/core/page/setting/SettingScreen.dart';
import 'package:_12sale_app/core/page/shop/ShopScreen.dart';
// import 'package:_12sale_app/page/TestTabel.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/components/Header.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index; //_selectedIndex
    super.initState();
    _loadJson();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Header(
        leading: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        leading2: _widgetOptionsHeader.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color:
              GobalStyles.primaryColor, // Primary color of the navigation bar
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
                icon: Icon(
                  Icons.home,
                ),
                label: _jsonString?['home'] ?? 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.route_rounded,
                ),
                label: _jsonString?['route'] ?? 'Route',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.storefront,
                ),
                label: _jsonString?['shop'] ?? 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory_rounded,
                ),
                label: _jsonString?['report'] ?? 'Report',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory,
                ),
                label: _jsonString?['manage'] ?? 'Manage',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.more_horiz,
                ),
                label: _jsonString?['more'] ?? 'More',
              ),
            ],
            selectedLabelStyle: GobalStyles.text3,
            iconSize: screenWidth / 20,
            currentIndex: _selectedIndex,
            selectedItemColor: Styles.white,
            backgroundColor: Styles.primaryColor,
            unselectedItemColor: Styles.grey,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
