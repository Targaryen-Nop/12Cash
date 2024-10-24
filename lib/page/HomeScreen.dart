import 'package:_12sale_app/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/page/route/RouteScreen.dart';
import 'package:_12sale_app/page/shop/ShopScreen.dart';
// import 'package:_12sale_app/page/TestTabel.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:_12sale_app/components/Header.dart';
import 'package:flutter/material.dart';

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

  static List<Widget> _widgetOptions = <Widget>[
    Dashboardscreen(),
    Routescreen(),
    ShopScreen(),
    Text('Profile'),
    Text('Settings'),
    Text('More'),
  ];

  static const List<Widget> _widgetOptionsHeader = <Widget>[
    DashboardHeader(),
    RouteHeader(),
    ShopHeader(),
    Text('Profile'),
    Text('Settings'),
    Text('More'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _selectedIndex = widget.index; //_selectedIndex
    super.initState();
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
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.route_rounded,
                ),
                label: 'Route',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.storefront,
                ),
                label: 'Shop',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.description,
                ),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.inventory,
                ),
                label: 'Manage',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.more_horiz,
                ),
                label: 'More',
              ),
            ],
            selectedLabelStyle: GobalStyles.text3,
            iconSize: screenWidth / 20,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.white,
            backgroundColor: GobalStyles.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
