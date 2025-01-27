import 'dart:async';
import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/alert/Alert.dart';
import 'package:_12sale_app/core/components/button/CameraExpand.dart';
import 'package:_12sale_app/core/components/button/CameraPreviewScreen.dart';
import 'package:_12sale_app/core/components/button/IconButtonWithLabelFixed.dart';
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
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/models/route/DetailStoreVisit.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:_12sale_app/data/service/locationService.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:toastification/toastification.dart';

class DetailScreen extends StatefulWidget {
  final String customerNo;
  final String routeId;

  DetailScreen({
    super.key,
    required this.customerNo,
    required this.routeId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? checkinImagePath; // Path to store the captured image
  String selectedCause = 'เลือกเหตุผล';
  String latitude = '00.00';
  String longitude = '00.00';
  DetailStoreVisit? storeDetail;
  bool _loadingDetailStore = true;
  double completionPercentage = 220;
  final LocationService locationService = LocationService();
  TextEditingController noteController = TextEditingController();
  late DetailStoreVisit? detailStoreVisit;
  String status = "0";
  int statusCheck = 0;

  String period =
      "${DateTime.now().year}${DateFormat('MM').format(DateTime.now())}";

  // String

  @override
  void initState() {
    super.initState();
    _getDetailStore();

    // _getStoreDataAll();
  }

  Future<void> _getDetailStore() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint:
          'api/cash/route/getRoute?area=${User.area}&period=${period}&routeId=${widget.routeId}&storeId=${widget.customerNo}',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      // print("getRoute: ${response.data['data']}");
      if (mounted) {
        setState(() {
          storeDetail =
              data.isNotEmpty ? DetailStoreVisit.fromJson(data[0]) : null;
          status = storeDetail?.listStore[0].status ?? "0";
          statusCheck = int.tryParse(status) ?? 0;
        });
      }
      Timer(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _loadingDetailStore = false;
          });
        }
      });
      print("getstoreDetail: $storeDetail");
      print("statusCheck: $statusCheck");
    }
  }

  Future<void> fetchLocation() async {
    try {
      // Initialize the location service
      await locationService.initialize();

      // Get latitude and longitude
      double? lat = await locationService.getLatitude();
      double? lon = await locationService.getLongitude();

      setState(() {
        latitude = lat?.toString() ?? "Unavailable";
        longitude = lon?.toString() ?? "Unavailable";
      });
      print("${latitude}, ${longitude}");
    } catch (e) {
      if (mounted) {
        setState(() {
          latitude = "Error fetching latitude";
          longitude = "Error fetching longitude";
        });
      }
      print("Error: $e");
    }
  }

  Future<void> checkInStore() async {
    try {
      await fetchLocation();
      Dio dio = Dio();
      MultipartFile? imageFile;
      imageFile = await MultipartFile.fromFile(checkinImagePath!);
      if (checkinImagePath != null) {
        // print(
        //     "Check Data  : routeId ${widget.routeId}, storeId${widget.customerNo}, note${selectedCause}, checkInImage${imageFile}, latitude${latitude}, longtitude${longitude}");
        var formData = FormData.fromMap(
          {
            'routeId': storeDetail?.id,
            'storeId': widget.customerNo,
            'note': selectedCause,
            'checkInImage': imageFile,
            // "note":
            //     noteController.text != "" ? noteController.text : selectedCause,
            // "checkInImage": imageFile,
            "latitude": latitude,
            "longtitude": longitude
          },
        );
        var response = await dio.post(
          // '${ApiService.apiHost}/api/cash/route/checkIn',
          'http://192.168.44.57:8006/api/cash/route/checkIn',
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );
        if (response.statusCode == 201 || response.statusCode == 200) {
          print("Response API ${response.data}");
          toastification.show(
            autoCloseDuration: const Duration(seconds: 5),
            context: context,
            primaryColor: Colors.green,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: Text(
              "store.processtimeline_screen.toasting_success".tr(),
              style: Styles.black18(context),
            ),
          );
          setState(() {
            statusCheck = 2;
            storeDetail?.listStore[0].status = '2';
          });
        }
      }
    } on ApiException catch (e) {
      print('Error: ${e.message}');
      CustomAlertDialog.showCommonAlert(context, "เกิดข้อผิดพลาด",
          "${e.message} Status Code: ${e.statusCode}");
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${"route.detail_screen.title".tr()}', icon: Icons.event),
      ),
      body: RefreshIndicator(
        edgeOffset: 0,
        color: Colors.white,
        backgroundColor: Styles.primaryColor,
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: LoadingSkeletonizer(
            loading: _loadingDetailStore,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BoxShadowCustom(
                    // color: Styles.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${storeDetail?.listStore[0].storeInfo.name}",
                                        style: Styles.black24(context)),
                                    Text(
                                        '${'route.detail_screen.store_id'.tr()} : ${widget.customerNo}',
                                        style: Styles.black18(context)),
                                    Text('รูท : R${storeDetail?.day}',
                                        style: Styles.black18(context)),
                                    Text(
                                        'ประเภทร้านค้า : ${storeDetail?.listStore[0].storeInfo.typeName}',
                                        style: Styles.black18(context)),
                                    Text(
                                        'สถานะ : ${storeDetail?.listStore[0].status == '2' ? 'เช็คอินแล้ว' : 'ยังไม่ได้เช็คอิน'}',
                                        style: Styles.black18(context)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  "${'route.detail_screen.store_address'.tr()} : ${storeDetail?.listStore[0].storeInfo.address}",
                                  style: Styles.black18(context),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MenuButton(
                                icon: Icons.store_rounded,
                                label: "เช็คอิน",
                                // color: Styles.success!,
                                color: statusCheck > 0
                                    ? Colors.grey
                                    : Styles.bluePastel,
                                onPressed: () {
                                  if (statusCheck <= 0) {
                                    _showCheckInSheet(context);
                                    setState(() {
                                      selectedCause = "เลือกสาเหตุ";
                                    });
                                  }
                                },
                              ),
                              MenuButton(
                                icon: Icons.add_shopping_cart_rounded,
                                label: "route.detail_screen.order_button".tr(),
                                // color: Styles.success!,
                                // color: Colors.teal,
                                color:
                                    statusCheck > 0 ? Colors.grey : Colors.teal,
                                onPressed: () {
                                  if (statusCheck <= 0) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Orderscreen(
                                            customerNo: widget.customerNo,
                                            customerName: storeDetail!
                                                .listStore[0].storeInfo.name,
                                            status: status),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: screenWidth / 37),
                  BoxShadowCustom(
                    child: SizedBox(
                        height: 325,
                        width: screenWidth,
                        child: ItemSummarize()),
                  ),
                  SizedBox(height: screenWidth / 37),
                  Text('รายการสั่งซื้อ', style: Styles.black24(context)),
                  // Container(
                  //   height: 300,
                  //   child: LoadingSkeletonizer(
                  //     loading: _loadingAllStore,
                  //     child: BoxShadowCustom(
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 16),
                  //         child: ListView.builder(
                  //           itemCount: storeAll.length,
                  //           itemBuilder: (context, index) {
                  //             return InvoiceCard(
                  //               item: storeAll[index],
                  //               onDetailsPressed: () {},
                  //             );
                  //           },
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: screenWidth / 37),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCheckInSheet(BuildContext context) {
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
        // double screenWidth = MediaQuery.of(context).size.width;
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            width: screenWidth * 0.9, // Fixed width
            // height: screenWidth * 0.8,
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
                        'เช็คอินร้านค้า',
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
                    '${storeDetail?.listStore[0].storeInfo.name}',
                    style: Styles.black24(context),
                  ),
                  Text(
                    '${widget.customerNo}',
                    style: Styles.black24(context),
                  ),

                  CameraExpand(
                    icon: Icons.photo_camera,
                    imagePath: checkinImagePath != "" ? checkinImagePath : null,
                    label: "หน้าร้านค้า",
                    onImageSelected: (String imagePath) async {
                      setState(() {
                        checkinImagePath = imagePath;
                      });
                      print("checkinImagePath: ${checkinImagePath}");
                      print("Route ID : ${storeDetail?.id}");
                      print(
                          "Route ID : ${storeDetail?.listStore[0].storeInfo.id}");
                      print("Test Check-in : ${noteController.text}");
                      print(
                          "Test Check-in ${noteController.text != "" ? noteController.text : selectedCause}");
                      // await uploadFormDataWithDio(imagePath, 'store', context);
                    },
                  ),

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: DropDownStandard(
                      selectedValue: selectedCause,

                      items: const [
                        'เลือกเหตุผล',
                        'เช็คอิน',
                        'ร้านค้าไม่ซื้อ',
                        'อื่นๆ'
                      ],
                      hintText: 'route.detail_screen.cancel.hint'
                          .tr(), // Default hint text
                      onChanged: (String? newValue) {
                        noteController.clear();
                        setModalState(
                          () {
                            selectedCause = newValue!;
                          },
                        );
                        // print('Selected Cause: $selectedCause');
                      },
                    ),
                  ),
                  // const SizedBox(height: 16),
                  selectedCause == 'อื่นๆ'
                      ? Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          child: TextField(
                            controller: noteController,
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
                          ),
                        )
                      : const SizedBox(height: 0),
                  // Text input field

                  // const SizedBox(height: 16),

                  // Save button
                  Container(
                    // margin: EdgeInsets.symmetric(vertical: 16),
                    // padding: const EdgeInsets.all(8.0),
                    width: double.infinity, // Full width button
                    child: ElevatedButton(
                      onPressed: () async {
                        // Perform save action
                        Alert(
                          context: context,
                          title:
                              "store.processtimeline_screen.alert.title".tr(),
                          style: AlertStyle(
                            animationType: AnimationType.grow,
                            isCloseButton: true,
                            isOverlayTapDismiss: false,
                            descStyle: Styles.black18(context),
                            descTextAlign: TextAlign.start,
                            animationDuration:
                                const Duration(milliseconds: 400),
                            alertBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            titleStyle: Styles.headerBlack32(context),
                            alertAlignment: Alignment.center,
                          ),
                          desc: "คุณต้องการยืนยันการเช็คอินร้านค้าใช่หรือไม่ ?",
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              color: Styles.failTextColor,
                              child: Text(
                                "store.processtimeline_screen.alert.cancel"
                                    .tr(),
                                style: Styles.white18(context),
                              ),
                            ),
                            DialogButton(
                              onPressed: () async {
                                await checkInStore();
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                              },
                              color: Styles.successButtonColor,
                              child: Text(
                                "store.processtimeline_screen.alert.submit"
                                    .tr(),
                                style: Styles.white18(context),
                              ),
                            )
                          ],
                        ).show();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Styles.primaryColor,
                        // padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('เช็คอิน', style: Styles.white24(context)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
