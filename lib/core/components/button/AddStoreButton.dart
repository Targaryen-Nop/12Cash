import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class AddStoreButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final double iconSize;

  const AddStoreButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor =
        Styles.primaryColor, // Default color if none provided
    this.iconSize = 24.0, // Default icon size if none provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      shape: const CircleBorder(),
      child: Icon(
        icon,
        color: Colors.white,
        size: screenWidth / 12,
      ),
    );
  }
}
