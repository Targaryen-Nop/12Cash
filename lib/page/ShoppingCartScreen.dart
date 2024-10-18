import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String itemCode;
  final String itemName;
  final String price;

  const ShoppingCartScreen(
      {super.key,
      required this.itemCode,
      required this.itemName,
      required this.price});
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
