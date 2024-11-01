// ignore: file_names
import 'dart:convert';
import 'package:_12sale_app/core/page/route/ShopRouteScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteTable extends StatefulWidget {
  const RouteTable({super.key});

  @override
  State<RouteTable> createState() => _RouteTableState();
}

class _RouteTableState extends State<RouteTable> {
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["route_table"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: screenWidth / 2.5,
        margin: EdgeInsets.all(
            screenWidth / 50), // Adds space around the entire table
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              16), // Rounded corners for the outer container
          border: Border.all(color: Colors.grey, width: 1), // Outer border
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header
            Container(
              decoration: const BoxDecoration(
                color: GobalStyles.backgroundTableColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16)), // Rounded corners at the top
              ),
              child: Row(
                children: [
                  _buildHeaderCell(_jsonString?['date'] ?? 'Date'),
                  _buildHeaderCell(_jsonString?['route'] ?? 'Route'),
                  _buildHeaderCell(_jsonString?['status'] ?? 'Status'),
                  // _buildHeaderCell('สถานะ'),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    _buildDataRow(
                        'Day 01',
                        '1',
                        '5/5',
                        Styles.successBackgroundColor,
                        Styles.successTextColor,
                        0),
                    _buildDataRow(
                        'Day 02',
                        '2',
                        '6/6',
                        Styles.successBackgroundColor,
                        Styles.successTextColor,
                        1),
                    _buildDataRow('Day 03', '4', '0/9',
                        Styles.failBackgroundColor, Styles.failTextColor, 2),
                    _buildDataRow('Day 04', '5', '11/16',
                        Styles.paddingBackgroundColor, Colors.blue, 3),
                    _buildDataRow('Day 05', '6', '2/9',
                        Styles.paddingBackgroundColor, Colors.blue, 4),
                    _buildDataRow(
                        'Day 06',
                        '7',
                        '9/9',
                        Styles.successBackgroundColor,
                        Styles.successTextColor,
                        5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String day, String route, String status, Color? bgColor,
      Color? textColor, int index) {
    // Alternate row background color
    Color rowBgColor =
        (index % 2 == 0) ? Colors.white : GobalStyles.backgroundTableColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Shoproutescreen(day: day, route: route, status: status),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: rowBgColor,
        ),
        child: Row(
          children: [
            Expanded(
                child: _buildTableCell(
                    day)), // Use Expanded to distribute space equally
            Expanded(child: _buildTableCell(route)),
            // Expanded(child: _buildTableCell(route)),
            Expanded(
                child: _buildStatusCell(status, bgColor,
                    textColor)), // Custom function for "สถานะ" column
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
          borderRadius: BorderRadius.circular(
              100), // Rounded corners for the inner container
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
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(text, style: Styles.black18),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          text,
          style: Styles.grey18,
        ),
      ),
    );
  }
}
