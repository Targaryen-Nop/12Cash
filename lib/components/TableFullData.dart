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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fixed header
        Container(
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
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
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDataRow(
                      'Day 01', '1', '5/5', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 02', '2', '6/6', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 03', '4', '0/9', Colors.red[100], Colors.red),
                  _buildDataRow(
                      'Day 04', '5', '11/16', Colors.blue[100], Colors.blue),
                  _buildDataRow(
                      'Day 05', '6', '2/9', Colors.blue[100], Colors.blue),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                  _buildDataRow(
                      'Day 06', '7', '9/9', Colors.green[100], Colors.green),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      // padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        border: const Border(
          right: BorderSide(color: Colors.grey, width: 1),
          left: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Text(
        text,
        style: GobalStyles.headerTable,
      ),
    );
  }

  Widget _buildDataRow(String day, String route, String status, Color? bgColor,
      Color? textColor) {
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
          border: Border.all(
              color: Colors.grey, width: 1), // Add border around the row
        ),
        child: Row(
          children: [
            _buildTableCell(day, 200),
            _buildTableCell(route, 200),
            Container(
              width: 200, // Fixed width for the container
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment:
                  Alignment.center, // Center the text inside the container
              child: Text(
                status,
                style: TextStyle(color: textColor, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border(
          // bottom: BorderSide(color: Colors.grey, width: 1),
          right: BorderSide(color: Colors.grey, width: 1),
          // left: BorderSide(color: Colors.grey, width: 1),
          // top: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Text(text, style: GobalStyles.articalTable),
    );
  }
}
