import 'package:flutter/material.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';

class Header extends StatelessWidget {
  final String? title;
  // final String? subtitle;
  final Widget? leading;
  final Widget? leading2;
  // final List<Widget>? actions;
  // final Color backgroundColor;
  // final Color textColor;
  // final double height;
  // final bool centerTitle;

  const Header({
    Key? key,
    this.title,
    // this.subtitle,
    this.leading,
    this.leading2,
    // this.backgroundColor = Colors.blue,
    // this.textColor = Colors.white,
    // this.height = 100.0,
    // this.centerTitle = false,
  }) : super(key: key);
//  final isPortrait = MediaQueryData.orientation == Orientation.portrait;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // final isPortrait =
    //     MediaQuery.of(context).orientation == Orientation.portrait;
    // print(isPortrait);
    return Container(
      color: GobalStyles.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // SizedBox(height: screenWidth / 50),
          Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              // color: Colors.amber,
              child: leading2,
            ),
          ),
          SizedBox(height: screenWidth / 25),
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Soft black color for shadow
                    offset: Offset(0, 5), // Slight downward shadow
                    blurRadius: 100, // Soften the shadow
                    spreadRadius: 10, // How far the shadow extends
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(46)),
              ),
              child: leading!,
            ),
          ),
        ],
      ),
    );
  }
}
