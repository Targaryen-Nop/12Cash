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
import 'package:flutter_debouncer/flutter_debouncer.dart';
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

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<CartList> cartList = [];
  final Debouncer _debouncer = Debouncer();
  final Throttler _throttler = Throttler();

  @override
  void initState() {
    super.initState();
    _getCart();
  }

  Future<void> _getStoreDetail() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();
      var response = await apiService.request(
        endpoint:
            'api/cash/cart/get?type=sale&area=${User.area}&storeId=${widget.storeId}',
        method: 'GET',
      );
    } catch (e) {
      print("Error $e");
    }
  }

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
        setState(() {
          cartList = data.map((item) => CartList.fromJson(item)).toList();
        });
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> _deleteCart(CartList cart, StateSetter setModalState) async {
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

  Future<void> _reduceCart(CartList cart, StateSetter setModalState) async {
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

  Future<void> _addCartDu(CartList cart, StateSetter setModalState) async {
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
                  onPressed: () {},
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
                                "1",
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
                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(100000)} บาท",
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
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "รายการที่สั่ง",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: screenHeight * 0.9,
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 16.0),
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: ListView.builder(
                                                itemCount: cartList.length,
                                                itemBuilder: (context, index) {
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
                                                            child:
                                                                Image.network(
                                                              'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                              width:
                                                                  screenWidth /
                                                                      8,
                                                              height:
                                                                  screenWidth /
                                                                      8,
                                                              fit: BoxFit.cover,
                                                              errorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return const Center(
                                                                  child: Icon(
                                                                    Icons.error,
                                                                    color: Colors
                                                                        .red,
                                                                    size: 50,
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
                                                                          cartList[index]
                                                                              .name,
                                                                          style:
                                                                              Styles.black16(context),
                                                                          softWrap:
                                                                              true,
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow.visible,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
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
                                                                            onPressed:
                                                                                () async {
                                                                              // setModalState(() {
                                                                              //   if (cartList[index].qty > 1) {
                                                                              //     cartList[index].qty--;
                                                                              //   }
                                                                              // });
                                                                              // await _reduceCart(cartList[index], setModalState);
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: const CircleBorder(
                                                                                side: BorderSide(color: Colors.grey, width: 1),
                                                                              ), // ✅ Makes the button circular
                                                                              padding: const EdgeInsets.all(8),
                                                                              backgroundColor: Colors.white, // Button color
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.remove,
                                                                              size: 24,
                                                                              color: Colors.grey,
                                                                            ), // Example
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(4),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Colors.grey,
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(16),
                                                                            ),
                                                                            width:
                                                                                75,
                                                                            child:
                                                                                Text(
                                                                              '${cartList[index].qty.toStringAsFixed(0)}',
                                                                              textAlign: TextAlign.center,
                                                                              style: Styles.black18(
                                                                                context,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              // await _addCartDu(cartList[index], setModalState);

                                                                              // setModalState(() {
                                                                              //   cartList[index].qty++;
                                                                              // });
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: const CircleBorder(
                                                                                side: BorderSide(color: Colors.grey, width: 1),
                                                                              ), // ✅ Makes the button circular
                                                                              padding: const EdgeInsets.all(8),
                                                                              backgroundColor: Colors.white, // Button color
                                                                            ),
                                                                            child:
                                                                                const Icon(
                                                                              Icons.add,
                                                                              size: 24,
                                                                              color: Colors.grey,
                                                                            ), // Example
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                              // await _deleteCart(cartList[index], setModalState);

                                                                              // setModalState(
                                                                              //   () {
                                                                              //     cartList.removeWhere((item) => (item.id == cartList[index].id && item.unit == cartList[index].unit));
                                                                              //   },
                                                                              // );
                                                                              // await _getTotalCart(setModalState);

                                                                              // if (cartList.length == 0) {
                                                                              //   Navigator.pop(context);
                                                                              // }
                                                                            },
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: const CircleBorder(
                                                                                side: BorderSide(color: Colors.red, width: 1),
                                                                              ),
                                                                              padding: const EdgeInsets.all(8),
                                                                              backgroundColor: Colors.white, // Button color
                                                                            ),
                                                                            child:
                                                                                const Icon(
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
                                                        color: Colors.grey[200],
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

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "รายการโปรโมชั่น",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Expanded(
                                                child: ListView.builder(
                                              itemCount: cartList.length,
                                              itemBuilder: (context, index) {
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
                                                                  .circular(8),
                                                          child: Image.network(
                                                            'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                            width:
                                                                screenWidth / 8,
                                                            height:
                                                                screenWidth / 8,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return const Center(
                                                                child: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50,
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
                                                                    .all(16.0),
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
                                                                        cartList[index]
                                                                            .name,
                                                                        style: Styles.black16(
                                                                            context),
                                                                        softWrap:
                                                                            true,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'id : ${cartList[index].id}',
                                                                      style: Styles
                                                                          .black16(
                                                                              context),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'จำนวน : ${cartList[index].qty.toStringAsFixed(0)} ${cartList[index].unit}',
                                                                      style: Styles
                                                                          .black16(
                                                                              context),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      'ราคา : ${cartList[index].price}',
                                                                      style: Styles
                                                                          .black16(
                                                                              context),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            color: Colors.red,
                                                            width: 20,
                                                            height: 100,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[200],
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ราคาสินค้ารวม",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(10000)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ราคาสินค้ารวมก่อนหักภาษี",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(10000)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ภาษี (VAT)",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(10000)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ส่วนลดสินค้า",
                                          style: Styles.grey18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(100)} บาท",
                                          style: Styles.grey18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ส่วนลด",
                                          style: Styles.red18(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(-100)} บาท",
                                          style: Styles.red18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "ราคารวมสุทธิ",
                                          style: Styles.green24(context),
                                        ),
                                        Text(
                                          "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(1000)} บาท",
                                          style: Styles.green24(context),
                                        )
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "คูปอง",
                                          style: Styles.black18(context),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "ใช้คูปอง ",
                                              style: Styles.grey18(context),
                                            ),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              color: Colors.black,
                                              size: 20,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
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
