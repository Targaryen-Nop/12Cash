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
    GobalStyles.screenWidth = MediaQuery.of(context).size.width;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    print(isPortrait);
    return Container(
      color: GobalStyles.primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            flex: isPortrait ? 1 : 2,
            child: Container(
              margin: EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              // color: Colors.amber,
              child: leading2,
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.loose,
            child: Container(
              // height: GobalStyles.screenWidth * 1.5,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: leading!,
            ),
          ),
        ],
      ),
    );
  }
}
