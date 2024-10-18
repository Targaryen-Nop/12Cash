import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/table/ShopRouteTable.dart';
import 'package:_12sale_app/components/table/TableFullData.dart';
import 'package:_12sale_app/page/OrderScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
            title: " การเข้าเยี่ยม" " " + widget.day, icon: Icons.event),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
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
                icon: Icons.location_on_rounded,
                label: 'ไม่ขายสินค้า',
                color: Colors.red,
                onPressed: () {
                  _showBottomSheet(context);
                },
              ),
              _buildCustomButton(
                context,
                icon: Icons.add_shopping_cart_rounded,
                label: 'ขายสินค้า',
                color: Colors.teal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Orderscreen(
                          day: widget.day,
                          customerName: widget.customerName,
                          status: widget.status),
                    ),
                  );
                },
              ),
              _buildCustomButton(
                context,
                icon: Icons.add_a_photo,
                label: 'ถ่ายรูป',
                color: Colors.blue,
                onPressed: () {
                  _showBottomCamera(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("รหัสร้าน ${widget.customerNo}", style: GobalStyles.kanit32),
            Text("ร้าน ${widget.customerName}", style: GobalStyles.kanit32),
            // Text(
            //   "ร้าน เจริญพรค้าขาย",
            //   style: GobalStyles.kanit32,
            // ),
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
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: 120, // Fixed width for the button
        height: 120, // Fixed height for the button
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 5, // How much the shadow spreads
              blurRadius: 8, // The amount of blur for the shadow
              offset: Offset(0, 0), // Spread evenly in all directions
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 65,
              weight: 25,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: GobalStyles.textBuntton,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ระบุสาเหตุที่ร้านค้าไม่ซื้อ',
                      style: GobalStyles.headlineblack2,
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Store Information
                Text(
                  'รหัสร้าน 10334587',
                  style: GobalStyles.headlineblack3,
                ),
                Text(
                  'ร้าน เจริญพรค้าขาย',
                  style: GobalStyles.headlineblack3,
                ),
                SizedBox(height: 16),

                // Dropdown field
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  value: 'อื่นๆ', // Default value
                  items: <String>['อื่นๆ', 'เหตุผล 1', 'เหตุผล 2']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  style: GobalStyles.articalTable,
                  onChanged: (String? newValue) {},
                ),

                const SizedBox(height: 16),

                // Text input field
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'ใส่ข้อมูล',
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
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('บันทึก'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
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

  void _showBottomSheet(BuildContext context) {
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
          height: 600,
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
                        style: GobalStyles.headlineblack2),
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
                  style: GobalStyles.headlineblack3,
                ),
                Text(
                  'ร้าน เจริญพรค้าขาย',
                  style: GobalStyles.headlineblack3,
                ),
                SizedBox(height: 16),

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
                      contentPadding: EdgeInsets.only(left: 250)),
                  style: GobalStyles.headline2,

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
                          style: GobalStyles.articalTable,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},
                ),
                SizedBox(height: 16),

                // Text input field
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'ใส่ข้อมูล',
                    hintStyle: GobalStyles.articalTable,
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
                    child: Text('บันทึก', style: GobalStyles.headline2),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GobalStyles.successButtonColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
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
          height: 700,
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
                    Text('จัดเก็บรูปภาพ', style: GobalStyles.headlineblack2),
                  ],
                ),
                SizedBox(height: 8),
                // Store Information
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    // width: 250,
                    height: 438,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    // transformAlignment: Alignment.center,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity, // Full width button
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform save action
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Icon(
                            Icons.camera,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                        Text('กล้อง', style: GobalStyles.articalTable),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
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
                    child: Text('บันทึกรูปภาพ', style: GobalStyles.headline2),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: GobalStyles.successButtonColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        )),
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
