import 'dart:convert';
import 'package:_12sale_app/core/components/search/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/components/table/RouteTable.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Routescreen extends StatefulWidget {
  const Routescreen({super.key});

  @override
  State<Routescreen> createState() => _RoutescreenState();
}

class _RoutescreenState extends State<Routescreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // margin: EdgeInsets.only(top: 30),
      // padding: EdgeInsets.all(25),
      child: Column(
        children: [
          // SizedBox(
          //   height: screenWidth / 30,
          // ),
          Container(
              margin: EdgeInsets.all(screenWidth / 50),
              child: const RouteTable()),
        ],
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Expanded(
      //       child: SingleChildScrollView(
      //         // scrollDirection: Axis.,
      //         child: Container(
      //           width: 1000,
      //           decoration: BoxDecoration(
      //             border: Border.all(
      //                 color: Colors.grey,
      //                 width: 1), // Border around the entire table
      //             borderRadius:
      //                 BorderRadius.circular(8), // Optional: Rounded corners
      //           ),
      //           child: TableFullData(),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}

class RouteHeader extends StatefulWidget {
  const RouteHeader({super.key});

  @override
  State<RouteHeader> createState() => _RouteHeaderState();
}

class _RouteHeaderState extends State<RouteHeader> {
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["route"]["route_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  // color: Colors.red,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/12TradingLogo.png'),
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Center(
                  // margin: EdgeInsets.only(top: 10),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          // color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.event,
                                      size: 25, color: Colors.white),
                                  Text(
                                    ' ${_jsonString?['title'] ?? 'Route'}',
                                    style: Styles.headerWhite24,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       ' เดือน ${DateFormat('MMMM', 'th').format(DateTime.now())} ${DateTime.now().year + 543}',
                              //       style: Styles.headerWhite24,
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          ' เดือน ${DateFormat('MMMM', 'th').format(DateTime.now())} ${DateTime.now().year + 543}',
                          style: Styles.headerWhite24,
                        ),
                      ),
                      const Flexible(
                          fit: FlexFit.loose, child: CustomerDropdownSearch()),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
