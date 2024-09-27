import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currerntIndex = 1;
  List<IconData> navigationIcons = [
    Icons.home,
    Icons.route_rounded,
    Icons.storefront,
    Icons.description,
    Icons.inventory,
    Icons.more_horiz
  ];

  void changePage(int newIndex) {
    setState(() {
      currerntIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
