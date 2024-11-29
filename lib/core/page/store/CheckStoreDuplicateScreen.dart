import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/card/DuplicateCard.dart';
import 'package:_12sale_app/core/components/card/StoreCardAll.dart';
import 'package:_12sale_app/core/components/card/StoreCardNew.dart';
import 'package:_12sale_app/core/page/store/DetailStoreScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/DuplicateStore.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CheckStoreDuplicateScreen extends StatefulWidget {
  List<DuplicateStore> stores;
  CheckStoreDuplicateScreen({required this.stores, super.key});

  @override
  State<CheckStoreDuplicateScreen> createState() =>
      _CheckStoreDuplicateScreenState();
}

class _CheckStoreDuplicateScreenState extends State<CheckStoreDuplicateScreen> {
  List<DuplicateStore> storeItems = [];

  @override
  void initState() {
    super.initState();
    // _loadStoreData();
  }

  // Future<void> _loadStoreData() async {
  //   // Load JSON data from a file or a string
  //   final String response = await rootBundle.loadString('data/all_store.json');
  //   final List<dynamic> data = json.decode(response);

  //   setState(() {
  //     storeItems = data.map((json) => DuplicateStore.fromJson(json)).toList();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " ร้านค้าที่คล้ายกัน",
            icon: Icons.store_mall_directory_rounded),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: widget.stores.isEmpty
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loading spinner if data isn't loaded
                  : BoxShadowCustom(
                      child: ListView.builder(
                        itemCount: widget.stores.length,
                        itemBuilder: (context, index) {
                          return DuplicateCardStore(
                            item: widget.stores[index],
                            onDetailsPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => DetailShopScreen(
                              //         store: storeItems[index],
                              //         customerNo: storeItems[index].storeId,
                              //         customerName: storeItems[index].name),
                              //   ),
                              // );
                              print('Details for ${widget.stores[index].name}');
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
