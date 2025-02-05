import 'dart:async';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/button/CartButton.dart';
import 'package:_12sale_app/core/components/card/OrderMenuListCard.dart';
import 'package:_12sale_app/core/components/card/OrderMenuListVerticalCard.dart';
import 'package:_12sale_app/core/components/search/ProductSearch.dart';
import 'package:_12sale_app/core/page/route/ShoppingCartScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';
import 'package:_12sale_app/data/models/order/Product.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderMenuList extends StatefulWidget {
  const OrderMenuList({super.key});

  @override
  State<OrderMenuList> createState() => _OrderMenuListState();
}

class _OrderMenuListState extends State<OrderMenuList> {
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

  @override
  void initState() {
    super.initState();
    // _getFliter();
    _getProduct();
    _loadSaleRoute();
  }

  Future<void> _loadSaleRoute() async {
    setState(() {
      _loadingProduct = false;
    });
  }

  Future<void> _getProduct() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init();

      var response = await apiService.request(
        endpoint: 'api/cash/product/get?type=sale&search=ผงปรุงรส',
        method: 'GET',
      );
      // print("Response: $response");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        productList = data.map((item) => Product.fromJson(item)).toList();
        // print("productList $productList");
        if (mounted) {
          setState(() {
            productList = data.map((item) => Product.fromJson(item)).toList();
          });
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
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> dataGroup = response.data['data']['group'];
      final List<dynamic> dataBrand = response.data['data']['brand'];
      final List<dynamic> dataSize = response.data['data']['size'];
      final List<dynamic> dataFlavour = response.data['data']['flavour'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(dataGroup);
          brandList = List<String>.from(dataBrand);
          sizeList = List<String>.from(dataSize);
          flavourList = List<String>.from(dataFlavour);
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
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['brand'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(data);
        });
      }
      // Timer(const Duration(milliseconds: 500), () {
      //   if (mounted) {
      //     setState(() {
      //       _loadingAllStore = false;
      //     });
      //   }
      // });
    }
  }

  Future<void> _getFliterBrand() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['brand'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(data);
        });
      }
      // Timer(const Duration(milliseconds: 500), () {
      //   if (mounted) {
      //     setState(() {
      //       _loadingAllStore = false;
      //     });
      //   }
      // });
    }
  }

  Future<void> _getFliterSize() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['brand'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(data);
        });
      }
      // Timer(const Duration(milliseconds: 500), () {
      //   if (mounted) {
      //     setState(() {
      //       _loadingAllStore = false;
      //     });
      //   }
      // });
    }
  }

  Future<void> _getFliterFlavour() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['flavour'];
      print("_getFliter: ${response.data['data']}");
      if (mounted) {
        setState(() {
          groupList = List<String>.from(data);
        });
      }
      // Timer(const Duration(milliseconds: 500), () {
      //   if (mounted) {
      //     setState(() {
      //       _loadingAllStore = false;
      //     });
      //   }
      // });
    }
  }

  Future<void> _clearFilter() async {
    setState(() {
      selectedBrands = [];
      selectedGroups = [];
      selectedSizes = [];
      selectedFlavours = [];
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
      floatingActionButton: Cartbutton(
        count: "0",
        // screen: ShoppingCartScreen(
        //   customerNo: widget.customerNo,
        //   customerName: widget.customerName,
        //   status: widget.status,
        // ),
        screen: SizedBox(),
      ),
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
                            endIndent: 16, // Right padding for the divider line
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
                                        onTap: () => _showBottomSheet(context),
                                        child: badgeFilter(
                                            isSelected: (selectedBrands
                                                        .isNotEmpty ||
                                                    selectedGroups.isNotEmpty ||
                                                    selectedSizes.isNotEmpty ||
                                                    selectedFlavours.isNotEmpty)
                                                ? true
                                                : false,
                                            openIcon: false,
                                            Icon(
                                              FontAwesomeIcons.sliders,
                                              color:
                                                  (selectedBrands.isNotEmpty ||
                                                          selectedGroups
                                                              .isNotEmpty ||
                                                          selectedSizes
                                                              .isNotEmpty ||
                                                          selectedFlavours
                                                              .isNotEmpty)
                                                      ? Styles.primaryColor
                                                      : Colors.grey,
                                              size: 24,
                                            ),
                                            50),
                                      ),
                                      badgeFilter(
                                        isSelected: selectedGroups.isNotEmpty
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
                                        selectedGroups.isEmpty ? 85 : 150,
                                      ),
                                      badgeFilter(
                                        isSelected: selectedBrands.isNotEmpty
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
                                        selectedBrands.isEmpty ? 110 : 200,
                                      ),
                                      badgeFilter(
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
                                        selectedSizes.isEmpty ? 100 : 200,
                                      ),
                                      badgeFilter(
                                        isSelected: selectedFlavours.isNotEmpty
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
                                        selectedFlavours.isEmpty ? 110 : 200,
                                      ),
                                      GestureDetector(
                                        onTap: () => _clearFilter(),
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
                                            padding: const EdgeInsets.all(8.0),
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
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //       flex: 2,
                          //       child: Padding(
                          //         padding: const EdgeInsets.symmetric(
                          //           vertical: 8.0,
                          //           horizontal: 16,
                          //         ),
                          //         child: Container(
                          //           child: ProductSearch(
                          //               onStoreSelected: (data) {}),
                          //         ),
                          //       ),
                          //     ),
                          //     // Expanded(
                          //     //   child:
                          //     // )
                          //   ],
                          // ),
                          SizedBox(
                            height: 16,
                          ),
                          _isGridView
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: (productList.length / 3)
                                              .ceil(), // Divide by 3 instead of 2
                                          itemBuilder: (context, index) {
                                            final firstIndex = index * 2;
                                            final secondIndex = firstIndex + 1;
                                            return Row(
                                              children: [
                                                if (firstIndex <
                                                    productList.length)
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
                                                  ),
                                                SizedBox(),
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
                                        // ✅ Wrap ListView in Expanded
                                        child: ListView.builder(
                                          itemCount: productList.length,
                                          itemBuilder: (context, index) {
                                            return OrderMenuListCard(
                                              product: productList[index],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    )),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget badgeFilter(Widget child, double width,
      {bool openIcon = true, bool isSelected = false}) {
    return Container(
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
                          color: isSelected ? Styles.primaryColor : Colors.grey,
                        )
                      ],
                    )
                  : const SizedBox(),
            ],
          )
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
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
                          Text('กรองไอเทม', style: Styles.white24(context)),
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
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
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

                                        print(
                                            "selectedGroups: ${selectedGroups}");
                                        print("selectedGroupsData: ${data}");
                                      },
                                    );
                                  }).toList(),
                                ),
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
                                        print(
                                            "selectedBrands: ${selectedBrands}");
                                      },
                                    );
                                  }).toList(),
                                ),
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
                                      },
                                    );
                                  }).toList(),
                                ),
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
