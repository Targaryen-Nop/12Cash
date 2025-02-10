import 'dart:io';
import 'dart:ui';
import 'package:_12sale_app/core/page/order/OrderDetail.dart';
import 'package:_12sale_app/core/page/route/OrderDetailScreen.dart';
import 'package:_12sale_app/data/models/order/Promotion.dart';
import 'package:_12sale_app/main.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:image/image.dart' as img;
import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/page/order/CheckoutScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/models/order/Cart.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:print_bluetooth_thermal/post_code.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal_windows.dart';
import 'package:toastification/toastification.dart';

class CreateOrderScreen extends StatefulWidget {
  final String? storeName;
  final String? storeId;
  final String? storeAddress;
  CreateOrderScreen({
    super.key,
    required this.storeId,
    required this.storeName,
    required this.storeAddress,
  });

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with RouteAware {
  final ScrollController _scrollController = ScrollController();
  double subtotal = 0;
  double discount = 0;
  double discountProduct = 0;
  double vat = 0;
  double totalExVat = 0;
  double total = 0;

  @override
  void initState() {
    super.initState();
    _getCart();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Register this screen as a route-aware widget
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      // Only subscribe if the route is a P ageRoute
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // setState(() {
    //   _loadingRouteVisit = true;
    // });
    // Called when the screen is popped back to
    _getCart();
  }

  @override
  void dispose() {
    // Unsubscribe when the widget is disposed
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    super.dispose();
  }

  List<CartList> cartList = [];
  List<PromotionList> promotionList = [];
  final Debouncer _debouncer = Debouncer();
  final Throttler _throttler = Throttler();

  Future<void> _getCart() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();
      var response = await apiService.request(
        endpoint:
            'api/cash/cart/get?type=sale&area=${User.area}&storeId=${widget.storeId}',
        method: 'GET',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data']['listProduct'];
        final List<dynamic> data2 = response.data['data']['listPromotion'];
        setState(() {
          cartList = data.map((item) => CartList.fromJson(item)).toList();
          promotionList =
              data2.map((item) => PromotionList.fromJson(item)).toList();
          subtotal = response.data['data']['subtotal'].toDouble();
          discount = response.data['data']['discount'].toDouble();
          discountProduct = response.data['data']['discountProduct'].toDouble();
          vat = response.data['data']['vat'].toDouble();
          totalExVat = response.data['data']['totalExVat'].toDouble();
          total = response.data['data']['total'].toDouble();
        });
        // Map cartList to receiptData["items"]
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> _deleteCart(CartList cart) async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();
      var response = await apiService.request(
        endpoint: 'api/cash/cart/delete',
        method: 'POST',
        body: {
          "type": "sale",
          "area": "${User.area}",
          "storeId": "${widget.storeId}",
          "id": "${cart.id}",
          "unit": "${cart.unit}"
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          // totalCart = response.data['data']['total'].toDouble();
        });
        toastification.show(
          autoCloseDuration: const Duration(seconds: 5),
          context: context,
          primaryColor: Colors.green,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          title: Text(
            "ลบข้อมูลสำเร็จ",
            style: Styles.green18(context),
          ),
        );
      }
    } catch (e) {}
  }

  Future<void> _reduceCart(CartList cart) async {
    const duration = Duration(seconds: 1);
    try {
      _debouncer.debounce(
        duration: duration,
        onDebounce: () async {
          ApiService apiService = ApiService();
          await apiService.init();
          var response = await apiService.request(
            endpoint: 'api/cash/cart/reduce',
            method: 'PATCH',
            body: {
              "type": "sale",
              "area": "${User.area}",
              "storeId": "${widget.storeId}",
              "id": "${cart.id}",
              "qty": cart.qty,
              "unit": "${cart.unit}"
            },
          );
          if (response.statusCode == 200) {
            setState(() {
              // totalCart = response.data['data']['total'].toDouble();
            });
            toastification.show(
              autoCloseDuration: const Duration(seconds: 5),
              context: context,
              primaryColor: Colors.green,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: Text(
                "แก้ไขข้อมูลสำเร็จ",
                style: Styles.green18(context),
              ),
            );
            // await _getTotalCart(setModalState);
          }
        },
      );
    } catch (e) {
      toastification.show(
        autoCloseDuration: const Duration(seconds: 5),
        context: context,
        primaryColor: Colors.red,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: Text(
          "เกิดข้อผิดพลาด $e",
          style: Styles.red18(context),
        ),
      );
      print("Error $e");
    }
  }

  Future<void> _addCartDu(CartList cart) async {
    const duration = Duration(seconds: 1);
    try {
      _debouncer.debounce(
        duration: duration,
        onDebounce: () async {
          ApiService apiService = ApiService();
          await apiService.init();
          var response = await apiService.request(
            endpoint: 'api/cash/cart/add',
            method: 'POST',
            body: {
              "type": "sale",
              "area": "${User.area}",
              "storeId": "${widget.storeId}",
              "id": "${cart.id}",
              "qty": cart.qty,
              "unit": "${cart.unit}"
            },
          );
          print("Response add Cart: ${response.data['data']['listProduct']}");
          if (response.statusCode == 200) {
            toastification.show(
              autoCloseDuration: const Duration(seconds: 5),
              context: context,
              primaryColor: Colors.green,
              type: ToastificationType.success,
              style: ToastificationStyle.flatColored,
              title: Text(
                "เพิ่มลงในตะกร้าสําเร็จ",
                style: Styles.green18(context),
              ),
            );
            // await _getTotalCart(setModalState);

            // setState(() {
            //   totalCart = response.data['data']['total'].toDouble();
            // });
          }
        },
      );
    } catch (e) {
      print("Error $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: "${widget.storeName}",
        ),
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.white),
                              child: Text(
                                "${cartList.length}",
                                style: Styles.headerPirmary18(context),
                              ),
                            ),
                            Text(
                              " สั่งซื้อ",
                              style: Styles.headerWhite18(context),
                            ),
                          ],
                        ),
                        Text(
                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(total)} บาท",
                          style: Styles.headerWhite18(context),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BoxShadowCustom(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            // color: Colors.amber,
                            height: viewportConstraints.maxHeight * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.storeId}",
                                          style: Styles.black24(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ที่อยู่การจัดส่ง",
                                          style: Styles.black18(context),
                                        ),
                                        Text(
                                          "แก้ไขที่อยู่",
                                          style: Styles.pirmary18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                elevation: 0, // Disable shadow
                                                shadowColor: Colors
                                                    .transparent, // Ensure no shadow color
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .zero, // No rounded corners
                                                  side: BorderSide
                                                      .none, // Remove border
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.black,
                                                          size: 30,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            " ${widget.storeAddress}",
                                                            style:
                                                                Styles.grey18(
                                                                    context),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.black,
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Expanded(
                                    //       child: Text(
                                    //         "ที่อยู่",
                                    //         style: Styles.black18(context),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "รายการที่สั่ง",
                                          style: Styles.black18(context),
                                        ),
                                        Text(
                                          "จำนวน ${cartList.length} รายการ",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BoxShadowCustom(
                                          child: Container(
                                            height: screenHeight * 0.9,
                                            // color: Colors.red,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16.0,
                                                      horizontal: 16.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: ListView.builder(
                                                    itemCount: cartList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image
                                                                    .network(
                                                                  'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                                  width:
                                                                      screenWidth /
                                                                          8,
                                                                  height:
                                                                      screenWidth /
                                                                          8,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            50,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              cartList[index].name,
                                                                              style: Styles.black16(context),
                                                                              softWrap: true,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.visible,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'id : ${cartList[index].id}',
                                                                                    style: Styles.black16(context),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'จำนวน : ${cartList[index].qty.toStringAsFixed(0)} ${cartList[index].unit}',
                                                                                    style: Styles.black16(context),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    'ราคา : ${cartList[index].price}',
                                                                                    style: Styles.black16(context),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  setState(() {
                                                                                    if (cartList[index].qty > 1) {
                                                                                      cartList[index].qty--;
                                                                                    }
                                                                                  });
                                                                                  await _reduceCart(cartList[index]);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  shape: const CircleBorder(
                                                                                    side: BorderSide(color: Colors.grey, width: 1),
                                                                                  ), // ✅ Makes the button circular
                                                                                  padding: const EdgeInsets.all(8),
                                                                                  backgroundColor: Colors.white, // Button color
                                                                                ),
                                                                                child: const Icon(
                                                                                  Icons.remove,
                                                                                  size: 24,
                                                                                  color: Colors.grey,
                                                                                ), // Example
                                                                              ),
                                                                              Container(
                                                                                padding: EdgeInsets.all(4),
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(
                                                                                    color: Colors.grey,
                                                                                    width: 1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(16),
                                                                                ),
                                                                                width: 75,
                                                                                child: Text(
                                                                                  '${cartList[index].qty.toStringAsFixed(0)}',
                                                                                  textAlign: TextAlign.center,
                                                                                  style: Styles.black18(
                                                                                    context,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  await _addCartDu(cartList[index]);

                                                                                  setState(() {
                                                                                    cartList[index].qty++;
                                                                                  });
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  shape: const CircleBorder(
                                                                                    side: BorderSide(color: Colors.grey, width: 1),
                                                                                  ), // ✅ Makes the button circular
                                                                                  padding: const EdgeInsets.all(8),
                                                                                  backgroundColor: Colors.white, // Button color
                                                                                ),
                                                                                child: const Icon(
                                                                                  Icons.add,
                                                                                  size: 24,
                                                                                  color: Colors.grey,
                                                                                ), // Example
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  await _deleteCart(cartList[index]);

                                                                                  setState(
                                                                                    () {
                                                                                      cartList.removeWhere((item) => (item.id == cartList[index].id && item.unit == cartList[index].unit));
                                                                                    },
                                                                                  );
                                                                                  // await _getTotalCart(setModalState);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  shape: const CircleBorder(
                                                                                    side: BorderSide(color: Colors.red, width: 1),
                                                                                  ),
                                                                                  padding: const EdgeInsets.all(8),
                                                                                  backgroundColor: Colors.white, // Button color
                                                                                ),
                                                                                child: const Icon(
                                                                                  Icons.delete,
                                                                                  size: 24,
                                                                                  color: Colors.red,
                                                                                ), // Example
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              // Container(
                                                              //   color: Colors.red,
                                                              //   width: 50,
                                                              //   height: 100,
                                                              //   child: Center(
                                                              //     child: Icon(
                                                              //       Icons.delete,
                                                              //       color: Colors.white,
                                                              //       size: 25,
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[200],
                                                            thickness: 1,
                                                            indent: 16,
                                                            endIndent: 16,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "รายการโปรโมชั่น",
                                          style: Styles.black18(context),
                                        ),
                                        Text(
                                          "จำนวน ${cartList.length} รายการ",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            height: viewportConstraints.maxHeight * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: BoxShadowCustom(
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Expanded(
                                                      child: ListView.builder(
                                                    itemCount:
                                                        promotionList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                child: Image
                                                                    .network(
                                                                  'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                                  width:
                                                                      screenWidth /
                                                                          8,
                                                                  height:
                                                                      screenWidth /
                                                                          8,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder:
                                                                      (context,
                                                                          error,
                                                                          stackTrace) {
                                                                    return const Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .red,
                                                                        size:
                                                                            50,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 3,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          16.0),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Text(
                                                                              promotionList[index].proName,
                                                                              style: Styles.black16(context),
                                                                              softWrap: true,
                                                                              maxLines: 2,
                                                                              overflow: TextOverflow.visible,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'id : ${promotionList[index].proId}',
                                                                            style:
                                                                                Styles.black16(context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Text(
                                                                            'จำนวน : ${promotionList[index].qty.toStringAsFixed(0)} ${cartList[index].unit}',
                                                                            style:
                                                                                Styles.black16(context),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      // Row(
                                                                      //   children: [
                                                                      //     Text(
                                                                      //       'ราคา : ${promotionList[index].price}',
                                                                      //       style:
                                                                      //           Styles.black16(context),
                                                                      //     ),
                                                                      //   ],
                                                                      // ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(
                                                                  color: Colors
                                                                      .red,
                                                                  width: 20,
                                                                  height: 100,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Divider(
                                                            color: Colors
                                                                .grey[200],
                                                            thickness: 1,
                                                            indent: 16,
                                                            endIndent: 16,
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "รวมมูลค่าสินค้า",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(subtotal)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       "ส่วนลด",
                                    //       style: Styles.red18(context),
                                    //     ),
                                    //     Text(
                                    //       "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(-10000)} บาท",
                                    //       style: Styles.red18(context),
                                    //     )
                                    //   ],
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ภาษีมูลค่าเพิ่ม 7% (VAT)",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(vat)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "รวมมูลค่าสินค้าก่อนหักภาษี",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(totalExVat)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ส่วนลดท้ายบิล",
                                          style: Styles.red18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(discount)} บาท",
                                          style: Styles.red18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ส่วนลดสินค้า",
                                          style: Styles.red18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(discountProduct)} บาท",
                                          style: Styles.red18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "จำนวนเงินรวมสุทธิ",
                                          style: Styles.green24(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(total)} บาท",
                                          style: Styles.green24(context),
                                        )
                                      ],
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       "คูปอง",
                                    //       style: Styles.black18(context),
                                    //     ),
                                    //     Row(
                                    //       children: [
                                    //         Text(
                                    //           "ใช้คูปอง ",
                                    //           style: Styles.grey18(context),
                                    //         ),
                                    //         Icon(
                                    //           Icons.arrow_forward_ios_rounded,
                                    //           color: Colors.black,
                                    //           size: 20,
                                    //         )
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          "ชำระเงินโดย",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                elevation: 0, // Disable shadow
                                                shadowColor: Colors
                                                    .transparent, // Ensure no shadow color
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .zero, // No rounded corners
                                                  side: BorderSide
                                                      .none, // Remove border
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                          width:
                                                              screenWidth / 15,
                                                          height:
                                                              screenWidth / 15,
                                                          fit: BoxFit.cover,
                                                          errorBuilder:
                                                              (context, error,
                                                                  stackTrace) {
                                                            return const Center(
                                                              child: Icon(
                                                                Icons.error,
                                                                color:
                                                                    Colors.red,
                                                                size: 50,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Text(
                                                        " QR พร้อมเพย์",
                                                        style: Styles.grey18(
                                                            context),
                                                      )
                                                    ],
                                                  ),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    color: Colors.black,
                                                    size: 20,
                                                  )
                                                ],
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CheckOutScreen(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
