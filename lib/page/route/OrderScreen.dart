import 'package:_12sale_app/components/Appbar.dart';
import 'package:_12sale_app/components/button/CartButton.dart';
import 'package:_12sale_app/components/table/OrderTable.dart';
import 'package:_12sale_app/components/table/TableFullData.dart';
import 'package:_12sale_app/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';

class Orderscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  Orderscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  @override
  String dropdownValue = 'แบรนด์'; // Default value
  int cartItemCount = 1;
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(title: " การสั่งซื้อสินค้า", icon: Icons.event),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.all(8.0),
        // color: Colors.red,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("รหัสร้าน 10334587", style: GobalStyles.kanit32),
            Text(
              "ร้าน เจริญพรค้าขาย",
              style: GobalStyles.kanit32,
            ),
            SizedBox(height: screenWidth / 80),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300], // Light grey background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                          borderSide: BorderSide.none, // Remove border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8), // Padding for the dropdown
                      ),
                      value: dropdownValue,
                      icon: Icon(
                        Icons.chevron_left,
                        size: 25,
                      ), // Icon on the right (chevron)
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      items: <String>[
                        'แบรนด์',
                        'Option 1',
                        'Option 2',
                        'Option 3'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300], // Light grey background
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                        borderSide: BorderSide.none, // Remove border
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8), // Padding for the dropdown
                    ),
                    value: dropdownValue,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 25,
                    ), // Icon on the right (chevron)
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    items: <String>[
                      'แบรนด์',
                      'Option 1',
                      'Option 2',
                      'Option 3'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth / 80),
            Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300], // Light grey background
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(5), // Rounded corners
                          borderSide: BorderSide.none, // Remove border
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8), // Padding for the dropdown
                      ),
                      value: dropdownValue,
                      icon: Icon(
                        Icons.chevron_left,
                        size: 25,
                      ), // Icon on the right (chevron)
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      items: <String>[
                        'แบรนด์',
                        'Option 1',
                        'Option 2',
                        'Option 3'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300], // Light grey background
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(5), // Rounded corners
                        borderSide: BorderSide.none, // Remove border
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8), // Padding for the dropdown
                    ),
                    value: dropdownValue,
                    icon: Icon(
                      Icons.chevron_left,
                      size: 25,
                    ), // Icon on the right (chevron)
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    items: <String>[
                      'แบรนด์',
                      'Option 1',
                      'Option 2',
                      'Option 3'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: screenWidth / 80),
            Align(
              alignment: Alignment.center,
              child: Text(
                "รายการสินค้า ที่เลือก",
                style: GobalStyles.kanit32,
              ),
            ),
            SizedBox(height: screenWidth / 80),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CartTable(),
            ),
            SizedBox(height: screenWidth / 80),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "รวมราคา 38000.00",
                style: GobalStyles.kanit32,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Cartbutton(
        count: "4",
        screen: ShoppingCartScreen(
            customerNo: widget.customerNo,
            customerName: widget.customerName,
            status: widget.status),
      ),
    );
  }
}
