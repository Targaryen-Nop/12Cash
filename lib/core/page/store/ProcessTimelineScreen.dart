import 'dart:math';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/sheet/PolicyAddNewShop.dart';
import 'package:_12sale_app/core/page/store/PolicyScreen.dart';
import 'package:_12sale_app/core/page/store/StoreAddressScreen.dart';
import 'package:_12sale_app/core/page/store/StoreDataScreen.dart';
import 'package:_12sale_app/core/page/store/VerifyStoreScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:timelines/timelines.dart';

const kTileHeight = 50.0;
const completeColor = Color(0xff5e6172);
const inProgressColor = Styles.primaryColor;
const todoColor = Color(0xffd1d2d7);

class ProcessTimelinePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex = 0;

  Widget _getBodyContent() {
    // Returns different widgets based on the _processIndex
    switch (_processIndex) {
      case 0:
        return const PolicyScreen();
      case 1:
        return const StoreDataScreen();
      case 2:
        return const StoreAddressScreen();
      case 3:
        return const VerifyStoreScreen();
      default:
        return Center(child: Text("Unknown step"));
    }
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " เพิ่มร้านค้า", icon: Icons.store_mall_directory_rounded),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Timeline.tileBuilder(
                theme: TimelineThemeData(
                  direction: Axis.horizontal,
                  connectorTheme: const ConnectorThemeData(
                    space: 30.0,
                    thickness: 5.0,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  connectionDirection: ConnectionDirection.before,
                  itemExtentBuilder: (_, __) =>
                      MediaQuery.of(context).size.width / 4.4,
                  oppositeContentsBuilder: (context, index) {
                    // Define a list of icons for each step
                    final List<IconData> stepIcons = [
                      Icons.handshake, // Icon for "Prospect"
                      Icons.store_mall_directory, // Icon for "Tour"
                      Icons.map, // Icon for "Offer"
                      Icons.check_circle_outlined, // Icon for "Contract"
                    ];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: GestureDetector(
                        onTap: () => setState(() => _processIndex = index),
                        child: Icon(
                          stepIcons[
                              index], // Use the icon corresponding to the current step
                          size: 30.0,
                          color: getColor(index),
                        ),
                      ),
                    );
                  },
                  contentsBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        _processes[index],
                        style: Styles.black18(context),
                      ),
                    );
                  },
                  indicatorBuilder: (_, index) {
                    var color;
                    var child;
                    if (index == _processIndex) {
                      color = inProgressColor;
                      child = const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      );
                    } else if (index < _processIndex) {
                      color = completeColor;
                      child = GestureDetector(
                        onTap: () => setState(() => _processIndex = index),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      );
                    } else {
                      color = todoColor;
                    }

                    if (index <= _processIndex) {
                      return Stack(
                        children: [
                          CustomPaint(
                            size: Size(30.0, 30.0),
                            painter: _BezierPainter(
                              color: color,
                              drawStart: index > 0,
                              drawEnd: index < _processIndex,
                            ),
                          ),
                          DotIndicator(
                            size: 30.0,
                            color: color,
                            child: child,
                          ),
                        ],
                      );
                    } else {
                      return Stack(
                        children: [
                          CustomPaint(
                            size: const Size(15.0, 15.0),
                            painter: _BezierPainter(
                              color: color,
                              drawEnd: index < _processes.length - 1,
                            ),
                          ),
                          OutlinedDotIndicator(
                            borderWidth: 4.0,
                            color: color,
                          ),
                        ],
                      );
                    }
                  },
                  connectorBuilder: (_, index, type) {
                    if (index > 0) {
                      if (index == _processIndex) {
                        final prevColor = getColor(index - 1);
                        final color = getColor(index);
                        List<Color> gradientColors;
                        if (type == ConnectorType.start) {
                          gradientColors = [
                            Color.lerp(prevColor, color, 0.5)!,
                            color
                          ];
                        } else {
                          gradientColors = [
                            prevColor,
                            Color.lerp(prevColor, color, 0.5)!
                          ];
                        }
                        return DecoratedLineConnector(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradientColors,
                            ),
                          ),
                        );
                      } else {
                        return SolidLineConnector(
                          color: getColor(index),
                        );
                      }
                    } else {
                      return null;
                    }
                  },
                  itemCount: _processes.length,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color if needed
                  borderRadius: BorderRadius.circular(
                      16), // Rounded corners for the outer container

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Shadow color with transparency
                      spreadRadius: 2, // Spread of the shadow
                      blurRadius: 8, // Blur radius of the shadow
                      offset: const Offset(
                          0, 4), // Offset of the shadow (horizontal, vertical)
                    ),
                  ],
                ),
                // color: Colors.black,
                child: _getBodyContent(),
              ), // Displays different content for each step
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              16), // Rounded corners for the outer container

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with transparency
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 8, // Blur radius of the shadow
                              offset: const Offset(0,
                                  4), // Offset of the shadow (horizontal, vertical)
                            ),
                          ],
                        ),
                        width: screenWidth / 3,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_processIndex == 0) {
                            } else {
                              setState(() {
                                _processIndex =
                                    (_processIndex - 1) % _processes.length;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth / 85,
                                horizontal: screenWidth / 17),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('กลับ', style: Styles.white18(context)),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              16), // Rounded corners for the outer container

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with transparency
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 8, // Blur radius of the shadow
                              offset: const Offset(0,
                                  4), // Offset of the shadow (horizontal, vertical)
                            ),
                          ],
                        ),
                        width: screenWidth / 3,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_processIndex == 3) {
                            } else {
                              setState(() {
                                _processIndex =
                                    (_processIndex + 1) % _processes.length;
                              });
                            }

                            switch (_processIndex) {
                              case 0:
                                return print('1');
                              case 1:
                                return print('2');
                              case 2:
                                return print('3');
                              case 3:
                                return print('4');
                              default:
                                return print('error');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Styles.successButtonColor,
                            padding: EdgeInsets.symmetric(
                                vertical: screenWidth / 80,
                                horizontal: screenWidth / 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(_processIndex == 3 ? 'ยืนยัน' : 'ถัดไป',
                              style: Styles.white18(context)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(FontAwesomeIcons.chevronRight),
      //   onPressed: () {
      //     setState(() {
      //       _processIndex = (_processIndex + 1) % _processes.length;
      //     });
      //   },
      //   backgroundColor: inProgressColor,
      // ),
    );
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}

final _processes = ['ความยินยอม', 'ข้อมูลร้าน', 'ที่อยู่', 'ยืนยัน'];
