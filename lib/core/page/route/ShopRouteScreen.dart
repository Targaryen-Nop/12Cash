import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["route"]["shop_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${_jsonString?['title'] ?? 'Visiting'} ${widget.day}',
            icon: Icons.event),
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
                  style: Styles.headerBlack24(context),
                ),
                Text(
                  widget.route,
                  style: Styles.headerBlack24(context),
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
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _jsonString?['shop_target'] ?? 'Shop Target',
                      style: Styles.headerBlack24(context),
                    ),
                    Text(
                      "17",
                      style: Styles.headerBlack24(context),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _jsonString?['shop_visit'] ?? 'Shop Visit',
                      style: Styles.headerBlack24(context),
                    ),
                    Text(
                      "0",
                      style: Styles.headerBlack24(context),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _jsonString?['shop_order'] ?? 'Shop Order',
                      style: Styles.headerBlack24(context),
                    ),
                    Text(
                      "4",
                      style: Styles.headerBlack24(context),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
