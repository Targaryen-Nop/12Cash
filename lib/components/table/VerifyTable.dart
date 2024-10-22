import 'package:_12sale_app/page/route/OrderDetailScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class VerifyTable extends StatefulWidget {
  const VerifyTable({super.key});

  @override
  State<VerifyTable> createState() => _VerifyTable();
}

class _VerifyTable extends State<VerifyTable> {
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
                  _buildHeaderCellName('ชื่อสินค้า', 300),
                  _buildHeaderCell('จำนวน'),
                  _buildHeaderCell('ราคาสินค้า'),
                  _buildHeaderCell('ส่วนลด'),
                  _buildHeaderCell('รวมราคา'),
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
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        '00.00',
                        '1 หีบ',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        0),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        '00.00',
                        '1 หีบ',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        1),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสเห็ดหอม ฟ้าไทย 75g x10x8',
                        '5800.00',
                        '00.00',
                        '1 หีบ',
                        GobalStyles.failBackgroundColor,
                        GobalStyles.failTextColor,
                        2),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        '00.00',
                        '10 ซอง',
                        GobalStyles.paddingBackgroundColor,
                        Colors.blue,
                        3),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        '00.00',
                        '10 หีบ',
                        GobalStyles.paddingBackgroundColor,
                        Colors.blue,
                        4),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        '00.00',
                        '100 ถุง',
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

  Widget _buildDataRow(
      String itemCode,
      String itemName,
      String price,
      String discount,
      String count,
      Color? bgColor,
      Color? textColor,
      int index) {
    // Alternate row background color
    Color rowBgColor =
        (index % 2 == 0) ? Colors.white : GobalStyles.backgroundTableColor;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetail(
                itemCode: itemCode, itemName: itemName, price: price),
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
                flex: 4,
                child: _buildTableCell(itemName, Alignment.centerLeft)),
            Expanded(
                flex: 1, child: _buildTableCell(count, Alignment.centerRight)),
            Expanded(
                flex: 1, child: _buildTableCell(price, Alignment.centerRight)),
            Expanded(
                flex: 1,
                child: _buildTableCell(discount, Alignment.centerRight)),
            Expanded(
                flex: 1, child: _buildTableCell(price, Alignment.centerRight)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(
      String price, Color? bgColor, Color? textColor, double? width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Container(
        width: 50, // Optional inner width for the status cell
        // padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.red,
          // borderRadius: BorderRadius.circular(
          //     100), // Rounded corners for the inner container
        ),
        alignment: Alignment.center,
        child: Icon(Icons.close, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildTableCell(String text, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: EdgeInsets.all(8),
      child: Text(text, style: GobalStyles.kanit24),
    );
  }

  Widget _buildHeaderCellName(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: GobalStyles.tableHeaderOrder,
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: GobalStyles.tableHeaderOrder,
        ),
      ),
    );
  }

  Widget _buildHeaderCellIcon(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: GobalStyles.tableHeader,
      ),
    );
  }
}
