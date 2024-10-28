import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/table/CartSTable.dart';
import 'package:_12sale_app/core/components/table/PromotionTable.dart';
import 'package:_12sale_app/core/page/route/VerifyOrderScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class Promotionscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Promotionscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Promotionscreen> createState() => _PromotionscreenState();
}

class _PromotionscreenState extends State<Promotionscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " โปรโมชั่น และส่วนลด", icon: Icons.cancel_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("ของแถม", style: GobalStyles.kanit32),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Promotiontable(),
            ),
            Text("ส่วนลด", style: GobalStyles.kanit32),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Promotiontable(),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Perform save action
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Verifyorderscreen(
                        customerName: widget.customerName,
                        customerNo: widget.customerNo,
                        status: widget.status,
                      ),
                    ),
                  );
                },
                child: Text('ถัดไป', style: GobalStyles.text3),
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
