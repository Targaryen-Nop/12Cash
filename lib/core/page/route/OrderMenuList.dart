import 'dart:async';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/card/OrderMenuListCard.dart';
import 'package:_12sale_app/core/components/card/OrderMenuListVerticalCard.dart';
import 'package:_12sale_app/core/components/search/ProductSearch.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/models/order/Product.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:_12sale_app/data/service/throttler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderMenuList extends StatefulWidget {
  const OrderMenuList({super.key});

  @override
  State<OrderMenuList> createState() => _OrderMenuListState();
}

class _OrderMenuListState extends State<OrderMenuList> {
  final Throttler throttler = Throttler(delay: Duration(seconds: 5));
  List<Product> productList = [];
  bool _loadingProduct = true;

  List<String> groupList = [];
  List<String> selectedGroups = [];

  List<String> brandList = [];
  List<String> selectedBrands = [];

  List<String> sizeList = [];
  List<String> selectedSizes = [];

  List<String> flavourList = [];
  List<String> selectedFlavours = [];

  bool _isGridView = false;

  double count = 1;
  double price = 0;
  double total = 0.00;
  String selectedSize = "";

  @override
  void initState() {
    super.initState();
    _getFliter();
    _getProduct();
  }

  Future<void> _getProduct() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();

      var response = await apiService.request(
        endpoint: 'api/cash/product/get',
        method: 'POST',
        body: {
          "type": "sale",
          "group": selectedGroups,
          "brand": selectedBrands,
          "size": selectedSize,
          "flavour": selectedFlavours
        },
      );
      print("Response: $response");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        productList = data.map((item) => Product.fromJson(item)).toList();
        print("productList $productList");
        if (mounted) {
          setState(() {
            productList = data.map((item) => Product.fromJson(item)).toList();
          });
          context.loaderOverlay.hide();
        }
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _loadingProduct = false;
            });
          }
        });
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> _getFliter() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'POST',
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataGroup = response.data['data']['group'];
      // final List<dynamic> dataBrand = response.data['data'][0]['brand'];
      // final List<dynamic> dataSize = response.data['data'][0]['size'];
      // final List<dynamic> dataFlavour = response.data['data'][0]['flavour'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(dataGroup);
          // brandList = List<String>.from(dataBrand);
          // sizeList = List<String>.from(dataSize);
          // flavourList = List<String>.from(dataFlavour);
        });
      }
      // Timer(const Duration(milliseconds: 500), () {
      //   if (mounted) {
      //     setState(() {
      //       _loadingAllStore = false;
      //     });
      //   }
      // });
      print("groupList: $groupList");
      // print("listStore: ${data.length}");
    }
  }

  Future<void> _getFliterGroup() async {
    ApiService apiService = ApiService();
    await apiService.init();
    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'POST',
      body: {
        "group": selectedGroups,
        "brand": selectedBrands,
        "size": selectedSize,
        "flavour": selectedFlavours,
      },
    );
    setState(() {
      selectedBrands = [];
      selectedSizes = [];
      selectedFlavours = [];
      brandList = [];
      sizeList = [];
      flavourList = [];
    });
    if (response.statusCode == 200) {
      final List<dynamic> dataBrand = response.data['data']['brand'];
      final List<dynamic> dataSize = response.data['data']['size'];
      final List<dynamic> dataFlavour = response.data['data']['flavour'];
      if (mounted) {
        setState(() {
          brandList = List<String>.from(dataBrand);
          sizeList = List<String>.from(dataSize);
          flavourList = List<String>.from(dataFlavour);
        });
      }
    }
    if (selectedGroups.length == 0) {
      setState(() {
        selectedBrands = [];
        selectedSizes = [];
        selectedFlavours = [];
        brandList = [];
        sizeList = [];
        flavourList = [];
      });
    }
  }

  Future<void> _getFliterBrand() async {
    ApiService apiService = ApiService();
    await apiService.init();
    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'POST',
      body: {
        "group": selectedGroups,
        "brand": selectedBrands,
        "size": selectedSize,
        "flavour": selectedFlavours,
      },
    );
    setState(() {
      selectedSizes = [];
      selectedFlavours = [];
      sizeList = [];
      flavourList = [];
    });

    if (response.statusCode == 200) {
      final List<dynamic> dataSize = response.data['data']['size'];
      final List<dynamic> dataFlavour = response.data['data']['flavour'];
      if (mounted) {
        setState(() {
          sizeList = List<String>.from(dataSize);
          flavourList = List<String>.from(dataFlavour);
        });
      }
    }
    // _getProduct();
  }

  Future<void> _getFliterSize() async {
    ApiService apiService = ApiService();
    await apiService.init();
    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'POST',
      body: {
        "group": selectedGroups,
        "brand": selectedBrands,
        "size": selectedSize,
        "flavour": selectedFlavours,
      },
    );
    setState(() {
      selectedFlavours = [];
      flavourList = [];
    });

    if (response.statusCode == 200) {
      final List<dynamic> dataFlavour = response.data['data']['flavour'];
      if (mounted) {
        setState(() {
          flavourList = List<String>.from(dataFlavour);
        });
      }
    }
    // _getProduct();
  }

  Future<void> _clearFilter() async {
    setState(() {
      selectedBrands = [];
      selectedGroups = [];
      selectedSizes = [];
      selectedFlavours = [];
      brandList = [];
      sizeList = [];
      flavourList = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: " สั่งซื้อสินค้า",
          icon: FontAwesomeIcons.clipboardList,
        ),
      ),
      // floatingActionButton: Cartbutton(
      //   count: "0",
      //   // screen: ShoppingCartScreen(
      //   //   customerNo: widget.customerNo,
      //   //   customerName: widget.customerName,
      //   //   status: widget.status,
      //   // ),
      //   screen: SizedBox(),
      // ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            // padding: const EdgeInsets.all(16.0),
            // margin: const EdgeInsets.all(8.0),
            child: LoadingSkeletonizer(
              loading: _loadingProduct,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: BoxShadowCustom(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.store,
                                    size: 40,
                                    color: Styles.primaryColor,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "VB21200372",
                                    style: Styles.black24(context),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // Ensures text does not overflow the screen
                                    child: Text(
                                      "บริษัท มิราเคิล แพลนเนท จำกัด (สำนักงานใหญ่)",
                                      style: Styles.black24(context),
                                      overflow: TextOverflow
                                          .ellipsis, // Truncate if too long
                                      maxLines: 1, // Restrict to 1 line
                                      softWrap: false, // Avoid wrapping
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              color:
                                  Colors.grey[200], // Color of the divider line
                              thickness: 1, // Thickness of the line
                              indent: 16, // Left padding for the divider line
                              endIndent:
                                  16, // Right padding for the divider line
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showFilterGroupSheet(context);
                                          },
                                          child: badgeFilter(
                                            isSelected:
                                                selectedGroups.isNotEmpty
                                                    ? true
                                                    : false,
                                            Text(
                                              selectedGroups.isEmpty
                                                  ? 'กลุ่ม'
                                                  : selectedGroups.join(', '),
                                              style: selectedGroups.isEmpty
                                                  ? Styles.grey18(context)
                                                  : Styles.pirmary18(context),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate if too long
                                              maxLines: 1, // Restrict to 1 line
                                              softWrap: false, // Avoid wrapping
                                            ),
                                            selectedGroups.isEmpty ? 85 : 120,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _showFilterBrandSheet(context);
                                          },
                                          child: badgeFilter(
                                            isSelected:
                                                selectedBrands.isNotEmpty
                                                    ? true
                                                    : false,
                                            Text(
                                              selectedBrands.isEmpty
                                                  ? 'แบรนด์'
                                                  : selectedBrands.join(', '),
                                              style: selectedBrands.isEmpty
                                                  ? Styles.grey18(context)
                                                  : Styles.pirmary18(context),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate if too long
                                              maxLines: 1, // Restrict to 1 line
                                              softWrap: false, // Avoid wrapping
                                            ),
                                            selectedBrands.isEmpty ? 120 : 120,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _showFilterSizeSheet(context);
                                          },
                                          child: badgeFilter(
                                            isSelected: selectedSizes.isNotEmpty
                                                ? true
                                                : false,
                                            Text(
                                              selectedSizes.isEmpty
                                                  ? 'ขนาด'
                                                  : selectedSizes.join(', '),
                                              style: selectedSizes.isEmpty
                                                  ? Styles.grey18(context)
                                                  : Styles.pirmary18(context),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate if too long
                                              maxLines: 1, // Restrict to 1 line
                                              softWrap: false, // Avoid wrapping
                                            ),
                                            selectedSizes.isEmpty ? 120 : 120,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _showFilterFlavourSheet(context);
                                          },
                                          child: badgeFilter(
                                            isSelected:
                                                selectedFlavours.isNotEmpty
                                                    ? true
                                                    : false,
                                            Text(
                                              selectedFlavours.isEmpty
                                                  ? 'รสชาติ'
                                                  : selectedFlavours.join(', '),
                                              style: selectedFlavours.isEmpty
                                                  ? Styles.grey18(context)
                                                  : Styles.pirmary18(context),
                                              overflow: TextOverflow
                                                  .ellipsis, // Truncate if too long
                                              maxLines: 1, // Restrict to 1 line
                                              softWrap: false, // Avoid wrapping
                                            ),
                                            selectedFlavours.isEmpty
                                                ? 120
                                                : 120,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _clearFilter();
                                            context.loaderOverlay.show();
                                            _getProduct();
                                          },
                                          child: badgeFilter(
                                            openIcon: false,
                                            Text(
                                              'ล้างตัวเลือก',
                                              style: Styles.grey18(context),
                                            ),
                                            110,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          // Text("มุมมอง",
                                          //     style: Styles.black18(context)),
                                          GestureDetector(
                                            onTap: () {
                                              if (!_isGridView) {
                                                setState(() {
                                                  _isGridView = true;
                                                });
                                              } else {
                                                setState(() {
                                                  _isGridView = false;
                                                });
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.all(8.0),
                                              height: 50,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                _isGridView
                                                    ? FontAwesomeIcons.tableList
                                                    : FontAwesomeIcons
                                                        .tableCellsLarge,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _isGridView
                                ? Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount:
                                                (productList.length / 2).ceil(),
                                            itemBuilder: (context, index) {
                                              final firstIndex = index * 2;
                                              final secondIndex =
                                                  firstIndex + 1;
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        OrderMenuListVerticalCard(
                                                      item: productList[
                                                          firstIndex],
                                                      onDetailsPressed: () {},
                                                    ),
                                                  ),
                                                  if (secondIndex <
                                                      productList.length)
                                                    Expanded(
                                                      child:
                                                          OrderMenuListVerticalCard(
                                                        item: productList[
                                                            secondIndex],
                                                        onDetailsPressed: () {},
                                                      ),
                                                    )
                                                  else
                                                    Expanded(
                                                      child:
                                                          SizedBox(), // Placeholder for spacing if no second card
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        )

                                        // Row(
                                        //   children: [
                                        //     Expanded(
                                        //       child: OrderMenuListVerticalCard(
                                        //         onDetailsPressed: () {},
                                        //       ),
                                        //     ),
                                        //     Expanded(
                                        //       child: OrderMenuListVerticalCard(
                                        //         onDetailsPressed: () {},
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                      ],
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: productList.length,
                                            itemBuilder: (context, index) {
                                              return OrderMenuListCard(
                                                product: productList[index],
                                                onTap: () {
                                                  print(productList[index]);
                                                  setState(() {
                                                    selectedSize = '';
                                                    price = 0.00;
                                                    count = 0;
                                                    total = 0.00;
                                                  });
                                                  _showProductSheet(context,
                                                      productList[index]);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    // Ensures text does not overflow the screen
                                    child: ButtonFullWidth(
                                      text: 'ใส่ตะกร้า',
                                      blackGroundColor: Styles.primaryColor,
                                      textStyle: Styles.white18(context),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "ยอดรวม ฿${total.toStringAsFixed(2)} บาท",
                                      style: Styles.black24(context),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    // Ensures text does not overflow the screen
                                    child: ButtonFullWidth(
                                      text: 'ใส่ตะกร้า',
                                      blackGroundColor: Styles.primaryColor,
                                      textStyle: Styles.white18(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showProductSheet(BuildContext context, Product product) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false, // Allows dragging but does not expand fully
            initialChildSize: 0.6, // 60% of screen height
            minChildSize: 0.4,
            maxChildSize: 0.9,

            builder: (context, scrollController) {
              return Container(
                width: screenWidth * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('รายละเอียดสินค้า',
                              style: Styles.white24(context)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Container(
                          height: screenHeight * 0.9,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                        width: screenWidth / 4,
                                        height: screenWidth / 4,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 50,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    product.name,
                                                    style:
                                                        Styles.black24(context),
                                                    softWrap: true,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'กลุ่ม : ${product.group}',
                                                  style:
                                                      Styles.black16(context),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'แบรนด์ : ${product.brand}',
                                                  style:
                                                      Styles.black16(context),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'ขนาด : ${product.size}',
                                                  style:
                                                      Styles.black16(context),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'รสชาติ : ${product.flavour}',
                                                  style:
                                                      Styles.black16(context),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('คงเหลือ',
                                        style: Styles.black18(context)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children:
                                              product.listUnit.map((data) {
                                            return Container(
                                              margin: EdgeInsets.all(8),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  setModalState(() {
                                                    price = double.parse(
                                                        data.price);
                                                  });

                                                  setModalState(
                                                    () {
                                                      selectedSize = data.name;
                                                      total = price * count;
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    side: BorderSide(
                                                      color: selectedSize ==
                                                              data.name
                                                          ? Styles.primaryColor
                                                          : Colors.grey,
                                                      width: 1,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  data.name,
                                                  style: selectedSize ==
                                                          data.name
                                                      ? Styles.pirmary18(
                                                          context)
                                                      : Styles.grey18(context),
                                                ),
                                              ),
                                            );
                                          }).toList(), // ✅ Ensure .toList() is here
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ราคา',
                                      style: Styles.black18(context),
                                    ),
                                    Text(
                                      "฿${product.listUnit.any((element) => element.name == selectedSize) ? product.listUnit.where((element) => element.name == selectedSize).first.price : '0.00'} บาท",
                                      style: Styles.black18(context),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'รวม',
                                      style: Styles.black18(context),
                                    ),
                                    Text(
                                      '฿${total.toStringAsFixed(2)} บาท',
                                      style: Styles.black18(context),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (count > 1) {
                                                setModalState(() {
                                                  count--;
                                                  total = price * count;
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1),
                                              ), // ✅ Makes the button circular
                                              padding: const EdgeInsets.all(8),
                                              backgroundColor:
                                                  Colors.white, // Button color
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 24,
                                              color: Colors.grey,
                                            ), // Example
                                          ),
                                          Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              width: 70,
                                              child: Text(
                                                '${count.toStringAsFixed(0)}',
                                                textAlign: TextAlign.center,
                                                style: Styles.black18(context),
                                              )),
                                          ElevatedButton(
                                            onPressed: () {
                                              setModalState(() {
                                                count++;
                                                total = price * count;
                                              });
                                              print("total${total}");
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(
                                                side: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1),
                                              ), // ✅ Makes the button circular
                                              padding: const EdgeInsets.all(8),
                                              backgroundColor:
                                                  Colors.white, // Button color
                                            ),
                                            child: const Icon(
                                              Icons.add,
                                              size: 24,
                                              color: Colors.grey,
                                            ), // Example
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: ButtonFullWidth(
                                              text: 'ใส่ตะกร้า',
                                              blackGroundColor:
                                                  Styles.primaryColor,
                                              textStyle:
                                                  Styles.white18(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(
                                //   height: 100,
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  Widget badgeFilter(Widget child, double width,
      {bool openIcon = true, bool isSelected = false}) {
    return GestureDetector(
      // onTap: () => onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        width: width,
        height: 50,
        decoration: BoxDecoration(
          // color: Styles.primaryColor,
          border: Border.all(
            color: isSelected ? Styles.primaryColor : Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: child,
                ),
                (openIcon)
                    ? Row(
                        children: [
                          const SizedBox(width: 8),
                          Icon(
                            Icons.arrow_drop_down_rounded,
                            color:
                                isSelected ? Styles.primaryColor : Colors.grey,
                          )
                        ],
                      )
                    : const SizedBox(),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showFilterGroupSheet(BuildContext context) {
    double sreenWidth = MediaQuery.of(context).size.width;
    double sreenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false, // Allows dragging but does not expand fully
            initialChildSize: 0.6, // 60% of screen height
            minChildSize: 0.4,
            maxChildSize: 0.6,

            builder: (context, scrollController) {
              return Container(
                width: sreenWidth * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 16),
                          Text('เลือกกลุ่ม', style: Styles.white24(context)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Container(
                          height: sreenHeight * 0.6,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Text('กลุ่ม',
                                        style: Styles.black24(context)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: groupList.map((data) {
                                    bool isSelected =
                                        selectedGroups.contains(data);
                                    return ChoiceChip(
                                      showCheckmark: false,
                                      label: Text(
                                        data,
                                        style: isSelected
                                            ? Styles.pirmary18(context)
                                            : Styles.grey18(context),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      selected: selectedGroups.contains(data),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Styles.primaryColor
                                            : Colors
                                                .grey, // Change border color
                                        width: 1.5,
                                      ),
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.white,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          if (selected) {
                                            selectedGroups.add(data);
                                          } else {
                                            selectedGroups.remove(data);
                                          }
                                        });
                                        setState(() {
                                          if (selected) {
                                            selectedGroups = selectedGroups;
                                          } else {
                                            selectedGroups = selectedGroups;
                                          }
                                        });
                                        _getFliterGroup();
                                      },
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: sreenHeight * 0.22,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () {
                                          setModalState(() {
                                            selectedBrands = [];
                                            selectedGroups = [];
                                            selectedSizes = [];
                                            selectedFlavours = [];
                                            brandList = [];
                                            sizeList = [];
                                            flavourList = [];
                                          });
                                        },
                                        text: 'ล้างข้อมูล',
                                        blackGroundColor: Styles.secondaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () async {
                                          await _getProduct();
                                          Navigator.pop(context);
                                        },
                                        text: 'ค้นหา',
                                        blackGroundColor: Styles.primaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  void _showFilterBrandSheet(BuildContext context) {
    double sreenWidth = MediaQuery.of(context).size.width;
    double sreenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false, // Allows dragging but does not expand fully
            initialChildSize: 0.6, // 60% of screen height
            minChildSize: 0.4,
            maxChildSize: 0.6,

            builder: (context, scrollController) {
              return Container(
                width: sreenWidth * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 16),
                          Text('เลือกแบรนด์', style: Styles.white24(context)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Container(
                          height: sreenHeight * 0.6,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Text('แบรนด์',
                                        style: Styles.black24(context)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                if (selectedGroups.isEmpty)
                                  Center(
                                    child: Text(
                                      "กรุณาเลือกกลุ่มก่อน",
                                      style: Styles.grey18(context),
                                    ),
                                  ),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: brandList.map((data) {
                                    bool isSelected =
                                        selectedBrands.contains(data);
                                    return ChoiceChip(
                                      showCheckmark: false,
                                      label: Text(
                                        data,
                                        style: isSelected
                                            ? Styles.pirmary18(context)
                                            : Styles.grey18(context),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      selected: selectedBrands.contains(data),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Styles.primaryColor
                                            : Colors
                                                .grey, // Change border color
                                        width: 1.5,
                                      ),
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.white,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          if (selected) {
                                            selectedBrands.add(data);
                                          } else {
                                            selectedBrands.remove(data);
                                          }
                                        });
                                        setState(() {
                                          if (selected) {
                                            selectedBrands = selectedBrands;
                                          } else {
                                            selectedBrands = selectedBrands;
                                          }
                                        });
                                        _getFliterBrand();
                                        print(
                                            "selectedBrands: ${selectedBrands}");
                                      },
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () {
                                          setModalState(() {
                                            selectedBrands = [];
                                            selectedGroups = [];
                                            selectedSizes = [];
                                            selectedFlavours = [];
                                            brandList = [];
                                            sizeList = [];
                                            flavourList = [];
                                          });
                                        },
                                        text: 'ล้างข้อมูล',
                                        blackGroundColor: Styles.secondaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () async {
                                          await _getProduct();
                                        },
                                        text: 'ค้นหา',
                                        blackGroundColor: Styles.primaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  void _showFilterSizeSheet(BuildContext context) {
    double sreenWidth = MediaQuery.of(context).size.width;
    double sreenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false, // Allows dragging but does not expand fully
            initialChildSize: 0.6, // 60% of screen height
            minChildSize: 0.4,
            maxChildSize: 0.6,

            builder: (context, scrollController) {
              return Container(
                width: sreenWidth * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 16),
                          Text('เลือกขนาด', style: Styles.white24(context)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Container(
                          height: sreenHeight * 0.6,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Text('ขนาด',
                                        style: Styles.black24(context)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                if (selectedGroups.isEmpty)
                                  Center(
                                    child: Text(
                                      "กรุณาเลือกกลุ่มก่อน",
                                      style: Styles.grey18(context),
                                    ),
                                  ),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: sizeList.map((data) {
                                    bool isSelected =
                                        selectedSizes.contains(data);
                                    return ChoiceChip(
                                      showCheckmark: false,
                                      label: Text(
                                        data,
                                        style: isSelected
                                            ? Styles.pirmary18(context)
                                            : Styles.grey18(context),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      selected: selectedSizes.contains(data),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Styles.primaryColor
                                            : Colors
                                                .grey, // Change border color
                                        width: 1.5,
                                      ),
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.white,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          if (selected) {
                                            selectedSizes.add(data);
                                          } else {
                                            selectedSizes.remove(data);
                                          }
                                        });
                                        setState(() {
                                          if (selected) {
                                            selectedSizes = selectedSizes;
                                          } else {
                                            selectedSizes = selectedSizes;
                                          }
                                        });
                                        _getFliterSize();
                                      },
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () {
                                          setModalState(() {
                                            selectedBrands = [];
                                            selectedGroups = [];
                                            selectedSizes = [];
                                            selectedFlavours = [];
                                            brandList = [];
                                            sizeList = [];
                                            flavourList = [];
                                          });
                                        },
                                        text: 'ล้างข้อมูล',
                                        blackGroundColor: Styles.secondaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () async {
                                          await _getProduct();
                                        },
                                        text: 'ค้นหา',
                                        blackGroundColor: Styles.primaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  void _showFilterFlavourSheet(BuildContext context) {
    double sreenWidth = MediaQuery.of(context).size.width;
    double sreenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return DraggableScrollableSheet(
            expand: false, // Allows dragging but does not expand fully
            initialChildSize: 0.6, // 60% of screen height
            minChildSize: 0.4,
            maxChildSize: 0.6,

            builder: (context, scrollController) {
              return Container(
                width: sreenWidth * 0.95,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Styles.primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 16),
                          Text('เลือกรสชาติ', style: Styles.white24(context)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        controller: scrollController,
                        child: Container(
                          height: sreenHeight * 0.6,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const SizedBox(width: 16),
                                    Text('รสชาติ',
                                        style: Styles.black24(context)),
                                  ],
                                ),
                                Divider(
                                  color: Colors.grey[200],
                                  thickness: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                                if (selectedGroups.isEmpty)
                                  Center(
                                    child: Text(
                                      "กรุณาเลือกกลุ่มก่อน",
                                      style: Styles.grey18(context),
                                    ),
                                  ),
                                Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: flavourList.map((data) {
                                    bool isSelected =
                                        selectedFlavours.contains(data);
                                    return ChoiceChip(
                                      showCheckmark: false,
                                      label: Text(
                                        data,
                                        style: isSelected
                                            ? Styles.pirmary18(context)
                                            : Styles.grey18(context),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      selected: selectedFlavours.contains(data),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Styles.primaryColor
                                            : Colors
                                                .grey, // Change border color
                                        width: 1.5,
                                      ),
                                      backgroundColor: Colors.white,
                                      selectedColor: Colors.white,
                                      onSelected: (selected) {
                                        setModalState(() {
                                          if (selected) {
                                            selectedFlavours.add(data);
                                          } else {
                                            selectedFlavours.remove(data);
                                          }
                                        });
                                        setState(() {
                                          if (selected) {
                                            selectedFlavours = selectedFlavours;
                                          } else {
                                            selectedFlavours = selectedFlavours;
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () {
                                          setModalState(() {
                                            selectedBrands = [];
                                            selectedGroups = [];
                                            selectedSizes = [];
                                            selectedFlavours = [];
                                            brandList = [];
                                            sizeList = [];
                                            flavourList = [];
                                          });
                                        },
                                        text: 'ล้างข้อมูล',
                                        blackGroundColor: Styles.secondaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: ButtonFullWidth(
                                        onPressed: () async {
                                          await _getProduct();
                                        },
                                        text: 'ค้นหา',
                                        blackGroundColor: Styles.primaryColor,
                                        textStyle: Styles.white18(context),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}
