import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/table/OrderTable.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Orderscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Orderscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  Map<String, dynamic>? _jsonString;
  String dropdownValue = 'แบรนด์'; // Default value
  int cartItemCount = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["order_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " ${_jsonString?['title'] ?? 'Ordering'}",
            icon: Icons.event),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        // color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("รหัสร้าน 10334587", style: Styles.headerBlack24(context)),
              Text(
                "ร้าน เจริญพรค้าขาย",
                style: Styles.headerBlack24(context),
              ),
              SizedBox(height: screenWidth / 80),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300], // Light grey background
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                            borderSide: BorderSide.none, // Remove border
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Padding for the dropdown
                        ),
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 25,
                        ), // Icon on the right (chevron)
                        style: const TextStyle(
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8), // Padding for the dropdown
                      ),
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 25,
                      ), // Icon on the right (chevron)
                      style: const TextStyle(
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
                      padding: const EdgeInsets.only(right: 10),
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300], // Light grey background
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(5), // Rounded corners
                            borderSide: BorderSide.none, // Remove border
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Padding for the dropdown
                        ),
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.chevron_left,
                          size: 25,
                        ), // Icon on the right (chevron)
                        style: const TextStyle(
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8), // Padding for the dropdown
                      ),
                      value: dropdownValue,
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 25,
                      ), // Icon on the right (chevron)
                      style: const TextStyle(
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
                  "${_jsonString?['item_selected'] ?? 'Item Selected'}",
                  style: Styles.headerBlack24(context),
                ),
              ),
              SizedBox(height: screenWidth / 80),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const OrderTable(),
              ),
              SizedBox(height: screenWidth / 80),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${_jsonString?['amount'] ?? 'Amount'} 38000.00",
                  style: Styles.headerBlack24(context),
                ),
              ),
            ],
          ),
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
