import 'package:_12sale_app/core/page/route/DetailScreen.dart';
import 'package:_12sale_app/core/page/route/ShopRouteScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TableFullData extends StatefulWidget {
  const TableFullData({super.key});

  @override
  State<TableFullData> createState() => _TableFullDataState();
}

class _TableFullDataState extends State<TableFullData> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: screenWidth / 2,
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
                  _buildHeaderCell('วันที่'),
                  _buildHeaderCell('เส้นทาง'),
                  _buildHeaderCell('สถานะ'),
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
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        0),
                    _buildDataRow(
                        'Day 02',
                        '2',
                        '6/6',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        1),
                    _buildDataRow(
                        'Day 03',
                        '4',
                        '0/9',
                        GobalStyles.failBackgroundColor,
                        GobalStyles.failTextColor,
                        2),
                    _buildDataRow('Day 04', '5', '11/16',
                        GobalStyles.paddingBackgroundColor, Colors.blue, 3),
                    _buildDataRow('Day 05', '6', '2/9',
                        GobalStyles.paddingBackgroundColor, Colors.blue, 4),
                    _buildDataRow(
                        'Day 06',
                        '7',
                        '9/9',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
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
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
              100), // Rounded corners for the inner container
        ),
        alignment: Alignment.center,
        child: Text(
          status,
          style: GoogleFonts.kanit(color: textColor, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(text, style: GobalStyles.tableText),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: GobalStyles.tableHeader,
        ),
      ),
    );
  }
}
