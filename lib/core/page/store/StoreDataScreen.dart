import 'dart:async';
import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/dropdown/RouteDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/ShopTypeDropdown.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

late StreamSubscription<bool> keyboardSubscription;

class StoreDataScreen extends StatefulWidget {
  const StoreDataScreen({super.key});

  @override
  State<StoreDataScreen> createState() => _StoreDataScreenState();
}

class _StoreDataScreenState extends State<StoreDataScreen> {
  Map<String, dynamic>? _jsonString;
  bool storeInput = true;
  bool taxInput = true;
  bool phoneInput = true;
  bool shoptypeInput = true;
  bool lineIDInput = true;
  bool causeInput = true;

  var keyboardVisibilityController = KeyboardVisibilityController();

  //  late final KeyboardVisibilityController keyboardVisibilityController; // Declare it here
  @override
  void initState() {
    super.initState();
    _loadJson();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if (visible) {
      } else {
        setState(() {
          storeInput = true;
          taxInput = true; // Toggle the flag
          phoneInput = true;
          shoptypeInput = true;
          lineIDInput = true;
          causeInput = true;
        });
      }
    });
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  // Listen to the keyboard visibility changes

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth / 80),
        Row(
          children: [
            const Icon(Icons.store, size: 40),
            const SizedBox(width: 8),
            Text(
              " ${_jsonString?['shop_detail'] ?? "Shop Detail"}",
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
              if (storeInput)
                Customtextinput(
                  onFieldTap: () {
                    setState(() {
                      storeInput = true;
                      taxInput = false; // Toggle the flag
                      phoneInput = false;
                      shoptypeInput = false;
                      lineIDInput = false;
                      causeInput = false;
                    });
                  },
                  context,
                  label: '${_jsonString?['shop_name'] ?? "Shop Name"} *',
                  hint:
                      '${_jsonString?['shop_name_hint'] ?? "Max 36 Characters"}',
                ),
              if (storeInput) const SizedBox(height: 16),
              if (storeInput)
                Customtextinput(
                  onFieldTap: () {
                    setState(() {
                      storeInput = true;
                      taxInput = true; // Toggle the flag
                      phoneInput = false;
                      shoptypeInput = false;
                      lineIDInput = false;
                      causeInput = false;
                    });
                  },
                  context,
                  label: '${_jsonString?['shop_tax'] ?? "Tax ID"} ',
                  hint:
                      '${_jsonString?['shop_tax_hint'] ?? "Max 13 Characters"}',
                ),
              if (storeInput) const SizedBox(height: 16),
              if (storeInput)
                Customtextinput(
                  onFieldTap: () {
                    setState(() {
                      storeInput = false;
                      taxInput = false; // Toggle the flag
                      phoneInput = false;
                      shoptypeInput = false;
                      lineIDInput = false;
                      causeInput = true;
                    });
                  },
                  context,
                  label: 'โทรศัพท์',
                ),
              if (causeInput) const SizedBox(height: 16),
              if (causeInput)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: ShopTypeDropdown(
                          label: 'เลือกประเภทร้านค้า *',
                          onChanged: (value) {},
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SizedBox(
                        // height: 50,
                        child: RouteDropdown(
                            label: "เลือกรูท *", onChanged: (value) {}),
                      ),
                    ),
                  ],
                ),
              if (causeInput) const SizedBox(height: 16),
              if (causeInput)
                Customtextinput(
                  onFieldTap: () {
                    setState(() {
                      storeInput = false;
                      taxInput = false; // Toggle the flag
                      phoneInput = false;
                      shoptypeInput = false;
                      lineIDInput = false;
                      causeInput = true;
                    });
                  },
                  context,
                  label: 'Line ID',
                ),
              if (causeInput) const SizedBox(height: 16),
              if (causeInput)
                Customtextinput(
                  onFieldTap: () {
                    setState(() {
                      storeInput = false;
                      taxInput = false; // Toggle the flag
                      phoneInput = false;
                      shoptypeInput = false;
                      lineIDInput = false;
                      causeInput = true;
                    });
                  },
                  context,
                  label: 'หมายเหตุ',
                ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 80),
      ],
    );
  }
}
