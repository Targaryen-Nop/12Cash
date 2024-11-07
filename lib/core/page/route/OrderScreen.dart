import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/table/OrderTable.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
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

  // Regis
  //ter the observer when the widget is inserted into the widget tree
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  // Unregister the observer when the widget is removed from the widget tree
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when this route is shown again after another route was popped off
  @override
  void didPopNext() {
    print("Screen is visible again - reloading orders."); // Debugging print
    _loadOrdersFromStorage(); // Reload orders when returning to this screen
  }

  @override
  void didUpdateWidget(covariant Orderscreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadOrdersFromStorage(); // Reload data when widget is updated
  }

  Map<String, dynamic>? _jsonString;
  String dropdownValue = 'แบรนด์'; // Default value
  int cartItemCount = 1;
  final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

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
        count: "${cartItemCount}",
        screen: ShoppingCartScreen(
          customerNo: widget.customerNo,
          customerName: widget.customerName,
          status: widget.status,
        ),
      ),
    );
  }
}
