import 'dart:convert';
import 'dart:math';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/page/store/PolicyScreen.dart';
import 'package:_12sale_app/core/page/store/StoreAddressScreen.dart';
import 'package:_12sale_app/core/page/store/StoreDataScreen.dart';
import 'package:_12sale_app/core/page/store/VerifyStoreScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/core/utils/tost_util.dart';
import 'package:_12sale_app/data/models/DuplicateStore.dart';
import 'package:_12sale_app/data/models/Location.dart';
import 'package:_12sale_app/data/models/Route.dart';
import 'package:_12sale_app/data/models/Shoptype.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timelines/timelines.dart';
import 'package:toastification/toastification.dart';

const kTileHeight = 50.0;
const completeColor = Color(0xff5e6172);
const inProgressColor = Styles.primaryColor;
const todoColor = Color(0xffd1d2d7);

class ProcessTimelinePage extends StatefulWidget {
  User? userData;
  ProcessTimelinePage({required this.userData, super.key});

  @override
  State<ProcessTimelinePage> createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex = 0;
  bool isPolicy = false;
  late Store _storeData;
  late TextEditingController storeNameController;
  late TextEditingController storeTaxIDController;
  late TextEditingController storeTelController;
  late TextEditingController storeLineController;
  late TextEditingController storeNoteController;
  late TextEditingController storeAddressController;
  late TextEditingController storePoscodeController;
  RouteStore initialSelectedRoute = RouteStore(route: '');
  ShopType initialSelectedShoptype =
      ShopType(id: '', name: '', descript: '', status: '');
  List<dynamic> imageList = [];
  List<Store> duplicateStores = [];

  Location initialSelectedLocation = Location(
      id: '',
      amphoe: '',
      amphoeCode: '',
      district: '',
      districtCode: '',
      province: '',
      provinceCode: '');

  @override
  initState() {
    super.initState();
    _processIndex = 0;
    _clearStore();
    storeNameController = TextEditingController();
    storeTaxIDController = TextEditingController();
    storeTelController = TextEditingController();
    storeLineController = TextEditingController();
    storeNoteController = TextEditingController();
    storeAddressController = TextEditingController();
    storePoscodeController = TextEditingController();
  }

  @override
  void dispose() {
    storeNameController.dispose();
    storeTaxIDController.dispose();
    storeTelController.dispose();
    storeLineController.dispose();
    storeNoteController.dispose();
    storeAddressController.dispose();
    storePoscodeController.dispose();
    super.dispose();
  }

  Widget _getBodyContent() {
    switch (_processIndex) {
      case 0:
        return const PolicyScreen();
      case 1:
        return StoreDataScreen(
          storeData: _storeData,
          storeNameController: storeNameController,
          storeTaxIDController: storeTaxIDController,
          storeTelController: storeTelController,
          storeLineController: storeLineController,
          storeNoteController: storeNoteController,
          initialSelectedRoute: initialSelectedRoute,
          initialSelectedShoptype: initialSelectedShoptype,
          imageList: imageList,
        );
      case 2:
        return StoreAddressScreen(
          storeAddressController: storeAddressController,
          storePoscodeController: storePoscodeController,
          initialSelectedLocation: initialSelectedLocation,
        );
      case 3:
        return VerifyStoreScreen(
          storeData: _storeData,
        );
      default:
        return Center(child: Text("Unknown step"));
    }
  }

  Color getColor(int index) {
    if (index == _processIndex) {
      return inProgressColor;
    } else if (index < _processIndex) {
      return completeColor;
    } else {
      return todoColor;
    }
  }

