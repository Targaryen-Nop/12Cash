import 'dart:convert';
import 'package:_12sale_app/components/button/Button.dart';
import 'package:_12sale_app/components/Dropdown.dart';
import 'package:_12sale_app/components/CustomerDropdownSearch.dart';
import 'package:_12sale_app/components/ShippingDropdownSearch.dart';
import 'package:_12sale_app/components/Table.dart';
import 'package:_12sale_app/components/chart/BarChart.dart';
import 'package:_12sale_app/components/chart/LineChart.dart';
import 'package:_12sale_app/components/chart/TrendingMusicChart.dart';
import 'package:_12sale_app/models/Customer.dart';
import 'package:_12sale_app/models/Shipping.dart';
import 'package:_12sale_app/models/example.dart';
import 'package:_12sale_app/service/getCustomer.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:_12sale_app/service/locationService.dart';
import 'package:geolocator/geolocator.dart';
import 'package:_12sale_app/models/User.dart';
import 'dart:async';
import 'package:_12sale_app/service/getCustomer.dart';

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
  CustomerModel? _selectedCustomer;
  ShippingModel? _selectedShipping;

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // someFunction();
    return Container(
        padding: const EdgeInsets.all(10.0),
        height: screenWidth / 2.5,
        width: screenWidth / 1.5,
        child: Column(
          children: [
            ShippingDropdownSearch(),
            SizedBox(height: screenWidth / 25),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                // fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  // height: screenWidth / 3,
                  // color: Colors.red,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/12TradingLogo.png'),
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                // fit: FlexFit.tight,
                child: Center(
                  // margin: EdgeInsets.only(top: 10),

                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: screenWidth / 40),
                      Container(
                        height: screenWidth / 20,
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        // color: Colors.blue,
                        child: Row(
                          children: [
                            Text(
                              'นายนพรัตน์ มั่นสุวรรณ ',
                              style: GobalStyles.headline3,
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      // Flexible(
                      //   fit: FlexFit.loose,
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         // color: Colors.green,
                      //         margin: EdgeInsets.symmetric(horizontal: 4),
                      //         child: RichText(
                      //           text: TextSpan(
                      //             text: DateTime.now().day.toString(),
                      //             style: GobalStyles.headline3,
                      //             children: [
                      //               TextSpan(
                      //                 text: DateFormat(' MMMM yyyy')
                      //                     .format(DateTime.now()),
                      //                 style: GobalStyles.headline3,
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       Flexible(
                      //         fit: FlexFit.loose,
                      //         child: StreamBuilder(
                      //           stream:
                      //               Stream.periodic(const Duration(seconds: 1)),
                      //           builder: (context, snapshot) {
                      //             return Container(
                      //               // color: Colors.green,
                      //               alignment: Alignment.centerLeft,
                      //               child: Text(
                      //                 DateFormat('hh:mm:ss a')
                      //                     .format(DateTime.now()),
                      //                 style: GobalStyles.headline3,
                      //               ),
                      //             );
                      //           },
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 5),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Container(
                          // color: Colors.amber,
                          height: screenWidth / 20,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.,
                            textBaseline: TextBaseline.alphabetic,
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: screenWidth / 10,
                                // margin: EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                    color: GobalStyles.secondaryColor,
                                    borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(50),
                                        left: Radius.circular(50))),

                                child: Center(
                                    child: Text(
                                  'SALE',
                                  style: GobalStyles.headlineblack4,
                                )),
                              ),
                              Container(
                                width: screenWidth / 10,
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                decoration: const BoxDecoration(
                                    color: GobalStyles.secondaryColor,
                                    borderRadius: BorderRadius.horizontal(
                                        right: Radius.circular(50),
                                        left: Radius.circular(50))),
                                child: Center(
                                    child: Text(
                                  'BE121',
                                  style: GobalStyles.headlineblack4,
                                )),
                              ),
                              Expanded(
                                child: Container(
                                  // color:
                                  //     Colors.orangeAccent, // Background color
                                  // height: 50, // Fixed height
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                            DateFormat('d MMMM yyyy').format(
                                                DateTime
                                                    .now()), // Current date and time
                                            style: GobalStyles.articalwhite),
                                        StreamBuilder(
                                          stream: Stream.periodic(
                                              const Duration(seconds: 1)),
                                          builder: (context, snapshot) {
                                            return Container(
                                              // color: Colors.green,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  DateFormat(' hh:mm:ss a')
                                                      .format(DateTime.now()),
                                                  style:
                                                      GobalStyles.articalwhite),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
