import 'dart:convert';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/CameraButton.dart';
// import 'package:_12sale_app/core/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/core/components/table/ShopRouteTableMapAPI.dart';
import 'package:_12sale_app/core/page/route/OrderScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  final String customerNo;
  final String day;
  final String customerName;
  final String status;

  const DetailScreen(
      {super.key,
      required this.customerNo,
      required this.day,
      required this.customerName,
      required this.status});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Map<String, dynamic>? _jsonString;
  String? imagePath; // Path to store the captured image
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["detail_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: ' ${_jsonString?['title'] ?? 'Visiting'} ${widget.day}',
            icon: Icons.event),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color:
              GobalStyles.primaryColor, // Primary color of the navigation bar
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26, // Shadow color
              blurRadius: 10, // Soft blur effect
              spreadRadius: 2, // Spread of the shadow
              offset: Offset(0, -3), // Shadow positioned upwards
            ),
          ],
        ),
        child: ClipRRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCustomButton(
                context,
                icon: Icons.cancel_rounded,
                label: _jsonString?['cancel_order_button'] ?? 'Cancel Order',
                color: Colors.red,
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
              _buildCustomButton(
                context,
                icon: Icons.add_shopping_cart_rounded,
                label: _jsonString?['order_button'] ?? 'Order',
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Orderscreen(
                          customerNo: widget.customerNo,
                          customerName: widget.customerName,
                          status: widget.status),
                    ),
                  );
                },
              ),
              _buildCustomButton(
                context,
                icon: Icons.add_a_photo,
                label: _jsonString?['camera_button'] ?? 'Camera',
                color: Colors.blue,
                onPressed: () {
                  _showBottomCamera(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("รหัสร้าน ${widget.customerNo}",
                  style: Styles.headerBlack24),
              Text("ร้าน ${widget.customerName}", style: Styles.headerBlack24),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  height: screenWidth,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: ShopRouteTable(
                    day: widget.day,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: screenWidth / 7, // Fixed width for the button
        height: screenWidth / 7, // Fixed height for the button
        // margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 5, // How much the shadow spreads
              blurRadius: 8, // The amount of blur for the shadow
              offset: const Offset(0, 0), // Spread evenly in all directions
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 50,
              // weight: 25,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: Styles.white18,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full screen height
      shape: const RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return Container(
          width: screenWidth, // Fixed width
          height: screenWidth * 0.8,
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ระบุสาเหตุที่ร้านค้าไม่ซื้อ',
                        style: Styles.headerBlack24),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close bottom sheet
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Store Information
                Text(
                  'รหัสร้าน 10334587',
                  style: Styles.headerBlack24,
                ),
                Text(
                  'ร้าน เจริญพรค้าขาย',
                  style: Styles.headerBlack24,
                ),
                const SizedBox(height: 16),

                // Dropdown field
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors
                          .grey[300], // Set the fill color to match the image
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            BorderSide.none, // Remove border if not needed
                      ),
                      contentPadding: const EdgeInsets.only(left: 250)),
                  style: Styles.headerWhite32,

                  value: 'อื่นๆ', // Default value
                  alignment: Alignment.center, // Center the selected value text
                  items: <String>['อื่นๆ', 'เหตุผล 1', 'เหตุผล 2']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(
                        // Center-align the text inside the dropdown items
                        child: Text(
                          value,
                          style: Styles.black18,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                const SizedBox(height: 16),

                // Text input field
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'ใส่ข้อมูล',
                    hintStyle: Styles.black18,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Save button
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform save action
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('บันทึก', style: Styles.headerWhite32),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GobalStyles.successButtonColor,
                      // padding: EdgeInsets.symmetric(vertical: 12),
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
      },
    );
  }

  void _showBottomCamera(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the bottom sheet full screen height
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 0.5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        return Container(
          width: screenWidth, // Fixed width
          height: screenWidth / 1.2,
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header with close button
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close bottom sheet
                      },
                    ),
                    Text('จัดเก็บรูปภาพ', style: Styles.headerBlack24),
                  ],
                ),
                const SizedBox(height: 8),
                // Store Information
                const CameraButtonWidget(),
                const SizedBox(height: 16),
                // Save button
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform save action
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GobalStyles.successButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
                    child: Text('บันทึกรูปภาพ', style: Styles.headerWhite24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}