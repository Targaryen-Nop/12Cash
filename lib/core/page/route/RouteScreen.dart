import 'dart:convert';
import 'package:_12sale_app/core/components/search/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/components/search/TestDropdown.dart';
import 'package:_12sale_app/core/components/table/RouteTable.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/SaleRoute.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Routescreen extends StatefulWidget {
  const Routescreen({super.key});

  @override
  State<Routescreen> createState() => _RoutescreenState();
}

class _RoutescreenState extends State<Routescreen> {
  List<SaleRoute> _routes = [];

  @override
  initState() {
    super.initState();
    _loadSaleRoute();
  }

  Future<void> _loadSaleRoute() async {
    String jsonSaleRoute = await rootBundle.loadString('data/sale_route.json');
    List<dynamic> jsonData = jsonDecode(jsonSaleRoute);

    setState(() {
      _routes = jsonData
          .map((data) => SaleRoute.fromJson(data as Map<String, dynamic>))
          .toList();
    });
    await saveToStorage('saleRoutes', _routes);
  }

  // Future<void> _saveSaleRouteToStorage(List<SaleRoute> routes) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Convert each SaleRoute to JSON and encode it as a JSON string
  //   List<String> jsonRoutes =
  //       routes.map((route) => jsonEncode(route.toJson())).toList();

  //   // Save the JSON string list to SharedPreferences
  //   await prefs.setStringList('saleRoutes', jsonRoutes);
  // }

  // Future<List<SaleRoute>> _loadSaleRouteFromStorage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? jsonRoutes = prefs.getStringList('saleRoutes');

  //   if (jsonRoutes == null) return [];

  //   return jsonRoutes
  //       .map((jsonRoute) => SaleRoute.fromJson(jsonDecode(jsonRoute)))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        // SizedBox(
        //   height: screenWidth / 30,
        // ),
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(8),
              margin: EdgeInsets.all(screenWidth / 45),
              child: const RouteTable()),
        ),
      ],
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
                                    style: Styles.headerWhite24(context),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       ' เดือน ${DateFormat('MMMM', 'th').format(DateTime.now())} ${DateTime.now().year + 543}',
                              //       style: Styles.headerWhite24(context),
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
                          style: Styles.headerWhite24(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomerDropdownSearch(),
          ),
        ),
      ],
    );
  }
}
