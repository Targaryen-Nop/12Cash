import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyStoreScreen extends StatefulWidget {
  final Store storeData;

  const VerifyStoreScreen({
    Key? key,
    required this.storeData,
  }) : super(key: key);

  @override
  State<VerifyStoreScreen> createState() => _VerifyStoreScreenState();
}

class _VerifyStoreScreenState extends State<VerifyStoreScreen> {
  Map<String, dynamic>? _jsonString;
  // Store? _storeData;

  @override
  void initState() {
    super.initState();
    _loadJson();
    // _loadStoreFromStorage();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  // Future<void> _loadStoreFromStorage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Get the JSON string list from SharedPreferences
  //   String? jsonStore = prefs.getString("add_store");

  //   if (jsonStore != null) {
  //     setState(() {
  //       _storeData =
  //           // ignore: unnecessary_null_comparison
  //           jsonStore == null ? null : Store.fromJson(jsonDecode(jsonStore));
  //     });
  //   }
  // }

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
                text: " ${widget.storeData.name}",
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
                text: ' ${widget.storeData.tel}', // Inline bold text
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
                text: '${widget.storeData.typeName}', // Inline bold text
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
                text: '${widget.storeData.lineId}', // Inline bold text
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
                text: '${widget.storeData.note}', // Inline bold text
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
                text: '${widget.storeData.address}', // Inline bold text
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
                text: '${widget.storeData.subDistrict}', // Inline bold text
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
                text: '${widget.storeData.district}', // Inline bold text
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
                text: '${widget.storeData.province}', // Inline bold text
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
                text: '${widget.storeData.postcode}', // Inline bold text
                style: Styles.black18(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
