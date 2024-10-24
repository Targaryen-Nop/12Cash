import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/page/shop/AddShopScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class DetailShopScreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  const DetailShopScreen(
      {super.key, required this.customerNo, required this.customerName});

  @override
  State<DetailShopScreen> createState() => _DetailShopScreenState();
}

class _DetailShopScreenState extends State<DetailShopScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " รายละเอียดร้านค้า",
            icon: Icons.store_mall_directory_rounded),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.store, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                const SizedBox(
                    width: 8), // Adds some spacing between the icon and text
                Text(
                  "ข้อมูลร้านค้า",
                  style: GobalStyles.kanit24,
                ),
              ],
            ),
            SizedBox(height: screenWidth / 80),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              // height: screenWidth / 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildCustomFormField(
                        'ชื่อร้านค้า', 'ร้านน้องเบล', Icons.store),
                    _buildCustomFormField('เลขประจำตัวผู้เสียภาษี',
                        '1234567891011', Icons.person_outline),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCustomFormField(
                              'โทรศัพท์', '089-2463592', Icons.phone),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildCustomFormField(
                              'เส้นทาง', 'R01', Icons.location_on),
                        ),
                      ],
                    ),
                    _buildCustomFormField(
                        'ไลน์', '@testja', Icons.alternate_email),
                    _buildCustomFormField('ประเภทร้านค้า', 'แผงตลาดสด',
                        Icons.store_mall_directory),
                    _buildCustomFormField('หมายเหตุ',
                        'ร้านปิดอาทิตย์ รับของ 15.00 - 16.00', Icons.note),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100, // Set the width of the button
                  height: screenWidth / 8, // Set the height of the button
                  child: FloatingActionButton(
                    // Your actual Fab
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddShopScreen(),
                        ),
                      );
                    },
                    backgroundColor: GobalStyles.primaryColor,
                    shape: CircleBorder(),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCustomFormField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: value,
        style: GobalStyles.kanit18,
        readOnly: true, // Makes the TextFormField read-only
        decoration: InputDecoration(
          labelText: label,
          // hintStyle: GobalStyles.kanit18,
          labelStyle: GobalStyles.kanit18,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
