import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/page/route/DetailScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/route/StoreVisit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path/path.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:timeline_tile/timeline_tile.dart';

class StoreVisitCard2 extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final ListStore store;
  final String route;
  final String routeId;

  const StoreVisitCard2({
    super.key,
    required this.isFirst,
    required this.isLast,
    required this.store,
    required this.route,
    required this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: 30,
        height: 30,
        color:
            (store.status == '1' || store.status == '2' || store.status == '3')
                ? Styles.primaryColor
                : store.status == '3'
                    ? Styles.failTextColor
                    : Colors.grey,
        indicator: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: (store.status == '1' ||
                      store.status == '2' ||
                      store.status == '3')
                  ? Styles.primaryColor
                  : store.status == '3'
                      ? Styles.failTextColor
                      : Colors.grey,
            ),
            child: (store.status == '1' ||
                    store.status == '2' ||
                    store.status == '3')
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : SizedBox()),
      ),
      afterLineStyle: LineStyle(
        thickness: 1,
        color:
            (store.status == '1' || store.status == '2' || store.status == '3')
                ? Styles.successTextColor
                : Colors.grey,
      ),
      beforeLineStyle: LineStyle(
        thickness: 1,
        color:
            (store.status == '1' || store.status == '2' || store.status == '3')
                ? Styles.successTextColor
                : Colors.grey,
      ),
      endChild: StoreCard(
        store: store,
        route: route,
        routeId: routeId,
      ),
    );
  }
}

class StoreCard extends StatelessWidget {
  final ListStore store;
  final String route;
  final String routeId;

  const StoreCard({
    super.key,
    required this.store,
    required this.route,
    required this.routeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailScreen(
        //       typeName: store.storeInfo.typeName,
        //       routeId: routeId,
        //       route: route,
        //       customerNo: store.storeInfo.storeId,
        //       customerName: store.storeInfo.name,
        //       address: store.storeInfo.address,
        //       status: store.status,
        //     ),
        //   ),
        // );
      },
      child: Card(
        margin: EdgeInsets.only(left: 10, top: 5, right: 2, bottom: 5),
        color: Colors.white,
        child: ExpansionTile(
          minTileHeight: 100,
          // collapsedBackgroundColor: Colors.white,
          backgroundColor: Colors.grey[100],
          leading: Icon(
            Icons.store_rounded,
            color: Styles.primaryColor,
            size: 50,
          ),
          collapsedShape: RoundedRectangleBorder(
              side: BorderSide.none, // No border when collapsed
              borderRadius: BorderRadius.all(Radius.circular(16))),
          shape: RoundedRectangleBorder(
              side: BorderSide.none, // No border when expanded
              borderRadius: BorderRadius.all(Radius.circular(16))),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  store.storeInfo.name,
                  style: Styles.black18(context),
                ),
              ),
              Container(
                // padding: EdgeInsets.symmetric(horizontal: 8),
                width: 100,
                decoration: BoxDecoration(
                  color: store.status == '1'
                      ? Styles.successTextColor
                      : store.status == '2'
                          ? Styles.primaryColor
                          : Colors.green[600],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${store.statusText}ไม่ซื้อ',
                  style: Styles.white18(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${store.storeInfo.storeId}',
            style: Styles.black18(context),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "ประเภท: ${store.storeInfo.typeName}",
                        style: Styles.black18(context),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "ที่อยู่: ${store.storeInfo.address}",
                                style: Styles.black18(context),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "สถานะ: ${store.status}",
                                style: Styles.black18(context),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "จำนวนออเดอร์: ${store.status}",
                                style: Styles.black18(context),
                              ),
                            ],
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DetailScreen(
                          //       typeName: store.storeInfo.typeName,
                          //       routeId: routeId,
                          //       route: route,
                          //       customerNo: store.storeInfo.storeId,
                          //       customerName: store.storeInfo.name,
                          //       address: store.storeInfo.address,
                          //       status: store.status,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: EdgeInsets.all(8),
                          width: 125,
                          decoration: BoxDecoration(
                            color: Styles.successTextColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'รายละเอียด',
                            style: Styles.white18(context),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
