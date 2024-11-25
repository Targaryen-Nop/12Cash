import 'dart:convert';

import 'package:_12sale_app/core/components/button/IconButtonWithLabel.dart';
import 'package:_12sale_app/core/components/button/ShowPhotoButton.dart';
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.store, size: 40),
              const SizedBox(width: 8),
              Text(
                "${_jsonString?['shop_detail'] ?? "Shop Detail"}",
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
          Text(
            "ชื่อ : ${widget.storeData.copyWith().name}",
            style: Styles.headerBlack24(context),
          ),
          Text.rich(
            TextSpan(
              text: 'โทรศัพท์', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' : ${widget.storeData.copyWith().tel}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'เลขผู้เสียภาษี', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text: " : ${widget.storeData.taxId}",
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'เส้นทาง', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text: ' : ${widget.storeData.route}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'ประเภทร้านค้า', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text: ' : ${widget.storeData.typeName}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'Line ID', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text: ' : ${widget.storeData.lineId}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'หมายเหตุ', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text: ' : ${widget.storeData.note}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text: 'ที่อยู่', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' : ${widget.storeData.address} ${widget.storeData.province != 'กรุงเทพมหานคร' ? 'ต.' : 'แขวง'}${widget.storeData.subDistrict} ${widget.storeData.province != 'กรุงเทพมหานคร' ? 'อ.' : 'เขต'}${widget.storeData.district} ${widget.storeData.province != 'กรุงเทพมหานคร' ? 'จ.' : ''}${widget.storeData.province} ${widget.storeData.postcode}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth / 37),
          Row(
            children: [
              const Icon(Icons.photo, size: 40),
              const SizedBox(width: 8),
              Text(
                "ภาพถ่าย",
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
          SizedBox(height: screenWidth / 37),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShowPhotoButton(
                label: "ร้านค้า",
                icon: Icons.image_not_supported_outlined,
                imagePath: widget.storeData.imageList.length > 0
                    ? widget.storeData.imageList[0]
                    : null,
              ),
              ShowPhotoButton(
                label: "พรก.",
                icon: Icons.image_not_supported_outlined,
                imagePath: widget.storeData.imageList.length > 1
                    ? widget.storeData.imageList[1]
                    : null,
              ),
              ShowPhotoButton(
                label: "สำเนาบัตรปปช.",
                icon: Icons.image_not_supported_outlined,
                imagePath: widget.storeData.imageList.length > 2
                    ? widget.storeData.imageList[2]
                    : null,
              )
            ],
          )
        ],
      ),
    );
  }
}