  Future<void> _clearStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('add_store'); // Clear orders from SharedPreferences
    await prefs.remove('image_store'); // Clear orders from SharedPreferences
  }

  Future<void> _loadStoreFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the JSON string list from SharedPreferences
    String? jsonStore = prefs.getString("add_store");

    if (jsonStore != null) {
      setState(() {
        _storeData =
            // ignore: unnecessary_null_comparison
            (jsonStore == null ? null : Store.fromJson(jsonDecode(jsonStore)))!;
      });
      if (_storeData.policyConsent.status == 'Agree') {
        isPolicy = true;
      }
    }
  }

  Future<void> postData2() async {
    // Initialize Dio
    Dio dio = Dio();

    String text = '''
    {
    "name": "ครรรรรร",
    "taxId": null,
    "tel": 869655965,
    "route": "R04",
    "type": 31,
    "typeName": "ร้านหมูติดแอร์",
    "address": "รรรรคค",
    "district": "ซำสูง",
    "subDistrict": "บ้านโนน",
    "province": "ขอนแก่น",
    "provinceCode": 40,
    "postCode": 40170,
    "note": null,
    "shippingAddress": [
        {
            "default": 1,
            "address": "รรรรคค",
            "district": "ซำสูง",
            "subDistrict": "บ้านโนน",
            "province": "ขอนแก่น",
            "provinceCode": 40,
            "postCode": 40170,
            "latitude": 13.6823751,
            "longtitude": 100.6097463
        }
    ],
    "zone": "BE",
    "area": "BE211",
    "latitude": 13.6823751,
    "longtitude": 100.6097463,
    "lineId": null,
    "policyConsent": {
        "status": "Agree"
    },
    "approve": {
        "appPerson": null
    }
}''';

    String jsonData = '''
{
      "name": "${_storeData.name}",
      "taxId": "${_storeData.taxId}",
      "tel": "${_storeData.tel}",
      "route": "${_storeData.route}",
      "type": "${_storeData.type}",
      "typeName": "${_storeData.typeName}",
      "address": "${_storeData.address}",
      "district": "${_storeData.district}",
      "subDistrict": "${_storeData.subDistrict}",
      "province": "${_storeData.province}",
      "provinceCode": "${_storeData.postcode.substring(0, 2)}",
      "postCode": "${_storeData.postcode}",
      "note":"${_storeData.note}",
      "shippingAddress": [
        {
          "default": "1",
          "address": "${_storeData.address}",
          "district": "${_storeData.district}",
          "subDistrict": "${_storeData.subDistrict}",
          "province": "${_storeData.province}",
          "provinceCode": "${_storeData.postcode.substring(0, 2)}",
          "postCode": "${_storeData.postcode}",
          "latitude": "${_storeData.latitude}",
          "longtitude": "${_storeData.longitude}"
        }
      ],
      "zone": "${widget.userData?.zone}",
      "area": "${widget.userData?.area}",
      "latitude": "${_storeData.latitude}",
      "longtitude": "${_storeData.longitude}",
      "lineId": "${_storeData.lineId}",
      "policyConsent": {"status": "${_storeData.policyConsent.status}"},
      "approve": {"appPerson": ""}
}
''';
    // "approve": {"appPerson": ""} }
    try {
      // print(text);
      print(jsonData);

      var formData = FormData.fromMap({
        // 'storeImage': await MultipartFile.fromFile(imagePath),
        'storeImages': '',
        'types': "store,document",
        "store": jsonData
      });
      var response = await dio.post(
        'https://6505-171-103-242-50.ngrok-free.app/api/cash/store/addStore',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Image uploaded successfully ${response.data}");
        if (response.data['message'] == 'similar store') {
          final List<dynamic> data = response.data['data'];
          setState(() {
            duplicateStores = data
                .map((item) =>
                    Store.fromJson(item['store'] as Map<String, dynamic>))
                .toList();
          });
          showToastDuplicateMenu(
            stores: duplicateStores,
            context: context,
            icon: const Icon(Icons.info_outline),
            type: ToastificationType.error,
            primaryColor: Colors.red,
            titleStyle: Styles.headerRed24(context),
            descriptionStyle: Styles.red12(context),
            message: "store.processtimeline_screen.toasting_similar".tr(),
            description:
                "store.processtimeline_screen.toasting_similar_des".tr(),
          );
        } else if (response.data['message'] == 'Success') {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 5),
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: Text(
              "store.processtimeline_screen.toasting_success".tr(),
              style: Styles.black18(context),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(index: 2)),
          );
        }
      }
    } catch (e) {
      toastification.show(
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: Text(
          "store.processtimeline_screen.toasting_error".tr(),
          style: Styles.black18(context),
        ),
      );
      print("Error: ${e}");
    }
  }

  Future<void> postData() async {
    // Initialize Dio
    Dio dio = Dio();

    // Replace with your API endpoint
    const String apiUrl = "http://192.168.44.57:8000/api/cash/store/addStore";

    // JSON data
    Map<String, dynamic> jsonData = {
      "name": _storeData.name,
      "taxId": _storeData.taxId,
      "tel": _storeData.tel,
      "route": _storeData.route,
      "type": _storeData.type,
      "typeName": _storeData.typeName,
      "address": _storeData.address,
      "district": _storeData.district,
      "subDistrict": _storeData.subDistrict,
      "province": _storeData.province,
      "provinceCode": _storeData.postcode.substring(0, 2),
      "postCode": _storeData.postcode,
      "note": _storeData.note,
      "zone": widget.userData?.zone,
      "area": "BE214",
      "latitude": _storeData.latitude,
      "longtitude": _storeData.longitude,
      "lineId": _storeData.lineId,
      "policyConsent": {"status": _storeData.policyConsent.status},
      "imageList": _storeData.imageList,
    };

    try {
      // Send POST request
      final response = await dio.post(
        apiUrl,
        data: jsonData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['message'] == 'similar store') {
          final List<dynamic> data = response.data['data'];
          setState(() {
            duplicateStores = data
                .map((item) =>
                    Store.fromJson(item['store'] as Map<String, dynamic>))
                .toList();
          });
          showToastDuplicateMenu(
            stores: duplicateStores,
            context: context,
            icon: const Icon(Icons.info_outline),
            type: ToastificationType.error,
            primaryColor: Colors.red,
            titleStyle: Styles.headerRed24(context),
            descriptionStyle: Styles.red12(context),
            message: "store.processtimeline_screen.toasting_similar".tr(),
            description:
                "store.processtimeline_screen.toasting_similar_des".tr(),
          );
        } else if (response.data['message'] == 'Success') {
          toastification.show(
            autoCloseDuration: const Duration(seconds: 5),
            context: context,
            type: ToastificationType.success,
            style: ToastificationStyle.flatColored,
            title: Text(
              "store.processtimeline_screen.toasting_success".tr(),
              style: Styles.black18(context),
            ),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen(index: 2)),
          );
        }
      }
    } catch (e) {
      toastification.show(
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: Text(
          "store.processtimeline_screen.toasting_error".tr(),
          style: Styles.black18(context),
        ),
      );
      print("Error: ${e}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final _processes = [
      'store.processtimeline_screen.step1'.tr(),
      'store.processtimeline_screen.step2'.tr(),
      'store.processtimeline_screen.step3'.tr(),
      'store.processtimeline_screen.step4'.tr()
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    return ToastificationConfigProvider(
      config: const ToastificationConfig(
        // alignment: Alignment.center,
        itemWidth: 1000,
        // animationDuration: Duration(milliseconds: 500),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppbarCustom(
              title: " ${"store.processtimeline_screen.appbar".tr()}",
              icon: Icons.store_mall_directory_rounded),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Timeline.tileBuilder(
                  theme: TimelineThemeData(
                    direction: Axis.horizontal,
                    connectorTheme: const ConnectorThemeData(
                      space: 30.0,
                      thickness: 5.0,
                    ),
                  ),
                  builder: TimelineTileBuilder.connected(
                    connectionDirection: ConnectionDirection.before,
                    itemExtentBuilder: (_, __) =>
                        MediaQuery.of(context).size.width / 4.4,
                    oppositeContentsBuilder: (context, index) {
                      // Define a list of icons for each step
                      final List<IconData> stepIcons = [
                        Icons.handshake, // Icon for "Prospect"
                        Icons.store_mall_directory, // Icon for "Tour"
                        Icons.map, // Icon for "Offer"
                        Icons.check_circle_outlined, // Icon for "Contract"
                      ];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: GestureDetector(
                          onTap: () => setState(() => _processIndex = index),
                          child: Icon(
                            stepIcons[
                                index], // Use the icon corresponding to the current step
                            size: 30.0,
                            color: getColor(index),
                          ),
                        ),
                      );
                    },
                    contentsBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Text(
                          _processes[index],
                          style: Styles.black18(context),
                        ),
                      );
                    },
                    indicatorBuilder: (_, index) {
                      var color;
                      var child;
                      if (index == _processIndex) {
                        color = inProgressColor;
                        child = const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        );
                      } else if (index < _processIndex) {
                        color = completeColor;
                        child = GestureDetector(
                          onTap: () => setState(() => _processIndex = index),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15.0,
                          ),
                        );
                      } else {
                        color = todoColor;
                      }

                      if (index <= _processIndex) {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: Size(30.0, 30.0),
                              painter: _BezierPainter(
                                color: color,
                                drawStart: index > 0,
                                drawEnd: index < _processIndex,
                              ),
                            ),
                            DotIndicator(
                              size: 30.0,
                              color: color,
                              child: child,
                            ),
                          ],
                        );
                      } else {
                        return Stack(
                          children: [
                            CustomPaint(
                              size: const Size(15.0, 15.0),
                              painter: _BezierPainter(
                                color: color,
                                drawEnd: index < _processes.length - 1,
                              ),
                            ),
                            OutlinedDotIndicator(
                              borderWidth: 4.0,
                              color: color,
                            ),
                          ],
                        );
                      }
                    },
                    connectorBuilder: (_, index, type) {
                      if (index > 0) {
                        if (index == _processIndex) {
                          final prevColor = getColor(index - 1);
                          final color = getColor(index);
                          List<Color> gradientColors;
                          if (type == ConnectorType.start) {
                            gradientColors = [
                              Color.lerp(prevColor, color, 0.5)!,
                              color
                            ];
                          } else {
                            gradientColors = [
                              prevColor,
                              Color.lerp(prevColor, color, 0.5)!
                            ];
                          }
                          return DecoratedLineConnector(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: gradientColors,
                              ),
                            ),
                          );
                        } else {
                          return SolidLineConnector(
                            color: getColor(index),
                          );
                        }
                      } else {
                        return null;
                      }
                    },
                    itemCount: _processes.length,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Set background color if needed
                    borderRadius: BorderRadius.circular(
                        16), // Rounded corners for the outer container

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(0.2), // Shadow color with transparency
                        spreadRadius: 2, // Spread of the shadow
                        blurRadius: 8, // Blur radius of the shadow
                        offset: const Offset(0,
                            4), // Offset of the shadow (horizontal, vertical)
                      ),
                    ],
                  ),
                  // color: Colors.black,
                  child: _getBodyContent(),
                ), // Displays different content for each step
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                16), // Rounded corners for the outer container

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.2), // Shadow color with transparency
                                spreadRadius: 2, // Spread of the shadow
                                blurRadius: 8, // Blur radius of the shadow
                                offset: const Offset(0,
                                    4), // Offset of the shadow (horizontal, vertical)
                              ),
                            ],
                          ),
                          width: screenWidth / 2.2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_processIndex == 0) {
                              } else {
                                switch (_processIndex) {
                                  case 1:
                                    return () {
                                      // setState(() {
                                      //   _processIndex = (_processIndex - 1) %
                                      //       _processes.length;
                                      // });
                                    }();
                                  case 2:
                                    return () {
                                      _loadStoreFromStorage().then((_) {
                                        setState(() {
                                          initialSelectedRoute = RouteStore(
                                              route: _storeData.route);
                                          initialSelectedShoptype = ShopType(
                                              id: _storeData.type,
                                              name: _storeData.typeName,
                                              descript: '',
                                              status: '');
                                          imageList = _storeData.imageList;
                                        });
                                        setState(() {
                                          _processIndex = (_processIndex - 1) %
                                              _processes.length;
                                        });
                                      });
                                    }();
                                  case 3:
                                    return () {
                                      _loadStoreFromStorage().then((_) {
                                        setState(() {
                                          storeAddressController =
                                              TextEditingController(
                                                  text: _storeData.address);

                                          initialSelectedLocation = Location(
                                              province: _storeData.province,
                                              amphoe: _storeData.district,
                                              districtCode: '',
                                              zipcode: _storeData.postcode,
                                              provinceCode: _storeData.postcode
                                                  .substring(1, 3),
                                              id: '',
                                              amphoeCode: '',
                                              district: _storeData.subDistrict);

                                          _processIndex = (_processIndex - 1) %
                                              _processes.length;
                                        });
                                      });
                                    }();
                                  default:
                                    return print('error');
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.primaryColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth / 85,
                                  horizontal: screenWidth / 17),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                                "store.processtimeline_screen.back_button".tr(),
                                style: Styles.white18(context)),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                16), // Rounded corners for the outer container
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.2), // Shadow color with transparency
                                spreadRadius: 2, // Spread of the shadow
                                blurRadius: 8, // Blur radius of the shadow
                                offset: const Offset(0,
                                    4), // Offset of the shadow (horizontal, vertical)
                              ),
                            ],
                          ),
                          width: screenWidth / 2.2,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_processIndex == 3) {
                                print(
                                  "store.processtimeline_screen.alert.title"
                                      .tr(),
                                );
                                Alert(
                                  context: context,
                                  type: AlertType.info,
                                  title:
                                      "store.processtimeline_screen.alert.title"
                                          .tr(),
                                  style: AlertStyle(
                                    animationType: AnimationType.grow,
                                    isCloseButton: false,
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
                                  desc:
                                      "store.processtimeline_screen.alert.desc"
                                          .tr(),
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
                                      onPressed: () {
                                        postData2();
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
                              } else {}

                              switch (_processIndex) {
                                case 0:
                                  return () {
                                    _loadStoreFromStorage().then((_) {
                                      if (isPolicy == true) {
                                        setState(() {
                                          _processIndex = (_processIndex + 1) %
                                              _processes.length;
                                        });
                                      }
                                    });
                                  }();
                                case 1:
                                  return () {
                                    _loadStoreFromStorage().then((_) {
                                      // print(_storeData.name);
                                      // print(_storeData.taxId);
                                      // print(_storeData.typeName);
                                      print(_storeData.imageList);
                                      // Create a list to hold missing fields
                                      List<String> missingFields = [];

                                      // Check for missing fields
                                      if (_storeData.name.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.name"
                                                .tr());
                                      }
                                      if (_storeData.tel.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.phone"
                                                .tr());
                                      }
                                      if (_storeData.typeName.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.store_type"
                                                .tr());
                                      }
                                      if (_storeData.route.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.route"
                                                .tr());
                                      }

                                      // If there are missing fields, show the toast
                                      if (missingFields.isNotEmpty) {
                                        showToast(
                                          context: context,
                                          message:
                                              '${"store.processtimeline_screen.toasting.message".tr()} ${missingFields.join(', ')}',
                                          type: ToastificationType.error,
                                          primaryColor: Colors.red,
                                        );
                                      }
                                      if (_storeData.imageList.isEmpty) {
                                        showToast(
                                          context: context,
                                          message:
                                              "${"store.processtimeline_screen.toasting.image".tr()}",
                                          type: ToastificationType.error,
                                          primaryColor: Colors.red,
                                        );
                                      }

                                      // _processIndex = (_processIndex + 1) %
                                      //     _processes.length;

                                      setState(() {
                                        initialSelectedRoute =
                                            RouteStore(route: _storeData.route);
                                        initialSelectedShoptype = ShopType(
                                            id: _storeData.type,
                                            name: _storeData.typeName,
                                            descript: '',
                                            status: '');

                                        if (_storeData.name != "" &&
                                            _storeData.typeName != "" &&
                                            _storeData.tel != "" &&
                                            _storeData.route != "" &&
                                            _storeData.imageList.isNotEmpty) {
                                          _processIndex = (_processIndex + 1) %
                                              _processes.length;
                                        }
                                      });
                                    });
                                  }();
                                case 2:
                                  return () {
                                    _loadStoreFromStorage().then((_) {
                                      List<String> missingFields = [];

                                      // Check for missing fields
                                      if (_storeData.address.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.address"
                                                .tr());
                                      }
                                      if (_storeData.province.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.province"
                                                .tr());
                                      }
                                      if (_storeData.district.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.district"
                                                .tr());
                                      }
                                      if (_storeData.subDistrict.isEmpty) {
                                        missingFields.add(
                                            "store.processtimeline_screen.toasting.sub_district"
                                                .tr());
                                      }

                                      // If there are missing fields, show the toast
                                      if (missingFields.isNotEmpty) {
                                        showToast(
                                          context: context,
                                          message:
                                              '${"store.processtimeline_screen.toasting.message_selected".tr()} ${missingFields.join(', ')}',
                                          type: ToastificationType.error,
                                          primaryColor: Colors.red,
                                        );
                                      }
                                      print(_storeData.address);
                                      print(_storeData.province);
                                      print(_storeData.district);
                                      print(_storeData.subDistrict);

                                      if (_storeData.address != "" &&
                                          _storeData.province != "" &&
                                          _storeData.district != "" &&
                                          _storeData.subDistrict != "") {
                                        _processIndex = (_processIndex + 1) %
                                            _processes.length;
                                      }
                                    });
                                  }();
                                case 3:
                                  return () {
                                    _loadStoreFromStorage().then((_) {});
                                    // postData();
                                  }();
                                default:
                                  return print('error');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Styles.successButtonColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: screenWidth / 80,
                                  horizontal: screenWidth / 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                                _processIndex == 3
                                    ? "store.processtimeline_screen.submit_button"
                                        .tr()
                                    : "store.processtimeline_screen.next_button"
                                        .tr(),
                                style: Styles.white18(context)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// hardcoded bezier painter
/// TODO: Bezier curve into package component
class _BezierPainter extends CustomPainter {
  const _BezierPainter({
    required this.color,
    this.drawStart = true,
    this.drawEnd = true,
  });

  final Color color;
  final bool drawStart;
  final bool drawEnd;

  Offset _offset(double radius, double angle) {
    return Offset(
      radius * cos(angle) + radius,
      radius * sin(angle) + radius,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;

    final radius = size.width / 2;

    var angle;
    var offset1;
    var offset2;

    var path;

    if (drawStart) {
      angle = 3 * pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);
      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(0.0, size.height / 2, -radius,
            radius) // TODO connector start & gradient
        ..quadraticBezierTo(0.0, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
    if (drawEnd) {
      angle = -pi / 4;
      offset1 = _offset(radius, angle);
      offset2 = _offset(radius, -angle);

      path = Path()
        ..moveTo(offset1.dx, offset1.dy)
        ..quadraticBezierTo(size.width, size.height / 2, size.width + radius,
            radius) // TODO connector end & gradient
        ..quadraticBezierTo(size.width, size.height / 2, offset2.dx, offset2.dy)
        ..close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_BezierPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.drawStart != drawStart ||
        oldDelegate.drawEnd != drawEnd;
  }
}
