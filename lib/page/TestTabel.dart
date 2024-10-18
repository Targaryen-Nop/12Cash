import 'package:_12sale_app/components/CustomerDropdownSearch.dart';
import 'package:_12sale_app/components/Table.dart';
import 'package:_12sale_app/components/table/TableFullData.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // For date localization

class Routescreen extends StatefulWidget {
  const Routescreen({super.key});

  @override
  State<Routescreen> createState() => _RoutescreenState();
}

class _RoutescreenState extends State<Routescreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          border: Border.all(
              color: Colors.grey, width: 1), // Border around the entire table
          borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
        ),
        child: TableFullData());
  }
}

class RouteHeader extends StatefulWidget {
  const RouteHeader({super.key});

  @override
  State<RouteHeader> createState() => _RouteHeaderState();
}

class _RouteHeaderState extends State<RouteHeader> {
  @override
  Widget build(BuildContext context) {
    GobalStyles.screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              // Flexible(
              //   flex: 1,
              //   fit: FlexFit.tight,
              //   child: Container(
              //     margin: const EdgeInsets.symmetric(horizontal: 4),
              //     height: 150,
              //     // color: Colors.red,
              //     child: Container(
              //       decoration: const BoxDecoration(
              //         image: DecorationImage(
              //           image: AssetImage('assets/images/12TradingLogo.png'),
              //           // fit: BoxFit.fitWidth,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      // color: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                            // padding: EdgeInsets.only(top: 25),
                            child: Icon(Icons.event,
                                size: 50, color: Colors.white),
                          ), // Calendar Icon
                          SizedBox(width: 10),
                          Text(
                            'เส้นทางเข้าเยี่ยม',
                            style: GobalStyles.headline3,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        fit: FlexFit.tight,
                        child: Row(children: [
                          Container(
                            // margin: EdgeInsets.only(left: 60),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'เดือน ${DateFormat('MMMM', 'th').format(DateTime.now())} ${DateTime.now().year + 543}',
                              style: GobalStyles.headline3,
                            ),
                          ),
                          Flexible(
                              fit: FlexFit.loose,
                              child: StreamBuilder(
                                  stream: Stream.periodic(
                                      const Duration(seconds: 1)),
                                  builder: (context, snapshot) {
                                    return Container(
                                      // color: Colors.green,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        DateFormat('hh:mm:ss a')
                                            .format(DateTime.now()),
                                        style: GobalStyles.headline3,
                                      ),
                                    );
                                  }))
                        ])),
                    const Flexible(
                      fit: FlexFit.tight,
                      child: CustomerDropdownSearch(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
