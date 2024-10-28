import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class AppbarCustom extends StatefulWidget {
  final String title;
  final IconData icon;
  // final VoidCallback onPressed;

  const AppbarCustom({
    Key? key,
    required this.title,
    required this.icon,
    // required this.onPressed,
  }) : super(key: key);

  @override
  State<AppbarCustom> createState() => _AppbarCustomState();
}

class _AppbarCustomState extends State<AppbarCustom> {
  @override
  Widget build(BuildContext context) {
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
          bottom: Radius.circular(50),
          // top: Radius.circular(50) // Radius at the bottom of the AppBar
        ),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 50,
                weight: 10,
              ), // Set the custom size here
              onPressed: () {
                Navigator.of(context).pop(); // Action to go back
              },
            ),
          ),
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Icon(
                widget.icon,
                size: 50,
              ),
            ),
            Text(widget.title),
          ]),
          centerTitle: true,
          foregroundColor: Colors.white,
          titleTextStyle: GobalStyles.headline2,
          backgroundColor: GobalStyles.primaryColor,
        ),
      ),
    );
  }
}
