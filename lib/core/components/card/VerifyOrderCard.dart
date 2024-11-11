import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOrderCard extends StatefulWidget {
  final VoidCallback onDetailsPressed;

  const VerifyOrderCard({
    Key? key,
    required this.onDetailsPressed,
  }) : super(key: key);

  @override
  State<VerifyOrderCard> createState() => _VerifyOrderCardState();
}

class _VerifyOrderCardState extends State<VerifyOrderCard> {
  List<Order> _orders = [];

  Future<void> _loadOrdersFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonOrders = prefs.getStringList('orders');
    if (jsonOrders != null) {
      setState(() {
        _orders = jsonOrders
            .map((jsonOrder) => Order.fromJson(jsonDecode(jsonOrder)))
            .toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrdersFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onDetailsPressed,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          // Outer scrollable container
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(_orders.length, (index) {
              final order = _orders[index];
              return Column(
                children: [
                  Text(
                    '${index + 1}. ${order.itemName}',
                    style: Styles.black24(context),
                  ),
                  SizedBox(height: screenWidth / 37),
                  Container(
                    // color: Colors.amber,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ราคา ${order.totalPrice} บาท',
                          style: Styles.grey18(context),
                        ),
                        Text(
                          '${order.count.toStringAsFixed(0)} ${order.unitText}',
                          style: Styles.black18(context),
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey.shade300),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
