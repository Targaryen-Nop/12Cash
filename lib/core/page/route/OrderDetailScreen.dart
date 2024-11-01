import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderDetail extends StatefulWidget {
  final String itemCode;
  final String itemName;
  final String price;

  const OrderDetail(
      {super.key,
      required this.itemCode,
      required this.itemName,
      required this.price});
  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  Map<String, dynamic>? _jsonString;
  String selectedLabel = "";
  int count = 1; // Initialized with 1
  int unit = 1;
  late double price;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    price = double.parse(widget.price);
    totalPrice = price; // Initialize the totalPrice
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["order_detail_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: "${_jsonString?["title"] ?? 'Order Detail'}",
            icon: Icons.inventory_2_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.grey[100],
        child: Column(
          children: [
            // Product Info Section
            Container(
              color: Colors.white,
              margin: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: screenWidth / 3,
                      width: screenWidth / 3,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/12TradingLogo.png'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("รหัสสินค้า ${widget.itemCode}",
                            style: Styles.black18),
                        Text(widget.itemName, style: Styles.black18),
                        Text("ราคา $price", style: Styles.black18),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Unit Selection Buttons
            Row(
              children: [
                _buildCustomButton("หีบ", 36),
                _buildCustomButton("กล่อง", 12),
                _buildCustomButton("ชิ้น", 1),
              ],
            ),

            // Spacer for alignment
            const Spacer(),

            // Total Price and Quantity Control
            Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'รวมราคา ${totalPrice.toStringAsFixed(2)} บาท',
                    style: GobalStyles.textbBlack3,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            count++;
                            totalPrice = price * count * unit;
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.black),
                        iconSize: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        width: 100,
                        alignment: Alignment.center,
                        child: Text(
                          '$count',
                          style: GobalStyles.textbBlack3,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (count > 1) {
                              count--;
                              totalPrice = price * count * unit;
                            }
                          });
                        },
                        icon: const Icon(Icons.remove, color: Colors.black),
                        iconSize: 40,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Add Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextButton(
                onPressed: () {
                  // Action for the add button
                },
                child: Text(
                  "เพิ่ม",
                  style: GobalStyles.text3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Button Builder
  Widget _buildCustomButton(String label, int uint) {
    bool isSelected = label == selectedLabel;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        height: 100, // Fixed height for the button
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.green
              : Colors.green[100], // Background color for the button
          borderRadius: BorderRadius.circular(8), // Rounded corners
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedLabel = label; // Set the selected button label
              unit = uint;
              totalPrice = price * count * unit;
            });
          },
          child: Text(
            label,
            style: isSelected ? Styles.headerWhite32 : Styles.headerBlack18,
          ),
        ),
      ),
    );
  }
}
