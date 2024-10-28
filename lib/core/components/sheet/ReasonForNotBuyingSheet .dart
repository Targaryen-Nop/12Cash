import 'package:flutter/material.dart';

class ReasonForNotBuyingSheet extends StatelessWidget {
  final String storeCode;
  final String storeName;

  const ReasonForNotBuyingSheet({
    Key? key,
    required this.storeCode,
    required this.storeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
              'รหัสร้าน $storeCode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Text(
              storeName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),

            // Dropdown field
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[300], // Background color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none, // Remove border if not needed
                ),
              ),
              value: 'อื่นๆ', // Default value
              alignment: Alignment.center, // Center the selected value text
              items:
                  <String>['อื่นๆ', 'เหตุผล 1', 'เหตุผล 2'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 16),
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
                child: Text('บันทึก', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Example button color
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
