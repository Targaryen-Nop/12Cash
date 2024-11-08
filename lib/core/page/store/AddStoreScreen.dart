import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/components/sheet/PolicyAddNewShop.dart';
import 'package:_12sale_app/core/components/sheet/ReasonForNotBuyingSheet%20.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
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
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " ${_jsonString?['title'] ?? "Add New Shop"}",
            icon: Icons.store_mall_directory_rounded),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                  style: Styles.black18(context),
                ),
              ],
            ),
            SizedBox(height: screenWidth / 80),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              height: screenWidth / 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      Expanded(
                        child: Customtextinput(
                          context,
                          label: 'โทรศัพท์',
                        ),
                      ),
                      const SizedBox(width: 16),
                      const SizedBox(height: 16),
                      Customtextinput(
                        context,
                        label: 'ประเภทร้านค้า *',
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
                  Icons
                      .location_on_rounded, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                const SizedBox(
                    width: 8), // Adds some spacing between the icon and text
                Text(
                  "ที่อยู่",
                  style: Styles.black18(context),
                ),
              ],
            ),
            SizedBox(height: screenWidth / 80),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              height: screenWidth / 3,
              child: SingleChildScrollView(
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
                  Icons
                      .camera_alt, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                const SizedBox(
                    width: 8), // Adds some spacing between the icon and text
                Text(
                  "ภาพถ่าย",
                  style: Styles.black18(context),
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
            Spacer(),
            ButtonFullWidth(
                onPressed: () {
                  showReasonForNotBuyingSheet(
                      context, '10334587', 'ร้าน เจริญพรค้าขาย');
                },
                text: "ถัดไป",
                textStyle: Styles.white18(context),
                blackGroundColor: GobalStyles.successButtonColor)
          ],
        ),
      ),
    );
  }

  void showReasonForNotBuyingSheet(
      BuildContext context, String storeCode, String storeName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full screen height
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Policyaddnewshop();
      },
    );
  }

  Widget _buildInputField(BuildContext context,
      {required String label, String? hint}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
