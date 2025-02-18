import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

class ProductWithdrowScreen extends StatefulWidget {
  const ProductWithdrowScreen({super.key});

  @override
  State<ProductWithdrowScreen> createState() => _ProductWithdrowScreenState();
}

class _ProductWithdrowScreenState extends State<ProductWithdrowScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70),
          child: AppbarCustom(
            title: " สั่งซื้อสินค้า",
            icon: FontAwesomeIcons.clipboardList,
          ),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: LoadingSkeletonizer(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                                                      : selectedGroups
                                                          .join(', '),
                                                  style: selectedGroups.isEmpty
                                                      ? Styles.grey18(context)
                                                      : Styles.pirmary18(
                                                          context),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Truncate if too long
                                                  maxLines:
                                                      1, // Restrict to 1 line
                                                  softWrap:
                                                      false, // Avoid wrapping
                                                ),
                                                selectedGroups.isEmpty
                                                    ? 85
                                                    : 120,
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
                                                      : selectedBrands
                                                          .join(', '),
                                                  style: selectedBrands.isEmpty
                                                      ? Styles.grey18(context)
                                                      : Styles.pirmary18(
                                                          context),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Truncate if too long
                                                  maxLines:
                                                      1, // Restrict to 1 line
                                                  softWrap:
                                                      false, // Avoid wrapping
                                                ),
                                                selectedBrands.isEmpty
                                                    ? 120
                                                    : 120,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showFilterSizeSheet(context);
                                              },
                                              child: badgeFilter(
                                                isSelected:
                                                    selectedSizes.isNotEmpty
                                                        ? true
                                                        : false,
                                                Text(
                                                  selectedSizes.isEmpty
                                                      ? 'ขนาด'
                                                      : selectedSizes
                                                          .join(', '),
                                                  style: selectedSizes.isEmpty
                                                      ? Styles.grey18(context)
                                                      : Styles.pirmary18(
                                                          context),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Truncate if too long
                                                  maxLines:
                                                      1, // Restrict to 1 line
                                                  softWrap:
                                                      false, // Avoid wrapping
                                                ),
                                                selectedSizes.isEmpty
                                                    ? 120
                                                    : 120,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showFilterFlavourSheet(
                                                    context);
                                              },
                                              child: badgeFilter(
                                                isSelected:
                                                    selectedFlavours.isNotEmpty
                                                        ? true
                                                        : false,
                                                Text(
                                                  selectedFlavours.isEmpty
                                                      ? 'รสชาติ'
                                                      : selectedFlavours
                                                          .join(', '),
                                                  style: selectedFlavours
                                                          .isEmpty
                                                      ? Styles.grey18(context)
                                                      : Styles.pirmary18(
                                                          context),
                                                  overflow: TextOverflow
                                                      .ellipsis, // Truncate if too long
                                                  maxLines:
                                                      1, // Restrict to 1 line
                                                  softWrap:
                                                      false, // Avoid wrapping
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                  margin:
                                                      const EdgeInsets.all(8.0),
                                                  height: 50,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                    _isGridView
                                                        ? FontAwesomeIcons
                                                            .tableList
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
                                                    (productList.length / 2)
                                                        .ceil(),
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
                                                          onDetailsPressed:
                                                              () async {
                                                            setState(() {
                                                              selectedUnit = '';
                                                              selectedSize = '';
                                                              price = 0.00;
                                                              count = 1;
                                                              total = 0.00;
                                                            });

                                                            _showProductSheet(
                                                                context,
                                                                productList[
                                                                    firstIndex]);
                                                          },
                                                        ),
                                                      ),
                                                      if (secondIndex <
                                                          productList.length)
                                                        Expanded(
                                                          child:
                                                              OrderMenuListVerticalCard(
                                                            item: productList[
                                                                secondIndex],
                                                            onDetailsPressed:
                                                                () {
                                                              setState(() {
                                                                selectedUnit =
                                                                    '';
                                                                selectedSize =
                                                                    '';
                                                                price = 0.00;
                                                                count = 1;
                                                                total = 0.00;
                                                              });
                                                              _showProductSheet(
                                                                  context,
                                                                  productList[
                                                                      secondIndex]);
                                                            },
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
                                                        selectedUnit = '';
                                                        selectedSize = '';
                                                        price = 0.00;
                                                        count = 1;
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
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Stack(
                                        alignment: Alignment(1.3, -1.5),
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await _getCart();
                                              _showCartSheet(context, cartList);
                                            },
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.all(4),
                                              backgroundColor:
                                                  Styles.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                          cartList.isNotEmpty
                                              ? Container(
                                                  width:
                                                      25, // Set the width of the button
                                                  height: 25,
                                                  // constraints: BoxConstraints(minHeight: 32, minWidth: 32),
                                                  decoration: BoxDecoration(
                                                    // This controls the shadow
                                                    boxShadow: [
                                                      BoxShadow(
                                                        spreadRadius: 1,
                                                        blurRadius: 5,
                                                        color: Colors.black
                                                            .withAlpha(50),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            180),
                                                    color: Colors
                                                        .red, // This would be color of the Badge
                                                  ),
                                                  // This is your Badge
                                                )
                                              : Container(),
                                        ],
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "ยอดรวม ฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(totalCart)} บาท",
                                          style: Styles.black24(context),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        // Ensures text does not overflow the screen
                                        child: ButtonFullWidth(
                                          text: 'สั่งซื้อ',
                                          blackGroundColor: Styles.primaryColor,
                                          textStyle: Styles.white18(context),
                                          onPressed: () {
                                            if (totalCart > 0) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateOrderScreen2(
                                                    storeId: widget
                                                        .storeDetail
                                                        ?.listStore[0]
                                                        .storeInfo
                                                        .storeId,
                                                    storeName: widget
                                                        .storeDetail
                                                        ?.listStore[0]
                                                        .storeInfo
                                                        .name,
                                                    storeAddress: widget
                                                        .storeDetail
                                                        ?.listStore[0]
                                                        .storeInfo
                                                        .address,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              toastification.show(
                                                autoCloseDuration:
                                                    const Duration(seconds: 5),
                                                context: context,
                                                primaryColor: Colors.red,
                                                type: ToastificationType.error,
                                                style: ToastificationStyle
                                                    .flatColored,
                                                title: Text(
                                                  "กรุณาเลือกรายการสินค้า",
                                                  style: Styles.red18(context),
                                                ),
                                              );
                                            }
                                          },
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
                  )),
            ),
          );
        }));
  }
}
