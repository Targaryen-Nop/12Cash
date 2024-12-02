import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
import 'package:_12sale_app/core/components/button/MenuButton.dart';
import 'package:_12sale_app/core/components/dropdown/DropDownStandarad.dart';
import 'package:_12sale_app/core/components/table/DetailTable.dart';
// import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTableMapAPI.dart';
import 'package:_12sale_app/core/page/route/OrderScreen.dart';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/SaleRoute.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DetailScreen extends StatefulWidget {
  final String customerNo;
  final String day;
  final String customerName;
  final String address;
  final String status;

  const DetailScreen(
      {super.key,
      required this.customerNo,
      required this.day,
      required this.customerName,
      required this.address,
      required this.status});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? _jsonString;
  String? imagePath; // Path to store the captured image
  String selectedCause = 'เลือกเหตุผล';
  Store? store;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
    // _loadStoreDetail();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["detail_screen"];
    });
  }

  // Future<void> StoreDetail() async {
  //   List<SaleRoute> routesData =
  //       await loadFromStorage('saleRoutes', (json) => SaleRoute.fromJson(json));

  //   // Extract day from the widget's `day` property
  //   String day = widget.day.split(" ")[1];

  //   // Find the first `SaleRoute` where the `day` matches
  //   SaleRoute? routeFilter = routesData.firstWhere(
  //     (route) => route.day == day,
  //   );

  //   // If a matching route is found, find the store with the specific storeId
  //   Store? storeDetail;

  //   storeDetail = routeFilter.listStore.firstWhere(
  //     (store) => store.storeInfo.storeId == widget.customerNo,
  //   );

  //   setState(() {
  //     store = storeDetail;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${_jsonString?['title'] ?? 'Visiting'} ${widget.day}',
            icon: Icons.event),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Styles.primaryColor, // Primary color of the navigation bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 10, // Soft blur effect
              spreadRadius: 2, // Spread of the shadow
              offset: Offset(0, -3), // Shadow positioned upwards
            ),
          ],
        ),
        child: ClipRRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MenuButton(
                icon: Icons.cancel_rounded,
                label: _jsonString?['cancel_order_button'] ?? 'Cancel Order',
                color: Colors.red,
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
              MenuButton(
                icon: Icons.add_shopping_cart_rounded,
                label: _jsonString?['order_button'] ?? 'Order',
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Orderscreen(
                          customerNo: widget.customerNo,
                          customerName: widget.customerName,
                          status: widget.status),
                    ),
                  );
                },
              ),
              MenuButton(
                icon: Icons.add_a_photo,
                label: _jsonString?['camera_button'] ?? 'Camera',
                color: Colors.blue,
                onPressed: () {
                  _showBottomCamera(context);
                },
              ),
              MenuButton(
                icon: Icons.transfer_within_a_station_sharp,
                label: _jsonString?['credit_note_button'] ?? 'CN',
                color: const Color.fromARGB(255, 234, 175, 0),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Orderscreen(
                          customerNo: widget.customerNo,
                          customerName: widget.customerName,
                          status: widget.status),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('รหัสร้าน ${widget.customerNo}',
                  style: Styles.headerBlack24(context)),
              Text("ร้าน ${widget.customerName}",
                  style: Styles.headerBlack24(context)),
              Text("ที่อยู่ ${widget.address}",
                  style: Styles.headerBlack24(context)),
              const SizedBox(height: 10),
              SizedBox(
                height: screenWidth / 2,
                child: DetailTable(
                  day: widget.day,
                  customerNo: widget.customerNo,
                ),
              ),
              SizedBox(height: screenWidth / 37),
              BoxShadowCustom(
                  child: Container(
                color: Colors.white,
                height: screenWidth / 2,
              ))
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full screen height
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (
        BuildContext context,
      ) {
        double screenWidth = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            width: screenWidth, // Fixed width
            height: screenWidth * 0.8,
            padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ระบุสาเหตุที่ร้านค้าไม่ซื้อ',
                        style: Styles.headerBlack32(context),
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close bottom sheet
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Store Information
                  Text(
                    'รหัสร้าน 10334587',
                    style: Styles.black24(context),
                  ),
                  Text(
                    'ร้าน เจริญพรค้าขาย',
                    style: Styles.black24(context),
                  ),
                  const SizedBox(height: 16),
                  DropDownStandard(
                    selectedValue: selectedCause,
                    items: const [
                      'เลือกเหตุผล',
                      'เหตุผล 1',
                      'เหตุผล 2',
                      'อื่นๆ'
                    ],
                    hintText: 'เลือกเหตุผล', // Default hint text
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedCause = newValue!;
                      });
                      // print('Selected Cause: $selectedCause');
                    },
                  ),
                  const SizedBox(height: 16),
                  selectedCause == 'อื่นๆ'
                      ? TextField(
                          style: Styles.black18(context),
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'ใส่ข้อมูล',
                            hintStyle: Styles.black18(context),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        )
                      : const SizedBox(height: 0),
                  // Text input field

                  const SizedBox(height: 16),

                  // Save button
                  SizedBox(
                    width: double.infinity, // Full width button
                    child: ElevatedButton(
                      onPressed: () {
                        // Perform save action
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.successButtonColor,
                        // padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          Text('บันทึก', style: Styles.headerWhite32(context)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showBottomCamera(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full screen height
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return Container(
          width: screenWidth, // Fixed width
          height: screenWidth / 1.2,
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with close button
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close bottom sheet
                      },
                    ),
                    Text('จัดเก็บรูปภาพ', style: Styles.headerBlack32(context)),
                  ],
                ),
                const SizedBox(height: 8),
                // Store Information
                const CameraButtonWidget(),
                const SizedBox(height: 16),
                // Save button
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform save action
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.successButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    child: Text('บันทึกรูปภาพ',
                        style: Styles.headerWhite24(context)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
