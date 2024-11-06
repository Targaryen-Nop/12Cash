import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/TossAnimation.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Order.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  final String itemCode;
  final String itemName;
  final String price;

  const OrderDetail({
    super.key,
    required this.itemCode,
    required this.itemName,
    required this.price,
  });

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _jsonString;
  String selectedLabel = "";
  double count = 1.0; // Initialized with 1
  double unit = 1.0;
  double qtyConvert = 0;
  late double price = 15.0;
  late double qty;
  late double totalPrice;
  List<Order> _orders = []; // List to hold orders as Order objects
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late AnimationController _controller;
  late Animation<Offset> _animation;
  final GlobalKey _cartKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isAnimating = false;
  final ScrollController _animatedListController = ScrollController();
  final ScrollController _listViewController = ScrollController();

  // ----------------------------Animations-----------------------------
  int _cartItemCount = 0;
  bool _isAnimating2 = false;
  late AnimationController _controller2;
  late Animation<Offset> _positionAnimation;
  late Animation<double> _scaleAnimation;
  final GlobalKey _cartKey2 = GlobalKey();
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    price = double.parse(widget.price);
    qty = double.parse(widget.price);
    totalPrice = price; // Initialize the totalPrice
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    //-------------------------------------------------

    _controller2 = AnimationController(
      duration: Duration(milliseconds: 700),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeOut),
    );
    _controller2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimating2 = false;
          _cartItemCount++;
        });
        _controller2.reset();
      }
    });
