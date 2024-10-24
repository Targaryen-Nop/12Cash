import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/table/CartSTable.dart';
import 'package:_12sale_app/page/route/OrderScreen.dart';
import 'package:_12sale_app/page/route/PromotionScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class ShoppingCartScreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const ShoppingCartScreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});
  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  int count = 4;
  double price = 2000.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " ตะกร้าสินค้า", icon: Icons.shopping_cart_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("รหัสร้าน ${widget.customerNo}", style: GobalStyles.kanit32),
            Text("ร้าน ${widget.customerName}", style: GobalStyles.kanit32),
            Align(
              alignment: Alignment.center,
              child: Text(
                "รายการสินค้า ที่เลือก",
                style: GobalStyles.kanit32,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CartTable(),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth / 2.2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Orderscreen(
                              customerNo: widget.customerNo,
                              customerName: widget.customerName,
                              status: widget.status),
                        ),
                      );
                    },
                    child:
                        Text('เลือกสินค้าเพิ้่มเติม', style: GobalStyles.text3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GobalStyles.primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth / 85,
                          horizontal: screenWidth / 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: screenWidth / 2.3,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Promotionscreen(
                            customerName: widget.customerName,
                            customerNo: widget.customerNo,
                            status: widget.status,
                          ),
                        ),
                      );
                    },
                    child: Text('สร้างรายการ', style: GobalStyles.text3),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GobalStyles.successButtonColor,
                      padding: EdgeInsets.symmetric(
                          vertical: screenWidth / 80,
                          horizontal: screenWidth / 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("จำนวน", style: GobalStyles.kanit32),
                Row(
                  children: [
                    Text("${count}    ", style: GobalStyles.kanit32),
                    Text("รายการ", style: GobalStyles.kanit32),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ราคาสุทธิ", style: GobalStyles.kanit32),
                Row(
                  children: [
                    Text("${price}          ", style: GobalStyles.kanit32),
                    Text("บาท", style: GobalStyles.kanit32),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
