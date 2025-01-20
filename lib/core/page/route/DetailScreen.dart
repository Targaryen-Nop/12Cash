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
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/data/models/User.dart';
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
  final String route;
  final String routeId;
  final String customerName;
  final String address;
  String status;

  DetailScreen(
      {super.key,
      required this.customerNo,
      required this.route,
      required this.routeId,
      required this.customerName,
      required this.address,
      required this.status});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String? checkinImagePath; // Path to store the captured image
  String selectedCause = 'เลือกเหตุผล';
  String latitude = '00.00';
  String longitude = '00.00';
  Store? store;
  List<Store> storeAll = [];
  bool _loadingAllStore = true;
  double completionPercentage = 220;
  final LocationService locationService = LocationService();
  TextEditingController noteController = TextEditingController();
  late int status;

  // String

  @override
  void initState() {
    super.initState();
    _getStoreDataAll();
    status = int.tryParse(widget.status) ?? 0; // Default to 0 if parsing fails
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

  Future<void> checkIn() async {
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
            'routeId': widget.routeId,
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
          '${ApiService.apiHost}/api/cash/route/checkIn',
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
            // widget.status = '2';
            status = 2;
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

  Future<void> _getStoreDataAll() async {
    try {
      print("routeId ${widget.routeId}");

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${"route.detail_screen.title".tr()}', icon: Icons.event),
      ),
      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.all(16.0),
      //   decoration: const BoxDecoration(
      //     color: Styles.primaryColor, // Primary color of the navigation bar
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(16),
      //       topRight: Radius.circular(16),
      //     ),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black26, // Shadow color
      //         blurRadius: 10, // Soft blur effect
      //         spreadRadius: 2, // Spread of the shadow
      //         offset: Offset(0, -3), // Shadow positioned upwards
      //       ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         BoxShadowCustom(
      //           child: MenuButton(
      //             icon: Icons.store_rounded,
      //             label: "เช็คอิน",
      //             color: status > 0 ? Colors.grey : Styles.primaryColor,
      //             onPressed: () {
      //               _showCheckInSheet(context);
      //               setState(() {
      //                 selectedCause = "เลือกสาเหตุ";
      //               });
      //             },
      //           ),
      //         ),
      //         BoxShadowCustom(
      //           child: MenuButton(
      //             icon: Icons.add_shopping_cart_rounded,
      //             label: "route.detail_screen.order_button".tr(),
      //             // color: Colors.teal,
      //             color: status > 0 ? Colors.grey : Styles.successTextColor,
      //             onPressed: () {
      //               Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => Orderscreen(
      //                       customerNo: widget.customerNo,
      //                       customerName: widget.customerName,
      //                       status: widget.status),
      //                 ),
      //               );
      //             },
      //           ),
      //         ),
      //         // BoxShadowCustom(
      //         //   child: MenuButton(
      //         //     icon: Icons.add_a_photo,
      //         //     label: "route.detail_screen.camera.title".tr(),
      //         //     color: Styles.primaryColor,
      //         //     // color: Colors.grey,
      //         //     onPressed: () {
      //         //       _showBottomCamera(context);
      //         //     },
      //         //   ),
      //         // ),
      //         // BoxShadowCustom(
      //         //   child: MenuButton(
      //         //     icon: Icons.transfer_within_a_station_sharp,
      //         //     label: "route.detail_screen.credit_note_button".tr(),
      //         //     // color: const Color.fromARGB(255, 234, 175, 0),
      //         //     color: Styles.accentColor,
      //         //     onPressed: () {
      //         //       Navigator.push(
      //         //         context,
      //         //         MaterialPageRoute(
      //         //           builder: (context) => Orderscreen(
      //         //               customerNo: widget.customerNo,
      //         //               customerName: widget.customerName,
      //         //               status: widget.status),
      //         //         ),
      //         //       );
      //         //     },
      //         //   ),
      //         // ),
      //       ],
      //     ),
      //   ),
      // ),
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
                // Text('ข้อมูลร้านค้า ${widget.customerName}',
                //     style: Styles.black24(context)),
                // BoxShadowCustom(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Expanded(
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text(
                //                   "${'route.detail_screen.store_name'.tr()} : ${widget.customerName}",
                //                   style: Styles.black18(context)),
                //               Text(
                //                   '${'route.detail_screen.store_id'.tr()} : ${widget.customerNo}',
                //                   style: Styles.black18(context)),
                //               Text('รูท : R${widget.route}',
                //                   style: Styles.black18(context)),
                //               Text(
                //                   'สถานะ : ${widget.status == '2' ? 'เช็คอินแล้ว' : 'ยังไม่ได้เช็คอิน'}',
                //                   style: Styles.black18(context)),
                //             ],
                //           ),
                //         ),
                //         Expanded(
                //           child: Text(
                //             "${'route.detail_screen.store_address'.tr()} : ${widget.address}",
                //             style: Styles.black18(context),
                //             textAlign: TextAlign.end,
                //             // overflow: TextOverflow.ellipsis,
                //             // textDirection: TextDirection.,
                //             // textAlign: TextAlign.end,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),

                SizedBox(height: screenWidth / 37),
                Text('รายการสั่งซื้อ', style: Styles.black24(context)),
                Container(
                  height: 300,
                  child: LoadingSkeletonizer(
                    loading: _loadingAllStore,
                    child: BoxShadowCustom(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                ),
                SizedBox(height: screenWidth / 37),
                // Text('ข้อมูลร้านค้า ${widget.customerName}',
                //     style: Styles.black24(context)),
                BoxShadowCustom(
                  color: Styles.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${widget.customerName}",
                                      style: Styles.white24(context)),
                                  Text(
                                      '${'route.detail_screen.store_id'.tr()} : ${widget.customerNo}',
                                      style: Styles.white18(context)),
                                  Text('รูท : R${widget.route}',
                                      style: Styles.white18(context)),
                                  Text(
                                      'สถานะ : ${widget.status == '2' ? 'เช็คอินแล้ว' : 'ยังไม่ได้เช็คอิน'}',
                                      style: Styles.white18(context)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "${'route.detail_screen.store_address'.tr()} : ${widget.address}",
                                style: Styles.white18(context),
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
                              color:
                                  status > 0 ? Colors.grey : Styles.bluePastel,
                              onPressed: () {
                                _showCheckInSheet(context);
                                setState(() {
                                  selectedCause = "เลือกสาเหตุ";
                                });
                              },
                            ),
                            MenuButton(
                              icon: Icons.add_shopping_cart_rounded,
                              label: "route.detail_screen.order_button".tr(),
                              // color: Colors.teal,
                              color:
                                  status > 0 ? Colors.grey : Styles.greenPastel,
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenWidth / 37),
              ],
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
                    '${widget.customerName}',
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
                      print("Route ID : ${widget.routeId}");
                      print("Route ID : ${widget.route}");
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
                                await checkIn();
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
