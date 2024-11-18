import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter_offline/flutter_offline.dart';

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

  /// Builds the header widget with a flexible layout displaying leading widgets.
  ///
  /// This function constructs a `Container` widget with a primary color
  /// background, containing a `Column` with two `Flexible` children:
  ///
  /// 1. The first child contains the `leading2` widget and provides a top margin
  ///    and horizontal padding.
  /// 2. The second child contains the `leading` widget, styled with a box shadow,
  ///    light gray background color, and a rounded top border radius.
  ///
  /// The layout adapts to the screen width, adjusting the spacing dynamically.
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // final isPortrait =
    //     MediaQuery.of(context).orientation == Orientation.portrait;
    // print(isPortrait);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
            child: OfflineBuilder(
              connectivityBuilder: (
                BuildContext context,
                List<ConnectivityResult> connectivity,
                Widget child,
              ) {
                final bool connected = connectivity.any((result) =>
                    result == ConnectivityResult.wifi ||
                    result == ConnectivityResult.mobile);

                return connected ? child : Container();
              },
              child: Container(
                color: Styles.primaryColor,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SizedBox(height: screenWidth / 30),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 30, top: 30),
                              // padding: EdgeInsets.all(8),
                              height: screenWidth / 20,
                              width: screenWidth / 20,
                              decoration: const BoxDecoration(
                                color: Colors
                                    .amber, // Primary color of the navigation bar
                                borderRadius:
                                    BorderRadius.all(Radius.circular(360)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26, // Shadow color
                                    blurRadius: 10, // Soft blur effect
                                    spreadRadius: 2, // Spread of the shadow
                                    offset: Offset(
                                        0, -3), // Shadow positioned upwards
                                  ),
                                ],
                              ),
                              // child: Text('data'),
                            ),
                          ],
                        ),
                        Container(
                          height: screenWidth / 4,
                          // margin: EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: leading2,
                        ),
                      ],
                    ),
                    // SizedBox(height: screenWidth / 25),
                    Flexible(
                      flex: 4,
                      fit: FlexFit.loose,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color:
                                  Colors.black26, // Soft black color for shadow
                              offset: Offset(0, 5), // Slight downward shadow
                              blurRadius: 100, // Soften the shadow
                              spreadRadius: 10, // How far the shadow extends
                            ),
                          ],
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(46)),
                        ),
                        child: leading!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
