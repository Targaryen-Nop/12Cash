import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/components/badge/CustomBadge.dart';
import 'package:_12sale_app/core/components/card/RouteShopVisitCard.dart';
import 'package:_12sale_app/core/components/card/RouteVisitCard2.dart';
import 'package:_12sale_app/core/components/card/StoreVisitCard.dart';
import 'package:_12sale_app/core/components/card/StoreVisitCard2.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/route/TestGooglemap.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/models/route/RouteVisit.dart';
import 'package:_12sale_app/data/models/route/StoreVisit.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopRouteScreen2 extends StatefulWidget {
  final String routeId;
  final String route;
  final RouteVisit2 routeVisit;
  // final List<Store> listStore;

  const ShopRouteScreen2({
    super.key,
    required this.routeId,
    required this.route,
    required this.routeVisit,
    // required this.listStore,
  });

  @override
  State<ShopRouteScreen2> createState() => _ShopRouteScreen2State();
}

class _ShopRouteScreen2State extends State<ShopRouteScreen2> {
  List<ListStore> listStore = [];
  List<StoreVisit> storeVisit = [];
  String period =
      "${DateTime.now().year}${DateFormat('MM').format(DateTime.now())}";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getListStore();
    // _loadSaleRoute();
  }

  Future<void> _getListStore() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint:
          'api/cash/route/getRoute?area=${User.area}&period=${period}&routeId=${widget.routeId}',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'][0]['listStore'];
      final List<dynamic> dataStore = response.data['data'];
      print("getRoute: ${response.data['data']}");
      if (mounted) {
        setState(() {
          listStore = data.map((item) => ListStore.fromJson(item)).toList();
          storeVisit =
              dataStore.map((item) => StoreVisit.fromJson(item)).toList();
        });
      }
      print("storeVisit: $storeVisit");
      print("listStore: ${data.length}");
    }
  }

  // Future<void> _loadSaleRoute() async {
  //   List<SaleRoute> routesData =
  //       await loadFromStorage('saleRoutes', (json) => SaleRoute.fromJson(json));
  //   SaleRoute? routeFilter = routesData.firstWhere(
  //     (route) => route.day == widget.day.split(" ")[1],
  //   );
  //   setState(() {
  //     routes = routeFilter;
  //   });
  // }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(
        enableJavaScript: true,
      ),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${"route.store_screen.title".tr()} ${widget.route}',
            icon: Icons.event),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    alignment: Alignment.center,
                    child: RouteShopVisitCard(
                      item: widget.routeVisit,
                      onDetailsPressed: () {},
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      alignment: Alignment.center,
                      child: BoxShadowCustom(
                        shadowColor: Colors.red,
                        borderColor: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Effective",
                                    style: Styles.black20(context),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "40%",
                                    style: Styles.headerRed32(context),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
            // const CustomerDropdownSearch(),
            // Container(
            //   alignment: Alignment.center,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CustomBadge(
            //         label: "route.store_screen.checkin".tr(),
            //         count: '${routes?.storeCheckin ?? '0'}',
            //         backgroundColor: Styles.successTextColor,
            //         countBackgroundColor: Colors.white,
            //       ),
            //       CustomBadge(
            //         label: "route.store_screen.order".tr(),
            //         count: '${routes?.storeBuy ?? '0'}',
            //         backgroundColor: Styles.paddingTextColor,
            //         countBackgroundColor: Colors.white,
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: screenWidth / 30,
            // ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       CustomBadge(
            //         label: "route.store_screen.cancel".tr(),
            //         count: '${routes?.storeNotBuy ?? '0'}',
            //         backgroundColor: Styles.failTextColor,
            //         countBackgroundColor: Colors.white,
            //       ),
            //       CustomBadge(
            //         label: "route.store_screen.all".tr(),
            //         count: '${routes?.storeAll ?? '0'}',
            //         backgroundColor: Colors.grey,
            //         countBackgroundColor: Colors.white,
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   height: screenWidth / 30,
            // ),
            // Expanded(child: BoxShadowCustom(child: PolylineWithLabels())),
            SizedBox(
              height: screenWidth / 30,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listStore.length,
                itemBuilder: (context, index) {
                  return StoreVisitCard2(
                    isFirst: index == 0,
                    isLast: index == listStore.length - 1,
                    store: listStore[index],
                    routeId: widget.routeId,
                    route: widget.route,
                  );
                },
              ),
            ),

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: listStore.length,
            //     itemBuilder: (context, index) {
            //       return Text(
            //         '${listStore[index].status}',
            //         style: Styles.black18(context),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
              height: screenWidth / 20,
            ),

            // TextButton.icon(
            //   icon: const FaIcon(FontAwesomeIcons.google, color: Colors.white),
            //   style: ButtonStyle(
            //     backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
            //   ),
            //   onPressed: () async {
            //     // final String url =
            //     //     'https://www.google.com/maps/dir/?api=1&origin=${origin.latitude},${origin.longitude}'
            //     //     '&destination=${destination.latitude},${destination.longitude}'
            //     //     '&waypoints=$waypointsString'
            //     //     '&travelmode=$travelMode';
            //     final Uri url = Uri.parse(
            //         "https://www.google.com/maps/dir/?api=1&origin=13.689600,100.608600&destination=13.918764,100.56767&waypoints=13.760493,100.474507|13.71104,100.517814&travelmode=driving");
            //     _launchUrl(url);
            //   },
            //   label: Text(
            //     "เปิด Google Maps",
            //     style: Styles.white18(context),
            //   ),
            // ),
            // SizedBox(
            //   height: screenWidth / 30,
            // ),
            // Expanded(
            //   child: ShopRouteTable(
            //     day: widget.day,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
