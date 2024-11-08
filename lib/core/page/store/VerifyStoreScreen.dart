import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyStoreScreen extends StatefulWidget {
  const VerifyStoreScreen({super.key});

  @override
  State<VerifyStoreScreen> createState() => _VerifyStoreScreenState();
}

class _VerifyStoreScreenState extends State<VerifyStoreScreen> {
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
            const Icon(Icons.store, size: 40),
            const SizedBox(width: 8),
            Text(
              " ${_jsonString?['shop_detail'] ?? "Shop Detail"}",
              style: Styles.headerBlack24(context),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'เลขผู้เสียภาษี : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'โทรศัพท์ : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'ประเภท : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'Line ID : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'หมายเหตุ : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
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
        Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'ที่อยู่ : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'แขวง/ตำบล : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'เขต/อำเภอ : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'จังหวัด : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 37),
        Text.rich(
          TextSpan(
            text: 'รหัสไปรษณีย์ : ', // This is the main text style
            style: Styles.headerBlack18(context),
            children: <TextSpan>[
              TextSpan(
                text: '123456', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
