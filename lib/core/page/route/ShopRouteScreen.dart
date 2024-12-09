import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/components/badge/CustomBadge.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/SaleRoute.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShopRouteScreen extends StatefulWidget {
  final String day;
  final String route;
  final String status;

  const ShopRouteScreen(
      {super.key,
      required this.day,
      required this.route,
      required this.status});

  @override
  State<ShopRouteScreen> createState() => _ShopRouteScreenState();
}

class _ShopRouteScreenState extends State<ShopRouteScreen> {
  Map<String, dynamic>? _jsonString;
  SaleRoute? routes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
    _loadSaleRoute();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["route"]["shop_screen"];
    });
  }

  Future<void> _loadSaleRoute() async {
    List<SaleRoute> routesData =
        await loadFromStorage('saleRoutes', (json) => SaleRoute.fromJson(json));
    SaleRoute? routeFilter = routesData.firstWhere(
      (route) => route.day == widget.day.split(" ")[1],
    );
    setState(() {
      routes = routeFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${"route.store_screen.title".tr()} ${widget.day}',
            icon: Icons.event),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CustomerDropdownSearch(),
            SizedBox(
              height: screenWidth / 30,
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBadge(
                    label: "route.store_screen.checkin".tr(),
                    count: '${routes?.storeCheckin ?? '0'}',
                    backgroundColor: Styles.successTextColor,
                    countBackgroundColor: Colors.white,
                  ),
                  CustomBadge(
                    label: "route.store_screen.order".tr(),
                    count: '${routes?.storeBuy ?? '0'}',
                    backgroundColor: Styles.paddingTextColor,
                    countBackgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenWidth / 30,
            ),
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBadge(
                    label: "route.store_screen.cancel".tr(),
                    count: '${routes?.storeNotBuy ?? '0'}',
                    backgroundColor: Styles.failTextColor,
                    countBackgroundColor: Colors.white,
                  ),
                  CustomBadge(
                    label: "route.store_screen.all".tr(),
                    count: '${routes?.storeAll ?? '0'}',
                    backgroundColor: Colors.grey,
                    countBackgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: screenWidth / 30,
            ),

            Expanded(
              child: ShopRouteTable(
                day: widget.day,
              ),
            ),
            // const Spacer(),
            // Container(
            //   margin: const EdgeInsets.all(10),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             _jsonString?['shop_target'] ?? 'Shop Target',
            //             style: Styles.headerBlack24(context),
            //           ),
            //           Text(
            //             "17",
            //             style: Styles.headerBlack24(context),
            //           )
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             _jsonString?['shop_visit'] ?? 'Shop Visit',
            //             style: Styles.headerBlack24(context),
            //           ),
            //           Text(
            //             "0",
            //             style: Styles.headerBlack24(context),
            //           )
            //         ],
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             _jsonString?['shop_order'] ?? 'Shop Order',
            //             style: Styles.headerBlack24(context),
            //           ),
            //           Text(
            //             "4",
            //             style: Styles.headerBlack24(context),
            //           )
            //         ],
            //       ),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
