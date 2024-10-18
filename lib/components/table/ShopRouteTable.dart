import 'package:_12sale_app/page/DetailScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        // height: 250,
        margin: const EdgeInsets.all(16), // Adds space around the entire table
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
                  _buildHeaderCell('รหัสร้าน'),
                  _buildHeaderCell('ชื่อร้านค้า'),
                  _buildHeaderCell('สถานะ'),
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
                        'VB23600127',
                        'ร้าน ตาชาย',
                        'เช็คอิน',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        0),
                    _buildDataRow(
                        'VB23600537',
                        'ร้านก้อย หนองใหญ่',
                        'เช็คอิน',
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        1),
                    _buildDataRow(
                        'VB23600556',
                        'เข้มข้นขนมจีนน้ำยา ',
                        'รอเยี่ยม',
                        GobalStyles.failBackgroundColor,
                        GobalStyles.failTextColor,
                        2),
                    _buildDataRow('VB23600330', 'เข้มข้นขนมจีนน้ำยา', 'ขายแล้ว',
                        GobalStyles.paddingBackgroundColor, Colors.blue, 3),
                    _buildDataRow('VB23600177', 'เข้มข้นขนมจีนน้ำยา', 'ขายแล้ว',
                        GobalStyles.paddingBackgroundColor, Colors.blue, 4),
                    _buildDataRow(
                        'VB23600177',
                        'เข้มข้นขนมจีนน้ำยา',
                        'เช็คอิน',
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

  Widget _buildDataRow(String customerNo, String customerName, String status,
      Color? bgColor, Color? textColor, int index) {
    // Alternate row background color
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
                status: status),
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
                    customerNo)), // Use Expanded to distribute space equally
            Expanded(child: _buildTableCell(customerName)),

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
      child: Text(text, style: GobalStyles.kanit24),
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
