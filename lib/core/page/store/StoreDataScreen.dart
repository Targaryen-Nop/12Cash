import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoreDataScreen extends StatefulWidget {
  const StoreDataScreen({super.key});

  @override
  State<StoreDataScreen> createState() => _StoreDataScreenState();
}

class _StoreDataScreenState extends State<StoreDataScreen> {
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      // padding: const EdgeInsets.all(16.0),
      // margin: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenWidth / 80),
          Row(
            children: [
              const Icon(
                Icons.store, // Use any icon you want, or load custom icons
                size: 40,
              ),
              const SizedBox(
                  width: 8), // Adds some spacing between the icon and text
              Text(
                " ${_jsonString?['shop_detail'] ?? "Shop Detail"}",
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          SizedBox(height: screenWidth / 80),
          Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Customtextinput(
                  context,
                  label: '${_jsonString?['shop_name'] ?? "Shop Name"} *',
                  hint:
                      '${_jsonString?['shop_name_hint'] ?? "Don't More Than 36 Characters"}',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  context,
                  label: '${_jsonString?['shop_tax'] ?? "Tax ID"} ',
                  hint:
                      '${_jsonString?['shop_tax_hint'] ?? "Don't More Than 13 Characters"}',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Customtextinput(
                        context,
                        label: 'โทรศัพท์',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Customtextinput(
                        context,
                        label: 'เส้นทาง',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  context,
                  label: 'ประเภทร้านค้า *',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  context,
                  label: 'ประเภทร้านค้า *',
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth / 80),
        ],
      ),
    );
  }
}
