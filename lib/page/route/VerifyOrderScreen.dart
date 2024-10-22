import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/BuildTextRowDetailShop.dart';
import 'package:_12sale_app/components/button/Button.dart';
import 'package:_12sale_app/components/table/VerifyTable.dart';
import 'package:_12sale_app/page/HomeScreen.dart';
import 'package:_12sale_app/page/route/RouteScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class Verifyorderscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Verifyorderscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Verifyorderscreen> createState() => _VerifyorderscreenState();
}

class _VerifyorderscreenState extends State<Verifyorderscreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " ยืนยันการสั่งซื้อ", icon: Icons.save_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTextRowDetailShop(
              text: "พนักงานขาย",
              value: "จิตรีน เชียงเหิน",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "รหัสร้านค้า",
              value: widget.customerNo,
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "ชื่อร้านค้า",
              value: widget.customerName,
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "ที่อยู่",
              value: "99/9 ถ.ย่ายชื่อ ต.บางบา อ.พานทอง จ.ชลบุรี",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "เบอร์ร้าน",
              value: "0831157890",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "เลขที่ผู้เสียภาษี",
              value: "-",
              left: 3,
              right: 7,
            ),
            VerifyTable(),
            Spacer(),
            Divider(
              color: Colors.grey,
            ),
            BuildTextRowBetween(
                text: "ยอดรวม", price: 800.00, style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "ส่วนลดท้ายบิล",
                price: 8430.00,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "ราคาไม่รวมภาษี",
                price: 00.00,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "ภาษี 7% (VAT)",
                price: 7878.50,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "ยอดชำระสุทธิ",
                price: 8430.00,
                style: GobalStyles.textbBlack3),
            // ButtonFullWidth(
            //   text: "บันทึกรายการ",
            //   textStyle: GobalStyles.text3,
            //   blackGroundColor: GobalStyles.successButtonColor,
            //   screen: Routescreen(),
            // )
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Perform save action
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                        index: 1,
                      ),
                    ),
                  );
                },
                child: Text('บันทึกรายการ', style: GobalStyles.text3),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GobalStyles.successButtonColor,
                  padding: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
