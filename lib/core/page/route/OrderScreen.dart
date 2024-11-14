import 'dart:convert';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/dropdown/DropDownStandarad.dart';
import 'package:_12sale_app/core/components/table/OrderTable.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:_12sale_app/data/models/ProductType.dart';

class Orderscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Orderscreen({
    super.key,
    required this.customerNo,
    required this.customerName,
    required this.status,
  });

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  ProductType? productData;
  String dropdownValue = 'แบรนด์'; // Default value
  int cartItemCount = 0;
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    _loadJson();
    _loadOrdersFromStorage();
    _loadProductType();
  }

  Future<void> _loadProductType() async {
    final String jsonString =
        await rootBundle.loadString('data/product_group.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);

    setState(() {
      productData = ProductType.fromJson(jsonData);
    });
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["order_screen"];
    });
  }

  Future<void> _loadOrdersFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonOrders = prefs.getStringList('orders');

    setState(() {
      if (jsonOrders != null) {
        _orders = jsonOrders
            .map((jsonOrder) => Order.fromJson(jsonDecode(jsonOrder)))
            .toList();
        cartItemCount = _orders.length;
      }
    });
  }

  Map<String, dynamic>? _jsonString;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: " ${_jsonString?['title'] ?? 'Ordering'}",
          icon: Icons.event,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "รหัสร้าน ${widget.customerNo}",
                style: Styles.headerBlack24(context),
              ),
              Text(
                "ร้าน ${widget.customerName}",
                style: Styles.headerBlack24(context),
              ),
              SizedBox(height: screenWidth / 80),
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: productData != null
                          ? BoxShadowCustom(
                              child: DropDownStandard(
                                hintText: 'กลุ่ม',
                                selectedValue: productData!.group.first,
                                items: productData!.group,
                                onChanged: (String? newValue) {},
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: productData != null
                          ? BoxShadowCustom(
                              child: DropDownStandard(
                                hintText: 'แบรนด์',
                                selectedValue: productData!.brand.first,
                                items: productData!.brand,
                                onChanged: (String? newValue) {},
                              ),
                            )
                          : CircularProgressIndicator(),
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
                      child: productData != null
                          ? BoxShadowCustom(
                              child: DropDownStandard(
                                hintText: 'ขนาด',
                                selectedValue: productData!.size.first,
                                items: productData!.size,
                                onChanged: (String? newValue) {},
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: productData != null
                          ? BoxShadowCustom(
                              child: DropDownStandard(
                                hintText: 'รสชาติ',
                                selectedValue: productData!.flavour.first,
                                items: productData!.flavour,
                                onChanged: (String? newValue) {},
                              ),
                            )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth / 80),
              OrderTable(
                customerNo: widget.customerNo,
                customerName: widget.customerName,
                status: widget.status,
              ),
              SizedBox(height: screenWidth / 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Cartbutton(
        count: "${_orders.length}",
        screen: ShoppingCartScreen(
          customerNo: widget.customerNo,
          customerName: widget.customerName,
          status: widget.status,
        ),
      ),
    );
  }
}
