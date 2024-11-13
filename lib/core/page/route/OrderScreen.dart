import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/dropdown/DropDownStandarad.dart';
import 'package:_12sale_app/core/components/table/OrderTable.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:_12sale_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class _OrderscreenState extends State<Orderscreen> with RouteAware {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
    _loadOrdersFromStorage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  // Regis
  //ter the observer when the widget is inserted into the widget tree

  // Unregister the observer when the widget is removed from the widget tree
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // @override
  // void didPush() {
  //   print('HomeScreen: didPush');
  // }

  // Called when this route is shown again after another route was popped off
  @override
  void didPopNext() {
    print("Screen is visible again - reloading orders."); // Debugging print
    _loadOrdersFromStorage(); // Reload orders when returning to this screen
  }

  // @override
  // void didPop() {
  //   print('HomeScreen: didPop');
  // }

  @override
  void didUpdateWidget(covariant Orderscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadOrdersFromStorage(); // Reload data when widget is updated
  }

  Map<String, dynamic>? _jsonString;
  String dropdownValue = 'แบรนด์'; // Default value
  int cartItemCount = 0;

  List<Order> _orders = [];

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["order_screen"];
    });
  }

  Future<void> _loadOrdersFromStorage() async {
    print("Loading orders from storage..."); // Debugging print
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonOrders = prefs.getStringList('orders');

    if (jsonOrders != null) {
      setState(() {
        _orders = jsonOrders
            .map((jsonOrder) => Order.fromJson(jsonDecode(jsonOrder)))
            .toList();
        cartItemCount = _orders.length;
      });
      print("Orders loaded: ${_orders.length} items"); // Confirm data loading
    } else {
      print("No orders found in storage."); // If no data is found
    }
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
              Text("รหัสร้าน ${widget.customerNo}",
                  style: Styles.headerBlack24(context)),
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
                      child: DropDownStandard(
                        selectedValue: 'ประเภท',
                        items: const [
                          'ประเภท',
                          'เหตุผล 1',
                          'เหตุผล 2',
                          'อื่นๆ'
                        ],
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: DropDownStandard(
                        selectedValue: 'แบรนด์',
                        items: const [
                          'แบรนด์',
                          'เหตุผล 1',
                          'เหตุผล 2',
                          'อื่นๆ'
                        ],
                        onChanged: (String? newValue) {},
                      ),
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
                      child: DropDownStandard(
                        selectedValue: 'ขนาด',
                        items: const ['ขนาด', 'เหตุผล 1', 'เหตุผล 2', 'อื่นๆ'],
                        onChanged: (String? newValue) {},
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        child: DropDownStandard(
                          selectedValue: 'รสชาติ',
                          items: const [
                            'รสชาติ',
                            'เหตุผล 1',
                            'เหตุผล 2',
                            'อื่นๆ'
                          ],
                          onChanged: (String? newValue) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth / 80),
              // Align(
              //   alignment: Alignment.center,
              //   child: Text(
              //     "${_jsonString?['item_selected'] ?? 'Item Selected'}",
              //     style: Styles.headerBlack24(context),
              //   ),
              // ),
              SizedBox(height: screenWidth / 80),
              OrderTable(
                customerNo: widget.customerNo,
                customerName: widget.customerName,
                status: widget.status,
              ),
              SizedBox(height: screenWidth / 80),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "${_jsonString?['amount'] ?? 'Amount'} 38000.00",
              //     style: Styles.headerBlack24(context),
              //   ),
              // ),
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
