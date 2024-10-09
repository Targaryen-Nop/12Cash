import 'package:_12sale_app/page/DashboardScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:_12sale_app/components/Header.dart';
import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Dashboardscreen(),
    Text('Search'),
    Text('Favorites'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Header(
        leading: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        leading2: DashboardHeader(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_rounded),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        // unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
