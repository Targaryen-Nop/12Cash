import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _selectedIndex = 0;

  Icon _getIcon() {
    switch (_selectedIndex) {
      case 0:
        return Icon(Icons.shopping_basket, size: 30);
      case 1:
        return Icon(Icons.shopping_cart_checkout_outlined, size: 30);
      case 2:
        return Icon(Icons.shopping_basket, size: 30);
      case 3:
        return Icon(Icons.shopping_basket, size: 30);
      default:
        return Icon(Icons.shopping_basket, size: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Selected Index: $_selectedIndex'),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          setState(() {
            _selectedIndex = 2; // Update to the cart index
          });
        },
        backgroundColor: Colors.orange,
        child: Stack(
          alignment: Alignment.center,
          children: [_getIcon()],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view),
              label: 'Catalog',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
