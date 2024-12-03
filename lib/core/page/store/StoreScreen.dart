import 'dart:convert';

import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/button/AddStoreButton.dart';
import 'package:_12sale_app/core/components/card/StoreCardAll.dart';
import 'package:_12sale_app/core/components/card/StoreCardNew.dart';
import 'package:_12sale_app/core/components/search/CustomerDropdownSearch.dart';
import 'package:_12sale_app/core/components/table/ShopTableAll.dart';
import 'package:_12sale_app/core/components/table/ShopTableNew.dart';
import 'package:_12sale_app/core/page/store/DetailStoreScreen.dart';
import 'package:_12sale_app/core/page/store/ProcessTimelineScreen.dart';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _isSelected = false;
  List<Store> storeItems = [];
  static const _pageSize = 3;
  final PagingController<int, Store> _pagingController =
      PagingController(firstPageKey: 0);

  // final PagingController<int, BeerSummary> _pagingController =
  //     PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _loadStoreData();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getBeerList(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<List<Store>> getBeerList(int pageKey, int pageSize) async {
    Dio dio = Dio();
    String apiUrl =
        "https://f8c3-171-103-242-50.ngrok-free.app/api/cash/store/addStore?pageKey=$pageKey&pageSize=$pageSize";

    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        setState(() {
          storeItems = data
              .map((item) =>
                  Store.fromJson(item['store'] as Map<String, dynamic>))
              .toList();
        });
        return storeItems;
      } else {
        throw [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> _loadStoreData() async {
    // Load JSON data from a file or a string
    final String response = await rootBundle.loadString('data/all_store.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      storeItems = data.map((json) => Store.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // set scaffold background color to transparent
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        // color: Colors.amber,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 16, // Add elevation for shadow
                      shadowColor: Colors.black
                          .withOpacity(0.5), // Shadow color with opacity
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      backgroundColor:
                          _isSelected ? Colors.white : Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'ทั้งหมด',
                      style: Styles.headerBlack32(context),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isSelected = !_isSelected;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 16,
                      shadowColor: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      backgroundColor:
                          _isSelected ? Colors.grey[300] : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'ใหม่',
                      style: Styles.headerBlack32(context),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16), // Add spacing between buttons and list
            _isSelected
                ? Expanded(
                    child: storeItems.isEmpty
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Show loading spinner if data isn't loaded
                        : BoxShadowCustom(
                            child: ListView.builder(
                              itemCount: storeItems.length,
                              itemBuilder: (context, index) {
                                return StoreCartNew(
                                  item: storeItems[index],
                                  onDetailsPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailShopScreen(
                                            store: storeItems[index],
                                            customerNo:
                                                storeItems[index].storeId,
                                            customerName:
                                                storeItems[index].name),
                                      ),
                                    );
                                    print(
                                        'Details for ${storeItems[index].name}');
                                  },
                                );
                              },
                            ),
                          ),
                  )
                : Expanded(
                    child: storeItems.isEmpty
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // Show loading spinner if data isn't loaded
                        : BoxShadowCustom(
                            child: ListView.builder(
                              itemCount: storeItems.length,
                              itemBuilder: (context, index) {
                                return StoreCartAll(
                                  item: storeItems[index],
                                  onDetailsPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailShopScreen(
                                            store: storeItems[index],
                                            customerNo:
                                                storeItems[index].storeId,
                                            customerName:
                                                storeItems[index].name),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}

class ShopHeader extends StatefulWidget {
  const ShopHeader({super.key});

  @override
  State<ShopHeader> createState() => _ShopHeaderState();
}

class _ShopHeaderState extends State<ShopHeader> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Row(
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),

                  // color: Colors.red,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/12TradingLogo.png'),
                        // fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                fit: FlexFit.loose,
                child: Center(
                  // margin: EdgeInsets.only(top: 10),

                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          // color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Icon(Icons.store,
                                        size: screenWidth / 10,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    ' ร้านค้า',
                                    style: Styles.headerWhite32(context),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Flexible(
          fit: FlexFit.tight,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CustomerDropdownSearch(),
          ),
        ),
      ],
    );
  }
}
