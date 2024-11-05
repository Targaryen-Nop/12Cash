import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/table/PromotionTable.dart';
import 'package:_12sale_app/core/page/route/VerifyOrderScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Promotionscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Promotionscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Promotionscreen> createState() => _PromotionscreenState();
}

class _PromotionscreenState extends State<Promotionscreen> {
  Map<String, dynamic>? _jsonString;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadJson();
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['route']["promotion_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " ${_jsonString?['title'] ?? 'Promotion&Discount'}",
            icon: Icons.cancel_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${_jsonString?['giveaway'] ?? 'Giveaway'}",
                style: Styles.headerBlack24(context)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Promotiontable(),
            ),
            Text("${_jsonString?['discount'] ?? 'Discount'}",
                style: Styles.headerBlack24(context)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Promotiontable(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Perform save action
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Verifyorderscreen(
                        customerName: widget.customerName,
                        customerNo: widget.customerNo,
                        status: widget.status,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GobalStyles.successButtonColor,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('${_jsonString?['next_button'] ?? 'Next'}',
                    style: Styles.white18(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
