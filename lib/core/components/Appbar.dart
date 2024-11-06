import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class AppbarCustom extends StatefulWidget {
  final String title;
  final IconData icon;
  // final VoidCallback onPressed;

  const AppbarCustom({
    super.key,
    required this.title,
    required this.icon,
    // required this.onPressed,
  });

  @override
  State<AppbarCustom> createState() => _AppbarCustomState();
}

class _AppbarCustomState extends State<AppbarCustom> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            spreadRadius: 3, // Spread radius
            blurRadius: 50, // Blur radius
            offset: const Offset(0, 3),
            // Changes position of the shadow (x, y)
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          // top: Radius.circular(180),
          bottom: Radius.circular(15),
          // top: Radius.circular(50) // Radius at the bottom of the AppBar
        ),
        child: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: screenWidth / 10,
              weight: screenWidth,
            ), // Set the custom size here
            onPressed: () {
              Navigator.of(context).pop(); // Action to go back
            },
          ),
          title: Container(
            // color: Colors.amber,
            child: Row(children: [
              Icon(
                widget.icon,
                size: screenWidth / 15,
              ),
              Text(widget.title),
            ]),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: Styles.headerWhite24(context),
          backgroundColor: GobalStyles.primaryColor,
        ),
      ),
    );
  }
}
