import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
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
        Row(
          children: [
            const Icon(
              Icons
                  .location_on_rounded, // Use any icon you want, or load custom icons
              size: 40,
            ),
            const SizedBox(
                width: 8), // Adds some spacing between the icon and text
            Text(
              "ที่อยู่",
              style: Styles.headerBlack24(context),
            ),
          ],
        ),
        SizedBox(height: screenWidth / 80),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Customtextinput(
                    context,
                    label: 'ชื่อร้านค้า *',
                    hint: 'ไม่เกิน 36 ตัวอักษร',
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
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: screenWidth / 80),
        Row(
          children: [
            const Icon(
              Icons.camera_alt, // Use any icon you want, or load custom icons
              size: 40,
            ),
            const SizedBox(
                width: 8), // Adds some spacing between the icon and text
            Text(
              "ภาพถ่าย",
              style: Styles.headerBlack24(context),
            ),
          ],
        ),
        SizedBox(height: screenWidth / 80),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          height: screenWidth / 6,
          child: Center(
            child: const Text("รูปภาพ"),
          ),
        ),
      ],
    );
  }
}
