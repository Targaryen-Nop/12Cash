import 'dart:convert';
import 'dart:math';

import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/CalendarPicker.dart';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
import 'package:_12sale_app/core/components/button/MenuButton.dart';
import 'package:_12sale_app/core/components/card/MenuDashboard.dart';
import 'package:_12sale_app/core/components/card/WeightCude.dart';
import 'package:_12sale_app/core/components/chart/BarChart.dart';
import 'package:_12sale_app/core/components/chart/LineChart.dart';
import 'package:_12sale_app/core/components/chart/TrendingMusicChart.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/page/NotificationScreen.dart';
import 'package:_12sale_app/core/page/Ractangle3D.dart';
import 'package:_12sale_app/core/page/printer/PrinterScreen.dart';
import 'package:_12sale_app/core/page/setting/SettingScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Customer.dart';
import 'package:_12sale_app/data/models/Shipping.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:_12sale_app/data/service/locationService.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  Timer? _locationTimer;
  late Map<String, String> languages = {};
  String? selectedLanguageCode;

  @override
  void initState() {
    super.initState();
    LocationService().initialize();
    _loadData();
  }

  Future<void> _loadData() async {
    final String jsonString =
        await rootBundle.loadString('assets/locales/languages.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      languages = Map<String, String>.from(jsonData);
    });
  }

  @override
  void dispose() {
    _locationTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void currentLocation() async {
    try {
      Position position = await getCurrentLocation();
      print('Current location: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error: $e');
    }
  }

  void startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentLocation(); // Call your currentLocation function every 5 seconds
    });
  }

  List<CustomerModel> customerList = [];
  List<ShippingModel> shuppingList = [];

  Widget build(BuildContext context) {
    selectedLanguageCode = context.locale.toString().split("_")[0];
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.all(10.0),
        // height: screenWidth / 2.5,
        // width: screenWidth / 1.5,
        child: Column(
          children: [
            SizedBox(height: 350, width: screenWidth, child: LineChartSample()),
            CarouselSlider(
              items: [
                MenuDashboard(
                  title_1: "dashboard.menu.sale_report".tr(),
                  icon_1: Icons.description,
                  title_2: "dashboard.menu.data_analysis".tr(),
                  icon_2: Icons.equalizer,
                  title_3: "dashboard.menu.setting".tr(),
                  icon_3: Icons.settings,
                  onTap3: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()),
                    );
                  },
                  title_4: "dashboard.menu.campaign".tr(),
                  icon_4: Icons.campaign_rounded,
                  title_5: "dashboard.menu.history".tr(),
                  icon_5: Icons.history,
                  title_6: "dashboard.menu.schedule".tr(),
                  icon_6: Icons.schedule,
                ),
                MenuDashboard(
                  title_1: "dashboard.menu.logistic".tr(),
                  icon_1: Icons.local_shipping,
                  title_2: "dashboard.menu.send_money".tr(),
                  icon_2: Icons.payments,
                  title_3: "dashboard.menu.mall".tr(),
                  icon_3: Icons.shopping_bag,
                  title_4: "dashboard.menu.credit_limit".tr(),
                  icon_4: Icons.credit_card,
                  title_5: "dashboard.menu.warehouse".tr(),
                  icon_5: Icons.warehouse,
                  title_6: "dashboard.menu.more".tr(),
                  icon_6: Icons.more_horiz,
                ),
              ],
              options: CarouselOptions(
                // autoPlay: true,
                disableCenter: true,
                enlargeCenterPage: true,
                viewportFraction: 1.0, // Show one row fully at a time
              ),
            ),
            // MenuDashboard(
            //   title_1: "dashboard.menu.sale_report".tr(),
            //   icon_1: Icons.description,
            //   title_2: "dashboard.menu.data_analysis".tr(),
            //   icon_2: Icons.equalizer,
            //   title_3: "dashboard.menu.setting".tr(),
            //   icon_3: Icons.settings,
            //   title_4: "dashboard.menu.campaign".tr(),
            //   icon_4: Icons.campaign_rounded,
            //   title_5: "dashboard.menu.history".tr(),
            //   icon_5: Icons.history,
            //   title_6: "dashboard.menu.schedule".tr(),
            //   icon_6: Icons.schedule,
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     MenuButton(
            //       color: Styles.successButtonColor,
            //       icon: Icons.notifications_active_outlined,
            //       label: "Local Noti",
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //               builder: (context) => NotificationScreen()),
            //         );
            //       },
            //     ),
            //     DropdownButton<String>(
            //       icon: const Icon(
            //         Icons.chevron_left,
            //       ),
            //       // isExpanded: true,
            //       value: selectedLanguageCode,
            //       hint: Text(
            //         'เลือกภาษา',
            //         style: Styles.black18(context),
            //       ),
            //       items: languages.entries
            //           .map(
            //             (entry) => DropdownMenuItem<String>(
            //               value: entry.key,
            //               child: Text(
            //                 entry.value,
            //                 style: Styles.black18(context),
            //               ),
            //               // Display language name
            //             ),
            //           )
            //           .toList(),
            //       onChanged: (value) async {
            //         switch (value) {
            //           case "en":
            //             await context.setLocale(const Locale('en', 'US'));
            //             break;
            //           case "th":
            //             await context.setLocale(const Locale('th', 'TH'));
            //             break;
            //           default:
            //         }
            //         //  log(locale.toString(), name: toString());
            //         Navigator.pushReplacement(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => const HomeScreen(
            //                     index: 0,
            //                   )),
            //         );
            //         print(context.locale.toString().split("_")[0]);
            //         setState(() {
            //           selectedLanguageCode = value;
            //         });
            //       },
            //     ),
            //     MenuButton(
            //       color: Styles.successButtonColor,
            //       icon: Icons.settings,
            //       label: "Setting",
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(builder: (context) => SettingScreen()),
            //         );
            //       },
            //     ),
            //     MenuButton(
            //       color: Colors.black,
            //       icon: Icons.print,
            //       label: "BL Printer",
            //       onPressed: () {
            //         Navigator.of(context).push(
            //           MaterialPageRoute(
            //               builder: (context) => BluetoothPrinterScreen4()),
            //         );
            //       },
            //     ),
            //   ],
            // ),
            SizedBox(height: screenWidth / 25),
            const WeightCudeCard(),
            // SizedBox(height: screenWidth / 25),
            // SizedBox(height: 500, width: 400, child: LineChartSample()),
            SizedBox(height: screenWidth / 25),
            CalendarPicker(
              label: "Select Date",
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateSelected: (selectedDate) {
                // Perform any action with the selected date
                debugPrint("Selected Date: $selectedDate");
              },
            ),
            SizedBox(height: screenWidth / 25),

            // Container(height: 500, width: 400, child: LineChartSample()),
            Expanded(
                child: Container(
                    height: 500, width: 500, child: TrendingMusicChart())),
            // Container(height: 500, width: 300, child: LineChartSample())
            // CameraButtonWidget()
            // ShippingDropdownSearch(),
            // SizedBox(height: screenWidth / 25),

            // CameraButtonWidget(
            //   buttonText: 'Open Camera',
            //   buttonColor: Colors.blue,
            //   textStyle: TextStyle(color: Colors.white, fontSize: 18),
            // )
            // CustomTable(data: _buildRows(), columns: [
            //   DataColumn(label: Text('วันที่')), // "Date" in Thai
            //   DataColumn(label: Text('เส้นทาง')), // "Path" in Thai
            //   DataColumn(label: Text('สถานะ')), // "Status" in Thai
            // ]),
          ],
        )
        // CustomTable(
        //   data: _buildRows(),
        //     // )
        //     Row(
        //   crossAxisAlignment: CrossAxisAlignment.stretch,
        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //   children: [DropdownSearchWidget()],
        // ),
        );

    //   // SizedBox(width: 10),
    //   CustomTable(data: _buildRows2(), columns: [
    //     DataColumn(label: Text('วันที่')), // "Date" in Thai
    //     DataColumn(label: Text('เส้นทาง')), // "Path" in Thai
    //     DataColumn(label: Text('สถานะ')), // "Status" in Thai
    //     DataColumn(label: Text('adw')), // "Status" in Thai
    //   ])
    // return Container(height: 500, width: 400, child: LineChartSample());
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Light background color
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DashboardHeader extends StatefulWidget {
  const DashboardHeader({super.key});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  late User _userData = User(
      saleCode: "",
      salePayer: "",
      userName: "",
      firstName: "",
      surName: "",
      passWord: "",
      tel: "",
      zone: "",
      area: "",
      warehouse: "",
      role: "",
      status: "");

  @override
  void initState() {
    super.initState();
    _loadStoreFromStorage();
  }

  Future<void> _loadStoreFromStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonStore = prefs.getString("user");

      if (jsonStore != null) {
        setState(() {
          _userData = (jsonStore == null
              ? null
              : User.fromJson(jsonDecode(jsonStore)))!;
        });
        // province = _storeData.province!;
      }
    } catch (e) {
      print("Error loading from storage: $e");
    }
  }
  // Function to load JSON using the reusable global function

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.loose,
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 4),
                  // color: Colors.red,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/12TradingLogo.png'),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                fit: FlexFit.loose,
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        // color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${_userData.firstName} ${_userData.surName}',
                                  style: Styles.headerWhite24(context),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                      DateFormat('d MMMM yyyy',
                                              'dashboard.lange'.tr())
                                          .format(DateTime
                                              .now()), // Current date and time
                                      style: Styles.headerWhite24(context)),
                                  StreamBuilder(
                                    stream: Stream.periodic(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return Text(
                                          ' ${'dashboard.time'.tr()}:${DateFormat('HH:mm:ss').format(DateTime.now())}',
                                          style: Styles.headerWhite24(context));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: screenWidth / 6,
                                    // margin: EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Styles.secondaryColor,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(50),
                                            left: Radius.circular(50))),

                                    child: Center(
                                      child: Text(
                                        '${_userData.role.toUpperCase()}',
                                        style: Styles.headerBlack24(context),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth / 6,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: const BoxDecoration(
                                        color: Styles.secondaryColor,
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular(50),
                                            left: Radius.circular(50))),
                                    child: Center(
                                      child: Text(
                                        '${_userData.area}',
                                        style: Styles.headerBlack24(context),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
