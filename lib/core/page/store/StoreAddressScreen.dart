import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/dropdown/DropdownCustom.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoreAddressScreen extends StatefulWidget {
  const StoreAddressScreen({super.key});

  @override
  State<StoreAddressScreen> createState() => _StoreAddressScreenState();
}

class _StoreAddressScreenState extends State<StoreAddressScreen> {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth / 80),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 40),
            const SizedBox(width: 8),
            Text(
              " ${_jsonString?['shop_address'] ?? "Shop Address"}",
              style: Styles.headerBlack24(context),
            ),
          ],
        ),
        SizedBox(height: screenWidth / 80),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth / 37),
              Customtextinput(
                context,
                label: 'ที่อยู่ *',
              ),
              SizedBox(height: screenWidth / 37),
              DropdownCustom(
                label: 'เลือกอำเภอ *',
                items: ['Option 1', 'Option 2', 'Option 3'],
                onChanged: (value) {},
              ),
              SizedBox(height: screenWidth / 37),
              DropdownCustom(
                label: 'เลือกอำเภอ *',
                items: ['Option 1', 'Option 2', 'Option 3'],
                onChanged: (value) {},
              ),
              SizedBox(height: screenWidth / 37),
              DropdownCustom(
                label: 'ตำบล *',
                items: ['Option 1', 'Option 2', 'Option 3'],
                onChanged: (value) {},
              ),
              SizedBox(height: screenWidth / 37),
              Customtextinput(
                context,
                label: 'รหัสไปรษณีย์',
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 80),
      ],
    );
  }
}
