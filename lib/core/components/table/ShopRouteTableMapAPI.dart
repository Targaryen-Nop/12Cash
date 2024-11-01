import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Customer.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';
import 'package:flutter/material.dart';
import 'package:_12sale_app/core/page/route/DetailScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopRouteTable extends StatefulWidget {
  final String day;
  const ShopRouteTable({
    super.key,
    required this.day,
  });

  @override
  State<ShopRouteTable> createState() => _ShopRouteTableState();
}

class _ShopRouteTableState extends State<ShopRouteTable> {
  List<CustomerModel> customers = []; // Holds the list of CustomerModel objects
  bool isLoading = true; // Loader state
  Map<String, dynamic>? _jsonString;

  @override
  void initState() {
    super.initState();
    fetchCustomers(); // Fetch customers on widget load
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["shop_route_table"];
    });
  }

  // Fetch data from the API
  void fetchCustomers() async {
    var data = await getCustomers();
    setState(() {
      customers = data;
      isLoading = false; // Set loading state to false when data is fetched
    });
  }

  Future<List<CustomerModel>> getCustomers() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init(); // Load .env before making any API calls
      var response = await apiService.request(
        endpoint:
            'erp/customer/top100', // You only need to pass the endpoint, the base URL is handled
        method: 'POST',
        // body: {
        //   "customerNo": "VB20700031",
        // },
      );

      // var response = await apiService.requestMongoDB(
      //   endpoint:
      //       'visits', // You only need to pass the endpoint, the base URL is handled
      //   // method: 'POST',
      //   // body: {
      //   //   "customerNo": "VB20700031",
      //   // },
      // );
      print("ApiService: $response}");

      // // Checking if data is not null and returning the list of CustomerModel
      if (response != null) {
        return CustomerModel.fromJsonList(response);
      }
      return [];
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: isLoading
          ? const CircularProgressIndicator() // Show loader while fetching data
          : Container(
              margin: EdgeInsets.all(
                  screenWidth / 50), // Adds space around the table
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fixed header
                  Container(
                    decoration: const BoxDecoration(
                      color: GobalStyles.backgroundTableColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: _buildHeaderCell(
                                _jsonString?['customer_no'] ?? 'Customer No')),
                        Expanded(
                            flex: 3,
                            child: _buildHeaderCell(
                                _jsonString?['customer_name'] ??
                                    'Customer Name')),
                        Expanded(
                            flex: 1,
                            child: _buildHeaderCellStatus(
                                _jsonString?['status'] ?? 'Status')),
                      ],
                    ),
                  ),
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: customers
                            .asMap()
                            .entries
                            .map(
                              (entry) => _buildDataRow(
                                entry.value.customerNo,
                                entry.value.customerName,
                                entry.value.OKECAR,
                                GobalStyles
                                    .successBackgroundColor, // Set your colors accordingly
                                GobalStyles.successTextColor,
                                entry.key, // Row index
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDataRow(String customerNo, String customerName, String status,
      Color? bgColor, Color? textColor, int index) {
    Color rowBgColor =
        (index % 2 == 0) ? Colors.white : GobalStyles.backgroundTableColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              day: widget.day,
              customerNo: customerNo,
              customerName: customerName,
              status: status,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(color: rowBgColor),
        child: Row(
          children: [
            Expanded(flex: 2, child: _buildTableCell(customerNo)),
            Expanded(flex: 3, child: _buildTableCell(customerName)),
            Expanded(
                flex: 1, child: _buildStatusCell(status, bgColor, textColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status, Color? bgColor, Color? textColor) {
    return Container(
      alignment: Alignment.center,
      child: Container(
        width: 100, // Optional inner width for the status cell
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: GoogleFonts.kanit(color: textColor, fontSize: 24),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      child: Text(text, style: Styles.black18),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Styles.grey18,
      ),
    );
  }

  Widget _buildHeaderCellStatus(String text) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Styles.grey18,
      ),
    );
  }
}
