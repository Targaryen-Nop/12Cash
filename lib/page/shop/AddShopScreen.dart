import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/button/Button.dart';
import 'package:_12sale_app/components/input/CustomTextInput.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class AddShopScreen extends StatefulWidget {
  const AddShopScreen({super.key});

  @override
  State<AddShopScreen> createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " เพิ่มร้านค้า", icon: Icons.store_mall_directory_rounded),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.store, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                SizedBox(
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
              height: screenWidth / 2,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Customtextinput(
                        context,
                        label: 'ชื่อร้านค้า *',
                        hint: 'ไม่เกิน 36 ตัวอักษร',
                      ),
                      SizedBox(height: 16),
                      Customtextinput(
                        context,
                        label: 'เลขประจำตัวผู้เสียภาษี',
                        hint: 'ไม่เกิน 13 ตัวอักษร',
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'โทรศัพท์',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'เส้นทาง',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Customtextinput(
                        context,
                        label: 'ประเภทร้านค้า *',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth / 80),
            Row(
              children: [
                Icon(
                  Icons
                      .location_on_rounded, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                SizedBox(
                    width: 8), // Adds some spacing between the icon and text
                Text(
                  "ที่อยู่",
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
              height: screenWidth / 3,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Customtextinput(
                        context,
                        label: 'ชื่อร้านค้า *',
                        hint: 'ไม่เกิน 36 ตัวอักษร',
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'โทรศัพท์',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'เส้นทาง',
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'โทรศัพท์',
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Customtextinput(
                              context,
                              label: 'เส้นทาง',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth / 80),
            Row(
              children: [
                const Icon(
                  Icons
                      .camera_alt, // Use any icon you want, or load custom icons
                  size: 40,
                ),
                SizedBox(
                    width: 8), // Adds some spacing between the icon and text
                Text(
                  "ภาพถ่าย",
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
              height: screenWidth / 5,
              child: Center(
                child: Text("รูปภาพ"),
              ),
            ),
            Spacer(),
            ButtonFullWidth(
                text: "ถัดไป",
                textStyle: GobalStyles.text3,
                blackGroundColor: GobalStyles.successButtonColor)
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context,
      {required String label, String? hint}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}
