import 'package:_12sale_app/page/DetailScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class TableFullData extends StatefulWidget {
  const TableFullData({super.key});

  @override
  State<TableFullData> createState() => _TableFullDataState();
}

class _TableFullDataState extends State<TableFullData> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 610,
        height: 400,
        margin: EdgeInsets.all(16), // Adds space around the entire table
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
              decoration: BoxDecoration(
                color: GobalStyles.backgroundTableColor,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16)), // Rounded corners at the top
              ),
              child: Row(
                children: [
                  _buildHeaderCell('วันที่', 200),
                  _buildHeaderCell('เส้นทาง', 200),
                  _buildHeaderCell('สถานะ', 200),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                      _buildDataRow(
                          'Day 06',
                          '7',
                          '9/9',
                          GobalStyles.successBackgroundColor,
                          GobalStyles.successTextColor,
                          6),
                      _buildDataRow(
                          'Day 06',
                          '7',
                          '9/9',
                          GobalStyles.successBackgroundColor,
                          GobalStyles.successTextColor,
                          7),
                      _buildDataRow(
                          'Day 06',
                          '7',
                          '9/9',
                          GobalStyles.successBackgroundColor,
                          GobalStyles.successTextColor,
                          8),
                      _buildDataRow(
                          'Day 06',
                          '7',
                          '9/9',
                          GobalStyles.successBackgroundColor,
                          GobalStyles.successTextColor,
                          9),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      height: 75,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.grey, width: 1),
          ),
      child: Text(
        text,
        style: GobalStyles.tableHeader,
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
        // Navigate to the detail screen with data when the row is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailScreen(day: day, route: route, status: status),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: rowBgColor,
          // border: Border.all(color: Colors.grey, width: 1),
          // border:Border.symmetric(horizontal: BorderSide())
        ),
        child: Row(
          children: [
            _buildTableCell(day, 200),
            _buildTableCell(route, 200),
            _buildStatusCell(status, bgColor,
                textColor), // Custom function for "สถานะ" column
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(String status, Color? bgColor, Color? textColor) {
    return Container(
      width: 200, // Outer container width
      alignment: Alignment.center, // Align the inner container in the center
      child: Container(
        width: 100, // Inner container width
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
              100), // Rounded corners for the inner container
        ),
        alignment:
            Alignment.center, // Center the text inside the inner container
        child: Text(
          status,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      // decoration: BoxDecoration(
      //   border: Border.all(
      //       color: Colors.grey, width: 1), // Equal borders for all sides
      // ),
      child: Text(text, style: GobalStyles.tableText),
    );
  }
}
