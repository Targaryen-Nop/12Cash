import 'dart:convert';

import 'package:_12sale_app/core/page/route/OrderDetailScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartTable extends StatefulWidget {
  const CartTable({super.key});

  @override
  State<CartTable> createState() => _CartTableState();
}

class _CartTableState extends State<CartTable> {
  Map<String, dynamic>? _jsonString;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadJson();
    _loadOrdersFromStorage();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)["cart_table"];
    });
  }

  Future<void> _loadOrdersFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the JSON string list from SharedPreferences
    List<String>? jsonOrders = prefs.getStringList('orders');

    if (jsonOrders != null) {
      setState(() {
        // Decode each JSON string and convert it to an Order object
        _orders = jsonOrders
            .map((jsonOrder) => Order.fromJson(jsonDecode(jsonOrder)))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        height: screenWidth / 1.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header
            Container(
              decoration: const BoxDecoration(
                color: GobalStyles.backgroundTableColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  _buildHeaderCellName(_jsonString?['item_name'] ?? 'Item Name',
                      screenWidth / 2.5),
                  _buildHeaderCell(_jsonString?['qty'] ?? 'QTY'),
                  _buildHeaderCell(_jsonString?['amount'] ?? 'Amount'),
                  _buildHeaderCellIcon('', 50),
                ],
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: List.generate(_orders.length, (index) {
                    final order = _orders[index];
                    return _buildDataRow(
                        order,
                        GobalStyles.successBackgroundColor,
                        GobalStyles.successTextColor,
                        index,
                        context);
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Updated to use Order object
  Widget _buildDataRow(Order order, Color? bgColor, Color? textColor, int index,
      BuildContext context) {
    // Alternate row background color
    Color rowBgColor =
        (index % 2 == 0) ? Colors.white : GobalStyles.backgroundTableColor;
    double screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetail(
                itemCode: order.itemName,
                itemName: order.itemName,
                price: order.totalPrice.toStringAsFixed(2)),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: rowBgColor,
        ),
        child: Row(
          children: [
            _buildTableCellName(order.itemName, screenWidth / 2),
            Expanded(child: _buildTableCell(order.count.toStringAsFixed(2))),
            Expanded(
                child: _buildTableCell(order.totalPrice.toStringAsFixed(2))),
            _buildStatusCell(
                order.totalPrice.toStringAsFixed(2), bgColor, textColor, 50),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCell(
      String price, Color? bgColor, Color? textColor, double? width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Container(
        width: 50,
        margin: EdgeInsets.all(5),
        decoration: const BoxDecoration(
          color: Colors.red,
        ),
        alignment: Alignment.center,
        child: Icon(Icons.close, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildTableCellName(String text, double width) {
    return Container(
      alignment: Alignment.centerLeft,
      width: width,
      padding: EdgeInsets.all(8),
      child: Text(text, style: Styles.black18(context)),
    );
  }

  Widget _buildTableCell(String text) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(8),
      child: Text(text, style: Styles.black18(context)),
    );
  }

  Widget _buildHeaderCellName(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: Styles.grey18(context),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Expanded(
      child: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: Styles.grey18(context),
        ),
      ),
    );
  }

  Widget _buildHeaderCellIcon(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.all(8),
      child: Text(
        text,
        style: Styles.grey18(context),
      ),
    );
  }
}
