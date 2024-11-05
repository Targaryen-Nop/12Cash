import 'dart:convert';

import 'package:_12sale_app/core/page/report/DetailReportScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Reportsaletable extends StatefulWidget {
  const Reportsaletable({super.key});

  @override
  State<Reportsaletable> createState() => _ReportsaletableState();
}

class _ReportsaletableState extends State<Reportsaletable> {
  Map<String, dynamic>? _jsonString;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["reportsale_table"];
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
                  _buildHeaderCell(_jsonString?['order_date'] ?? 'Order Date'),
                  _buildHeaderCell(_jsonString?['order_no'] ?? 'Order No'),
                  _buildHeaderCell(
                      _jsonString?['customer_name'] ?? 'Customer Name'),
                  _buildHeaderCell(_jsonString?['amount'] ?? 'Amount'),
                  _buildHeaderCell(_jsonString?['status'] ?? 'Status'),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    _buildDataRow('13/06/2023', 'MBE23000001', 'VB23300330',
                        'เจ๊กุ้ง', '3000.00', 'รอส่ง', 0, context),
                    _buildDataRow(
                        '13/06/2023',
                        'MBE23000002',
                        'VB23300330',
                        'บริษัท ขายของชำไม่จำกัด',
                        '4000.00',
                        'ไม่สำเร็จ',
                        1,
                        context),
                    _buildDataRow(
                        '13/06/2023',
                        'MBE23000003',
                        'VB23300330',
                        'บริษัท ขายส้มตำ จำกัด',
                        '100.00',
                        'สำเร็จ',
                        2,
                        context),
                    _buildDataRow(
                        '13/06/2023',
                        'MBE23000004',
                        'VB23300330',
                        'บริษัท ขายส้มตำภาษี จำกัด',
                        '500.00',
                        'สำเร็จ',
                        3,
                        context),
                    _buildDataRow(
                        '13/06/2023',
                        'MBE23000005',
                        'VB23300330',
                        'บริษัท เก่งกำไรจำกัด มหาชน',
                        '300000.00',
                        'สำเร็จ',
                        4,
                        context),
                    _buildDataRow(
                        '13/06/2023',
                        'MBE23000006',
                        'VB23300330',
                        'ร้านลุงอ่อย ขายส้มตำ',
                        '10000.00',
                        'อนุมัติ',
                        5,
                        context),
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
      String date,
      String orderNo,
      String customerNo,
      String customerName,
      String price,
      String status,
      int index,
      BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Alternate row background color
    Color rowBgColor =
        (index % 2 == 0) ? Colors.white : GobalStyles.backgroundTableColor;

    Color backgroundColor = (status == 'ไม่สำเร็จ')
        ? Colors.red
        : (status == 'รอส่ง')
            ? Colors.orange
            : Colors.green;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailReportScreen(
              date: date,
              orderNo: orderNo,
              customerNo: customerNo,
              customerName: customerName,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: rowBgColor,
        ),
        child: Row(
          children: [
            Expanded(child: _buildTableCell(date, Alignment.centerLeft)),
            _buildTableCellName(orderNo, screenWidth / 4.8),
            _buildTableCellName(customerName, screenWidth / 6),
            _buildTableCellName(price, screenWidth / 10),
            _buildStatusCell(backgroundColor, screenWidth / 20, status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(Color? bgColor, double? width, String text) {
    return Expanded(
      child: Container(
        width: width,
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
                100), // Rounded corners for the inner container
          ),
          alignment: Alignment.center,
          child: Text(text, style: Styles.white18(context)),
        ),
      ),
    );
  }

  Widget _buildTableCellName(String text, double width) {
    return Container(
      alignment: Alignment.centerLeft,
      width: width,
      padding: const EdgeInsets.all(2),
      child: Text(text, style: Styles.black18(context)),
    );
  }

  Widget _buildTableCell(String text, Alignment alignment) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(2),
      child: Text(text, style: Styles.black18(context)),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(2),
        child: Text(
          text,
          style: Styles.grey18(context),
        ),
      ),
    );
  }
}