// ------------------------------------------------------
    _loadJson();
    _loadOrdersFromStorage();
  }

  void _startAddToCartAnimationToss() {
    final buttonPosition = _getWidgetPosition(_buttonKey);
    final cartPosition = _getWidgetPosition(_cartKey);

    if (buttonPosition != null && cartPosition != null) {
      final dx = cartPosition.dx - buttonPosition.dx;
      final dy = cartPosition.dy - buttonPosition.dy;

      setState(() {
        _positionAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(dx, dy),
        ).animate(
            CurvedAnimation(parent: _controller2, curve: Curves.easeInOut));
        _isAnimating = true;
      });

      _controller2.forward();
    }
  }

  Offset? _getWidgetPositionToss(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero);
  }

  // Function to add a new order
  void _addOrder() {
    if (qty >= count * unit && selectedLabel != "") {
      final newOrder = Order(
        textShow:
            "${_orders.length + 1}. ${widget.itemName} ${count} ${selectedLabel} ราคา ${totalPrice.toStringAsFixed(2)}",
        itemName: widget.itemName,
        // itemCode: widget.itemCode,
        count: count,
        unit: unit,
        pricePerUnit: price,
      );
      _orders.insert(0, newOrder); // Add order to the beginning of the list
      _listKey.currentState?.insertItem(0); // Trigger animation at index 0

      setState(() {
        qty = qty - (count * unit);
      });
      _saveOrdersToStorage(); // Save the updated list to storage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('จํานวนสินค้าไม่เพียงพอ'),
        ),
      );
    }
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["order_detail_screen"];
    });
  }

  Future<void> _clearOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('orders'); // Clear orders from SharedPreferences

    setState(() {
      _orders.clear(); // Clear orders in the UI
    });
  }

  void _startAddToCartAnimation(BuildContext context, Offset startPosition) {
    if (_isAnimating) return;

    final cartPosition = _getWidgetPosition(_cartKey);
    if (cartPosition == null) return;

    final endPosition = cartPosition - startPosition;
    _animation = Tween<Offset>(begin: Offset.zero, end: endPosition).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _overlayEntry = OverlayEntry(
      builder: (context) => TossAnimationOverlay(
        animation: _animation,
        startPosition: startPosition,
        onComplete: () {
          _overlayEntry?.remove();
          setState(() {
            _isAnimating = false;
          });
        },
      ),
    );

    setState(() {
      _isAnimating = true;
    });

    Overlay.of(context)?.insert(_overlayEntry!);
    _controller.forward(from: 0);
  }

  Offset? _getWidgetPosition(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero);
  }

  // Function to delete an order with animation
  void _deleteOrder(int index) async {
    final removedOrder = _orders[index];
    _orders.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildOrderItem(removedOrder, animation, index),
    );
    setState(() {
      qty = qty + (removedOrder.count * removedOrder.unit);
    });
    await _saveOrdersToStorage();
  }

  Future<void> _saveOrdersToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert the list of Order objects to a list of maps (JSON)
    List<String> jsonOrders =
        _orders.map((order) => jsonEncode(order.toJson())).toList();

    // Save the JSON string list to SharedPreferences
    await prefs.setStringList('orders', jsonOrders);
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
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _animatedListController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppbarCustom(
          title: " ${_jsonString?["title"] ?? 'Order Detail'}",
          icon: Icons.inventory_2_outlined,
        ),
      ),
      body: Container(
        color: Colors.grey[100],
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Product Info Section
              Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Container(
                        height: screenWidth / 3,
                        width: screenWidth / 3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/12TradingLogo.png'),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("รหัสสินค้า ${widget.itemCode}",
                              style: Styles.black18(context)),
                          Text(widget.itemName, style: Styles.black18(context)),
                          Text("จำนวนทั้งหมด $qty",
                              style: Styles.black18(context)),
                          Text("ราคา $price", style: Styles.black18(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth / 50),
              // Unit Selection Buttons
              Row(
                children: [
                  _buildCustomButton("หีบ", 24.00),
                  _buildCustomButton("กล่อง", 12.00),
                  _buildCustomButton("ชิ้น", 1.00),
                ],
              ),
              SizedBox(height: screenWidth / 50),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text("โปรโมทชั่น",
                                  style: Styles.black18(context)),

                              // Text("ราคา", style: Styles.black18(context)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("จํานวน", style: Styles.black18(context)),
                              Text("ราคา", style: Styles.black18(context)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$count", style: Styles.black18(context)),
                              Text("$totalPrice",
                                  style: Styles.black18(context)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$count", style: Styles.black18(context)),
                              Text("$totalPrice",
                                  style: Styles.black18(context)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$count", style: Styles.black18(context)),
                              Text("$totalPrice",
                                  style: Styles.black18(context)),
                            ],
                          ),
                          Row(
                            children: [
                              Text("$count", style: Styles.black18(context)),
                              Text("$totalPrice",
                                  style: Styles.black18(context)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenWidth / 50),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Scrollbar(
                    controller: _animatedListController,
                    thumbVisibility: true,
                    child: Column(
                      children: [
                        Expanded(
                          child: AnimatedList(
                            key: _listKey,
                            controller: _animatedListController,
                            initialItemCount: _orders.length,
                            itemBuilder: (context, index, animation) {
                              return _buildOrderItem(
                                  _orders[index], animation, index);
                            },
                          ),
                        ),
                        // Expanded(
                        //   child: Scrollbar(
                        //     controller:
                        //         _listViewController, // Scrollbar attached to ListView
                        //     thumbVisibility: true,
                        //     child: ListView.builder(
                        //       controller: _listViewController,
                        //       itemCount: _orders.length,
                        //       itemBuilder: (context, index) {
                        //         return Text(_orders[index].textShow);
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenWidth / 50),
              // Bottom Add Button
              Container(
                margin: const EdgeInsets.all(8.0),
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() {
                              if (count > 0) {
                                count--;
                                totalPrice = price * count * unit;
                              }
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              width: screenWidth / 15,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(180),
                              ),
                              child: Icon(
                                Icons.remove,
                                color: Colors.white,
                                size: screenWidth / 15,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            width: screenWidth / 8,
                            alignment: Alignment.center,
                            child: Text(
                              '${count.toStringAsFixed(0)}',
                              style: Styles.black18(context),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() {
                              count++;
                              totalPrice = price * count * unit;
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              width: screenWidth / 15,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(180),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: screenWidth / 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Styles.successButtonColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Stack(children: [
                          TextButton(
                            onPressed: _addOrder,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "เพิ่ม",
                                  style: Styles.headerWhite24(context),
                                ),
                                Text(
                                  '${totalPrice.toStringAsFixed(2)}',
                                  style: Styles.headerWhite24(context),
                                ),
                              ],
                            ),
                          ),
                          if (_cartItemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 20,
                                  minHeight: 20,
                                ),
                                child: Text(
                                  '$_cartItemCount',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Button Builder
  Widget _buildCustomButton(String label, double uint) {
    bool isSelected = label == selectedLabel;
    qtyConvert = (qty / unit);
    // print("qtyConvert ${qtyConvert.toStringAsFixed(0)}");
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.green[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextButton(
          onPressed: () {
            setState(() {
              selectedLabel = label;
              unit = uint;

              totalPrice = price * count * unit;
            });
          },
          child: Text(
            isSelected
                ? '${qtyConvert.floor().toStringAsFixed(0)} $label'
                : label,
            style: isSelected
                ? Styles.headerWhite32(context)
                : Styles.headerBlack32(context),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderItem2(Order order, int index) {
    return ListTile(
      title: Text(
        order.textShow,
        style: TextStyle(fontSize: 18, color: Colors.black),
      ),
      tileColor: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.1),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _deleteOrder(index),
      ),
    );
  }

  // Function to build an animated order item
  Widget _buildOrderItem(Order order, Animation<double> animation, int index) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: ListTile(
          title: Text(
            order.textShow,
            style: Styles.black18(context),
          ),
          tileColor: const Color.fromARGB(255, 3, 3, 3).withOpacity(0.1),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _deleteOrder(index),
          ),
        ),
      ),
    );
  }
}
