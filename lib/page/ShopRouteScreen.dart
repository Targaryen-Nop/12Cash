import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class Shoproutescreen extends StatefulWidget {
  final String day;
  final String route;
  final String status;

  const Shoproutescreen(
      {super.key,
      required this.day,
      required this.route,
      required this.status});

  @override
  State<Shoproutescreen> createState() => _ShoproutescreenState();
}

class _ShoproutescreenState extends State<Shoproutescreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " การเข้าเยี่ยม" " " + widget.day, icon: Icons.event),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.status,
                  style: GobalStyles.textbBlack2,
                ),
                Text(
                  widget.route,
                  style: GobalStyles.textbBlack2,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: screenWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: ShopRouteTable(
                day: widget.day,
              ),
            ),
          ),
          Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: EdgeInsets.all(10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ร้านค้าเป้าหมาย",
                    style: GobalStyles.kanit32,
                  ),
                  Text(
                    "17",
                    style: GobalStyles.kanit32,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ร้านค้าที่เข้าเยี่ยม",
                    style: GobalStyles.kanit32,
                  ),
                  Text(
                    "0",
                    style: GobalStyles.kanit32,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ร้านค้าที่สั่งซื้อ",
                    style: GobalStyles.kanit32,
                  ),
                  Text(
                    "4",
                    style: GobalStyles.kanit32,
                  )
                ],
              )
            ]),
          )
        ],
      ),
    );
  }
}
