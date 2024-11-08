import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/dropdown/DropdownCustom.dart';
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
              Customtextinput(
                context,
                label: '${_jsonString?['shop_name'] ?? "Shop Name"} *',
                hint:
                    '${_jsonString?['shop_name_hint'] ?? "Max 36 Characters"}',
              ),
              const SizedBox(height: 16),
              Customtextinput(
                context,
                label: '${_jsonString?['shop_tax'] ?? "Tax ID"} ',
                hint: '${_jsonString?['shop_tax_hint'] ?? "Max 13 Characters"}',
              ),
              const SizedBox(height: 16),
              Customtextinput(
                context,
                label: 'โทรศัพท์',
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      // height: 50,
                      child: DropdownCustom(
                        label: 'เลือกประเภทร้านค้า *',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: SizedBox(
                      // height: 50,
                      child: DropdownCustom(
                        label: 'เลือกรูท *',
                        items: ['Option 1', 'Option 2', 'Option 3'],
                        onChanged: (value) {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Customtextinput(
                context,
                label: 'Line ID',
              ),
              const SizedBox(height: 16),
              Customtextinput(
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
