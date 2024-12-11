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
  SaleRoute? routes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSaleRoute();
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
          ],
        ),
      ),
    );
  }
}
