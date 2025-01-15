import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/RouteVisit.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RouteVisitCard extends StatelessWidget {
  final RouteVisit item;
  final VoidCallback onDetailsPressed;
  const RouteVisitCard({
    required this.item,
    required this.onDetailsPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onDetailsPressed,
      child: Container(
        // height: screenWidth / 5,
        margin: EdgeInsets.all(8.0),
        child: BoxShadowCustom(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            // color: Colors.cyan,
            decoration: BoxDecoration(
              // color: Styles.successTextColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                color: Styles.primaryColor,
                                size: 40,
                              ),
                              Text(
                                "Route ${item.day}",
                                style: Styles.black24(context),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "${item.storeCheckin} / ${item.storeAll}",
                                style: Styles.black24(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
