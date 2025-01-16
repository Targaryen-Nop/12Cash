import 'dart:async';
import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
import 'package:_12sale_app/core/components/button/MenuButton.dart';
import 'package:_12sale_app/core/components/card/InvoiceCard.dart';
import 'package:_12sale_app/core/components/chart/CircularChart.dart';
import 'package:_12sale_app/core/components/chart/ItemSummarize.dart';
import 'package:_12sale_app/core/components/chart/TrendingMusicChart.dart';
import 'package:_12sale_app/core/components/dropdown/DropDownStandarad.dart';
import 'package:_12sale_app/core/components/table/DetailTable.dart';
// import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTableMapAPI.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/route/OrderScreen.dart';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/service/apiService.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String? imagePath; // Path to store the captured image
  String selectedCause = 'เลือกเหตุผล';
  Store? store;
  List<Store> storeAll = [];
  bool _loadingAllStore = true;
  double completionPercentage = 220;

  @override
  void initState() {
    super.initState();
    _getStoreDataAll();
  }

  Future<void> _getStoreDataAll() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();
      var response = await apiService.request(
        endpoint:
            'api/cash/store/getStore?area=${User.area}&type=all', // You only need to pass the endpoint, the base URL is handled
        method: 'GET',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data['data'];
        print(response.data['data']);
        setState(() {
          storeAll = data.map((item) => Store.fromJson(item)).toList();
        });
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _loadingAllStore = false;
            });
          }
        });
      }
    } catch (e) {
      print(e);
    }
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
            title: ' ${"route.detail_screen.title".tr()}', icon: Icons.event),
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
              BoxShadowCustom(
                child: MenuButton(
                  icon: Icons.cancel_rounded,
                  label: "route.detail_screen.cancel.title".tr(),
                  // color: Colors.red,
                  color: Styles.failTextColor,
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                ),
              ),
              BoxShadowCustom(
                child: MenuButton(
                  icon: Icons.add_shopping_cart_rounded,
                  label: "route.detail_screen.order_button".tr(),
                  // color: Colors.teal,
                  color: Styles.successTextColor,
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
              ),
              BoxShadowCustom(
                child: MenuButton(
                  icon: Icons.add_a_photo,
                  label: "route.detail_screen.camera.title".tr(),
                  color: Styles.primaryColor,
                  // color: Colors.grey,
                  onPressed: () {
                    _showBottomCamera(context);
                  },
                ),
              ),
              BoxShadowCustom(
                child: MenuButton(
                  icon: Icons.transfer_within_a_station_sharp,
                  label: "route.detail_screen.credit_note_button".tr(),
                  // color: const Color.fromARGB(255, 234, 175, 0),
                  color: Styles.accentColor,
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
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        edgeOffset: 0,
        color: Colors.white,
        backgroundColor: Styles.primaryColor,
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('ข้อมูลร้านค้า ${widget.customerName}',
                    style: Styles.black24(context)),
                BoxShadowCustom(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${'route.detail_screen.store_name'.tr()} : ${widget.customerName}",
                                  style: Styles.black18(context)),
                              Text(
                                  '${'route.detail_screen.store_id'.tr()} : ${widget.customerNo}',
                                  style: Styles.black18(context)),
                              Text('รูท : ${widget.day}',
                                  style: Styles.black18(context)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${'route.detail_screen.store_address'.tr()} : ${widget.address}",
                            style: Styles.black18(context),
                            textAlign: TextAlign.end,
                            // overflow: TextOverflow.ellipsis,
                            // textDirection: TextDirection.,
                            // textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text('Dashboard', style: Styles.black24(context)),
                BoxShadowCustom(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 35),
                            child: CustomPaint(
                              size: Size(200, 200),
                              painter: CircularChartPainter(
                                  completionPercentage: completionPercentage),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Text(
                                    //   "เป้าหมาย",
                                    //   style: Styles.black24(context),
                                    // ),
                                    Text(
                                      "${((completionPercentage * 100) / 360).toStringAsFixed(2)}%",
                                      style: Styles.black24(context),
                                    ),
                                    Text(
                                      "150,000 ฿",
                                      style: Styles.black24(context),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          "ยอดขาย",
                                          style: Styles.black24(context),
                                        ),
                                        Row(
                                          children: [
                                            FaIcon(FontAwesomeIcons.caretUp,
                                                color:
                                                    Styles.successButtonColor),
                                            Text(
                                              " 10%",
                                              style: Styles.green10(context),
                                            ),
                                            Text(
                                              " ${1500} บาท",
                                              style: Styles.green24(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      children: [
                                        Text(
                                          "ยอดคืน",
                                          style: Styles.black24(context),
                                        ),
                                        Row(
                                          children: [
                                            FaIcon(FontAwesomeIcons.caretDown,
                                                color: Styles.failTextColor),
                                            Text(
                                              " 10%",
                                              style: Styles.red10(context),
                                            ),
                                            Text(
                                              " ${1500} บาท",
                                              style:
                                                  Styles.headerRed24(context),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(
                                        "เป้าหมาย",
                                        style: Styles.black24(context),
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.caretDown,
                                              color: Styles.failTextColor),
                                          Text(
                                            " 10%",
                                            style: Styles.red10(context),
                                          ),
                                          Text(
                                            " ${1500} บาท",
                                            style: Styles.headerRed24(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      Text(
                                        "ยอดรวม",
                                        style: Styles.black24(context),
                                      ),
                                      Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.caretDown,
                                              color: Styles.failTextColor),
                                          Text(
                                            " 10%",
                                            style: Styles.red10(context),
                                          ),
                                          Text(
                                            " ${1500} บาท",
                                            style: Styles.headerRed24(context),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              // height: 400,
                              // width: 500,
                              child: ItemSummarize(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // SizedBox(
                //   height: screenWidth / 2,
                //   child: DetailTable(
                //     day: widget.day,
                //     customerNo: widget.customerNo,
                //   ),
                // ),
                SizedBox(height: screenWidth / 37),
                Text('รายการสั่งซื้อ', style: Styles.black24(context)),
                Container(
                  height: 500,
                  child: LoadingSkeletonizer(
                    loading: _loadingAllStore,
                    child: BoxShadowCustom(
                      child: ListView.builder(
                        itemCount: storeAll.length,
                        itemBuilder: (context, index) {
                          return InvoiceCard(
                            item: storeAll[index],
                            onDetailsPressed: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                        'route.detail_screen.cancel.case'.tr(),
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
                    '${'route.detail_screen.cancel.store_id'.tr()} 10334587',
                    style: Styles.black24(context),
                  ),
                  Text(
                    '${'route.detail_screen.cancel.store_name'.tr()}  เจริญพรค้าขาย',
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
                    hintText: 'route.detail_screen.cancel.hint'
                        .tr(), // Default hint text
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
                      child: Text('route.detail_screen.cancel.submit'.tr(),
                          style: Styles.headerWhite32(context)),
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
                    Text('route.detail_screen.camera.hint'.tr(),
                        style: Styles.headerBlack32(context)),
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
                    child: Text('route.detail_screen.camera.submit'.tr(),
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
