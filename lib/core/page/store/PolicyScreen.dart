import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:flutter/material.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  final ScrollController _scrollController = ScrollController();
  bool isChecked = false;
  bool _isCheckboxEnabled = false;
  bool _isCheckboxChecked = false;
  // List<Store> _store = [];
  Store? _storeData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  final TextEditingController _controller = TextEditingController(
    text: "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านอมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า"
        "dawd55555555555555555555555555555555555555555"
        "ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า", // Long text for testing
  );
  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Check if the user has scrolled to the bottom
  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isCheckboxEnabled = true; // Enable the checkbox
      });
    }
  }

  Future<void> _saveStoreToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert Store object to JSON string
    String jsonStoreString = json.encode(_storeData!.toJson());

    // Save the JSON string list to SharedPreferences
    await prefs.setString('add_store', jsonStoreString);
  }

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Text('ขอความยินยอม', style: Styles.headerBlack24(context)),
          SizedBox(height: 8),
          Text(
            'ข้อมูลร้านค้า ข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้าข้อมูลร้านค้า',
            style: Styles.black18(context),
          ),
          SizedBox(height: 16),
          // Store Information (scrollable container)

          // Scrollable TextField with Scrollbar
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Styles.primaryColor,
                    width: 1,
                  )),
              child: Scrollbar(
                thumbVisibility: true, // Make scrollbar visible while scrolling
                controller: _scrollController, // Controller for scrolling
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: TextField(
                    readOnly: true,
                    controller: _controller,
                    style: Styles.black18(context),
                    maxLines:
                        null, // Allows the text field to expand vertically
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Checkbox with label
          Row(
            children: [
              Checkbox(
                value: _isCheckboxChecked,
                onChanged: _isCheckboxEnabled
                    ? (value) {
                        setState(() {
                          _isCheckboxChecked = value ?? false;

                          _storeData ??= Store(
                            storeId: "",
                            name: "",
                            taxId: "",
                            tel: "",
                            route: "",
                            type: "",
                            typeName: "",
                            address: "",
                            district: "",
                            subDistrict: "",
                            province: "",
                            provinceCode: "",
                            zone: "",
                            area: "",
                            latitude: "",
                            longitude: "",
                            lineId: "",
                            note: "",
                            approve: Approve(
                              dateSend: "",
                              dateAction: "",
                              appPerson: "",
                            ),
                            status: "",
                            policyConsent: [],
                            imageList: [],
                            shippingAddress: [],
                            createdDate: "",
                            updatedDate: "",
                          );

                          // Update only the policyConsent field using copyWith
                          _storeData = _storeData?.copyWith(
                            policyConsent: [
                              PolicyConsent(
                                status: 'Agree',
                                date: DateTime.now().toString(),
                              ),
                            ],
                          );

                          // print(_storeData?.policyConsent[0].status);
                          // _storeData = Store(
                          //     storeId: "storeId",
                          //     name: "name",
                          //     taxId: "taxId",
                          //     tel: "tel",
                          //     route: "route",
                          //     type: "type",
                          //     typeName: "typeName",
                          //     address: "address",
                          //     district: "district",
                          //     subDistrict: "subDistrict",
                          //     province: "province",
                          //     provinceCode: "provinceCode",
                          //     zone: "zone",
                          //     area: "area",
                          //     latitude: "latitude",
                          //     longitude: "longitude",
                          //     lineId: "lineId",
                          //     note: "note",
                          //     approve: Approve(
                          //         dateSend: "dateSend",
                          //         dateAction: "dateAction",
                          //         appPerson: "appPerson"),
                          //     status: "status",
                          //     policyConsent: [
                          //       PolicyConsent(
                          //           status: 'Agree',
                          //           date: DateTime.now().toString()),
                          //     ],
                          //     imageList: [],
                          //     shippingAddress: [],
                          //     createdDate: "createdDate",
                          //     updatedDate: "updatedDate");
                        });
                        // final policyConsent = _store.policyConsent[0].status = "Agree";
                        // _store.policyConsent[0].status = 'Agree';

                        _saveStoreToStorage();
                      }
                    : null, // Disable checkbox until scrolled to bottom
              ),
              Text(
                'ฉันยินยอมให้เก็บข้อมูล',
                style: GoogleFonts.kanit(
                  textStyle: TextStyle(
                    fontSize: screenWidth / 35,
                    fontWeight: FontWeight.w600,
                    color: _isCheckboxEnabled ? Colors.black : Colors.grey,
                  ),
                ), //, // Disable the text as well
              ),
            ],
          ),

          // Buttons at the bottom
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Container(
          //         width: screenWidth / 3,
          //         child: ElevatedButton(
          //           onPressed: () {
          //             // Navigator.of(context).push(
          //             //   MaterialPageRoute(
          //             //     builder: (context) => Orderscreen(
          //             //         customerNo: widget.customerNo,
          //             //         customerName: widget.customerName,
          //             //         status: widget.status),
          //             //   ),
          //             // );
          //           },
          //           child: Text('กลับ', style: Styles.white18(context)),
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: GobalStyles.primaryColor,
          //             padding: EdgeInsets.symmetric(
          //                 vertical: screenWidth / 85,
          //                 horizontal: screenWidth / 17),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //         ),
          //       ),
          //       Container(
          //         width: screenWidth / 3,
          //         child: ElevatedButton(
          //           onPressed: () {},
          //           child: Text('ถัดไป', style: Styles.white18(context)),
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: GobalStyles.successButtonColor,
          //             padding: EdgeInsets.symmetric(
          //                 vertical: screenWidth / 80,
          //                 horizontal: screenWidth / 11),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(8),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
