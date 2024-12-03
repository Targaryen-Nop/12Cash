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
  Map<String, dynamic>? staticData;

  VerifyStoreScreen({
    Key? key,
    required this.storeData,
    required this.staticData,
  }) : super(key: key);

  @override
  State<VerifyStoreScreen> createState() => _VerifyStoreScreenState();
}

class _VerifyStoreScreenState extends State<VerifyStoreScreen> {
  // Store? _storeData;
  String storeImagePath = "";
  String taxIdImagePath = "";
  String personalImagePath = "";
  @override
  void initState() {
    super.initState();
    // _loadJson();
    _loadStoreFromStorage();
  }

  // Future<void> _loadJson() async {
  //   String jsonString = await rootBundle.loadString('lang/main-th.json');
  //   setState(() {
  //     _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
  //   });
  // }

  Future<void> _loadStoreFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Get the JSON string list from SharedPreferences
    String? jsonStore = prefs.getString("add_store");

    if (jsonStore != null) {
      for (var value in widget.storeData.imageList.reversed) {
        if (value.type == "store") {
          setState(() {
            storeImagePath = value.path;
          });
        } else if (value.type == 'tax') {
          setState(() {
            taxIdImagePath = value.path;
          });
        } else {
          setState(() {
            personalImagePath = value.path;
          });
        }
      }
    }
  }

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
                "${widget.staticData?['title'] ?? "Shop Detail"}",
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          ),
          Text.rich(
            TextSpan(
              text:
                  '${widget.staticData?['name'] ?? "Name"}', // This is the main text style
              style: Styles.headerBlack24(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' : ${widget.storeData.copyWith().name}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          // Text(
          //   "${widget.staticData?['name'] ?? "Name"} : ${widget.storeData.copyWith().name}",
          //   style: Styles.headerBlack24(context),
          // ),
          Text.rich(
            TextSpan(
              text:
                  '${widget.staticData?['tel'] ?? "Phone"}', // This is the main text style
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
              text:
                  '${widget.staticData?['taxId'] ?? "Tax ID"}', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      " : ${widget.storeData.taxId != '' ? widget.storeData.taxId : '-'}",
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text:
                  '${widget.staticData?['route'] ?? "Route"}', // This is the main text style
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
              text:
                  '${widget.staticData?['shopType'] ?? "Shop Type"}', // This is the main text style
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
              text:
                  '${widget.staticData?['lineId'] ?? "Line ID"}', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' : ${widget.storeData.lineId != '' ? widget.storeData.lineId : '-'}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text:
                  '${widget.staticData?['note'] ?? "Note"}', // This is the main text style
              style: Styles.headerBlack18(context),
              children: <TextSpan>[
                TextSpan(
                  text:
                      ' : ${widget.storeData.note != '' ? widget.storeData.note : '-'}', // Inline bold text
                  style: Styles.black18(context),
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              text:
                  '${widget.staticData?['address'] ?? "Address"}', // This is the main text style
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
                "${widget.staticData?['title_image'] ?? "Image"}",
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
                label: "${widget.staticData?['image_store'] ?? "Store"}",
                icon: Icons.image_not_supported_outlined,
                imagePath: storeImagePath != "" ? storeImagePath : null,
              ),
              ShowPhotoButton(
                label: "${widget.staticData?['image_taxId'] ?? "Tax ID"}",
                icon: Icons.image_not_supported_outlined,
                imagePath: taxIdImagePath != "" ? taxIdImagePath : null,
              ),
              ShowPhotoButton(
                label:
                    "${widget.staticData?['image_identify'] ?? "Personal Identify"}",
                icon: Icons.image_not_supported_outlined,
                imagePath: personalImagePath != "" ? personalImagePath : null,
              )
            ],
          )
        ],
      ),
    );
  }
}
