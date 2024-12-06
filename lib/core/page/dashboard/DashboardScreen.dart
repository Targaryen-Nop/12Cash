import 'dart:convert';

import 'package:_12sale_app/core/components/CalendarPicker.dart';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
import 'package:_12sale_app/core/components/button/MenuButton.dart';
import 'package:_12sale_app/core/components/card/WeightCude.dart';
import 'package:_12sale_app/core/components/chart/BarChart.dart';
import 'package:_12sale_app/core/components/chart/LineChart.dart';
import 'package:_12sale_app/core/components/chart/TrendingMusicChart.dart';
import 'package:_12sale_app/core/page/NotificationScreen.dart';
import 'package:_12sale_app/core/page/Ractangle3D.dart';
import 'package:_12sale_app/core/page/printer/PrinterScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Customer.dart';
import 'package:_12sale_app/data/models/Shipping.dart';
import 'package:_12sale_app/data/models/User.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:_12sale_app/data/service/locationService.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:_12sale_app/core/utils/json_loader.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  Timer? _locationTimer;

  @override
  void initState() {
    super.initState();
    LocationService().initialize();
    // startLocationUpdates();
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
    _locationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentLocation(); // Call your currentLocation function every 5 seconds
    });
  }

  List<CustomerModel> customerList = [];
  List<ShippingModel> shuppingList = [];

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // someFunction();
    return Container(
        padding: const EdgeInsets.all(10.0),
        // height: screenWidth / 2.5,
        // width: screenWidth / 1.5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MenuButton(
                  color: Styles.successButtonColor,
                  icon: Icons.notifications_active_outlined,
                  label: "Local Noti",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => NotificationScreen()),
                    );
                  },
                ),
                MenuButton(
                  color: Colors.black,
                  icon: Icons.print,
                  label: "BL Printer",
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => BluetoothPrinterScreen4()),
                    );
                  },
                ),
              ],
            ),
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

            Container(height: 500, width: 400, child: LineChartSample()),
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

  List<DataRow> _buildRows() {
    final List<Map<String, dynamic>> data = [
      {
        'day': 'Day 01',
        'path': '1',
        'status': '5/5',
        'statusColor': Colors.green
      },
      {
        'day': 'Day 02',
        'path': '2',
        'status': '6/6',
        'statusColor': Colors.green
      },
      {
        'day': 'Day 03',
        'path': '4',
        'status': '0/9',
        'statusColor': Colors.red
      },
      {
        'day': 'Day 04',
        'path': '5',
        'status': '11/16',
        'statusColor': Colors.blue
      },
      {
        'day': 'Day 05',
        'path': '6',
        'status': '2/9',
        'statusColor': Colors.blue
      },
      {
        'day': 'Day 06',
        'path': '7',
        'status': '9/9',
        'statusColor': Colors.green
      },
    ];

    return data.map((item) {
      bool isEvenRow = data.indexOf(item) % 2 == 0;
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return isEvenRow
                ? Colors.grey[100]
                : Colors.white; // Alternate row color
          },
        ),
        cells: [
          DataCell(Text(item['day'],
              style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(Text(item['path'])),
          DataCell(_buildStatusBadge(item['status'], item['statusColor'])),
        ],
      );
    }).toList();
  }

  List<DataRow> _buildRows2() {
    final List<Map<String, dynamic>> data = [
      {
        'day': 'Day 01',
        'path': '1',
        'status': '5/5',
        'statusColor': Colors.green
      },
      {
        'day': 'Day 02',
        'path': '2',
        'status': '6/6',
        'statusColor': Colors.green
      },
      {
        'day': 'Day 03',
        'path': '4',
        'status': '0/9',
        'statusColor': Colors.red
      },
    ];

    return data.map((item) {
      bool isEvenRow = data.indexOf(item) % 2 == 0;
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return isEvenRow
                ? Colors.grey[100]
                : Colors.white; // Alternate row color
          },
        ),
        cells: [
          DataCell(Text(item['day'],
              style: const TextStyle(fontWeight: FontWeight.bold))),
          DataCell(
            Align(
              alignment: Alignment.center,
              child: Text(item['path']),
            ),
          ),
          DataCell(_buildStatusBadge(item['status'], item['statusColor'])),
          DataCell(_buildStatusBadge(item['status'], item['statusColor'])),
        ],
      );
    }).toList();
  }

  Widget _buildStatusBadge(String status, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2), // Light background color
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),

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
                child: Center(
                  // margin: EdgeInsets.only(top: 10),
                  child: Column(
                    // mainAxisSize: MainAxisSize.,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          // color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                              Row(
                                children: [
                                  Text(
                                      DateFormat(' d MMMM yyyy').format(DateTime
                                          .now()), // Current date and time
                                      style: Styles.white18(context)),
                                  StreamBuilder(
                                    stream: Stream.periodic(
                                        const Duration(seconds: 1)),
                                    builder: (context, snapshot) {
                                      return Text(
                                          DateFormat(' HH:mm:ss')
                                              .format(DateTime.now()),
                                          style: Styles.white18(context));
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceAround,
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
                                        style: Styles.headerBlack18(context),
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
                                        style: Styles.headerBlack18(context),
                                      ),
                                    ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
