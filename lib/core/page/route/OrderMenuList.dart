import 'dart:async';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/components/card/OrderMenuListCard.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';
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
  List<String> groupList = [];

  @override
  void initState() {
    super.initState();
    _getFliter();
  }

  Future<void> _getFliter() async {
    ApiService apiService = ApiService();
    await apiService.init();

    var response = await apiService.request(
      endpoint: 'api/cash/product/filter',
      method: 'GET',
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data']['group'];
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
      print("groupList: $groupList");
      print("listStore: ${data.length}");
    }
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            // padding: const EdgeInsets.all(16.0),
            // margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () =>
                                      _showCheckInSheet(context, groupList),
                                  child: badgeFilter(
                                    openIcon: false,
                                    Icon(
                                      FontAwesomeIcons.sliders,
                                      color: Colors.grey,
                                      size: 24,
                                    ),
                                  ),
                                ),
                                badgeFilter(
                                  openIcon: false,
                                  Text(
                                    'โปรโมชั่น',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                badgeFilter(
                                  Text(
                                    'กลุ่ม',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                badgeFilter(
                                  Text(
                                    'แบรนด์',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                badgeFilter(
                                  Text(
                                    'ขนาด',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                badgeFilter(
                                  Text(
                                    'รสชาติ',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                badgeFilter(
                                  openIcon: false,
                                  Text(
                                    'ล้างตัวเลือก',
                                    style: Styles.grey18(context),
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.all(8.0),
                                //   height: 50,
                                //   decoration: BoxDecoration(
                                //     color: Styles.primaryColor,
                                //     border: Border.all(
                                //       color: Colors.grey,
                                //       width: 1,
                                //     ),
                                //     borderRadius: BorderRadius.circular(16),
                                //   ),
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Icon(
                                //     FontAwesomeIcons.tableList,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: OrderMenuListCard(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget badgeFilter(Widget? child, {bool openIcon = true}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 50,
      decoration: BoxDecoration(
        // color: Styles.primaryColor,
        border: Border.all(
          color: Colors.grey,
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
              Container(
                child: child,
              ),
              (openIcon)
                  ? Row(
                      children: [
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_drop_down_rounded,
                          color: Colors.grey,
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

  void _showCheckInSheet(BuildContext context, List<String> groupList) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows dynamic height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: screenHeight * 0.65,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
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
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 16),
                        Text('กรองไอเทม', style: Styles.headerWhite24(context)),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Text('กลุ่ม', style: Styles.black18(context)),
                    ],
                  ),

                  Divider(
                    color: Colors.grey[200],
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  // Scrollable List
                  // Row(
                  //   children: groupList.asMap().entries.map((entry) {
                  //     return badgeFilter(Text(
                  //       entry.value,
                  //       style: Styles.grey18(context),
                  //     ));
                  //   }).toList(),
                  // ),
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.all(16.0),
                      children: [
                        Row(
                          children: [
                            for (var cell in groupList)
                              Expanded(
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Text(cell,
                                      style: Styles.grey18(context),
                                      textAlign: TextAlign.center),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  )

                  // Wrap(
                  //   spacing: 8, // Horizontal spacing between items
                  //   runSpacing: 8, // Vertical spacing between rows
                  //   children: groupList.asMap().entries.map((entry) {
                  //     return badgeFilter(
                  //       openIcon: false,
                  //       Text(
                  //         entry.value,
                  //         style: Styles.grey18(context),
                  //       ),
                  //     );
                  //   }).toList(),
                  // )
                  // Wrap(
                  //   spacing: 8, // Horizontal spacing between items
                  //   runSpacing: 8, // Vertical spacing between rows
                  //   children: groupList.map((item) {
                  //     return badgeFilter(
                  //       Text(
                  //         item,
                  //         style: Styles.grey18(context),
                  //       ),
                  //     );
                  //   }).toList(),
                  // )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
