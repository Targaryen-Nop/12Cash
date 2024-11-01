import 'dart:convert';

import 'package:_12sale_app/core/page/route/OrderDetailScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderTable extends StatefulWidget {
  const OrderTable({super.key});

  @override
  State<OrderTable> createState() => _OrderTableState();
}

class _OrderTableState extends State<OrderTable> {
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["order_table"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: screenWidth / 1.3,
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
                  _buildHeaderCell(_jsonString?['item_code'] ?? 'Item Code'),
                  _buildHeaderCell(_jsonString?['item_name'] ?? 'Item Name'),
                  _buildHeaderCell(_jsonString?['price'] ?? 'Price'),
                  _buildHeaderCellIcon('', 50),
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
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        0),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        1),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสเห็ดหอม ฟ้าไทย 75g x10x8',
                        '5800.00',
                        GobalStyles.failBackgroundColor,
                        GobalStyles.failTextColor,
                        2),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        GobalStyles.paddingBackgroundColor,
                        Colors.blue,
                        3),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
                        GobalStyles.paddingBackgroundColor,
                        Colors.blue,
                        4),
                    _buildDataRow(
                        '1011447875',
                        'ผงปรุงรสไก่ ฟ้าไทย 75g x10x8',
                        '58.00',
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

  Widget _buildDataRow(String itemCode, String itemName, String price,
      Color? bgColor, Color? textColor, int index) {
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
                child: _buildTableCell(
                    itemCode)), // Use Expanded to distribute space equally
            Expanded(flex: 2, child: _buildTableCell(itemName)),
            Expanded(child: _buildTableCell(price)),
            _buildStatusCell(price, bgColor, textColor, 50),
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
        margin: const EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.green,
          // borderRadius: BorderRadius.circular(
          //     100), // Rounded corners for the inner container
        ),
        alignment: Alignment.center,
        child: const Icon(Icons.add, color: Colors.white, size: 40),
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

  Widget _buildHeaderCellIcon(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: Styles.grey18,
      ),
    );
  }
}
