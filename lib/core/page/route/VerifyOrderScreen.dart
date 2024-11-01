import 'dart:convert';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BuildTextRowDetailShop.dart';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/table/VerifyTable.dart';
import 'package:_12sale_app/core/page/HomeScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Verifyorderscreen extends StatefulWidget {
  final String customerNo;
  final String customerName;
  final String status;

  const Verifyorderscreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.status});

  @override
  State<Verifyorderscreen> createState() => _VerifyorderscreenState();
}

class _VerifyorderscreenState extends State<Verifyorderscreen> {
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
      _jsonString = jsonDecode(jsonString)['route']["verify_screen"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " ${_jsonString?['title'] ?? 'Verify Order'}",
            icon: Icons.save_outlined),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildTextRowDetailShop(
              text: "${_jsonString?['sale_name'] ?? 'Sale Name'}",
              value: "จิตรีน เชียงเหิน",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "${_jsonString?['customer_no'] ?? 'Customer No'}",
              value: widget.customerNo,
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "${_jsonString?['customer_name'] ?? 'Customer Name'}",
              value: widget.customerName,
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "${_jsonString?['address'] ?? 'Address'}",
              value: "99/9 ถ.ย่ายชื่อ ต.บางบา อ.พานทอง จ.ชลบุรี",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "${_jsonString?['customer_phone'] ?? 'Phone'}",
              value: "0831157890",
              left: 3,
              right: 7,
            ),
            BuildTextRowDetailShop(
              text: "${_jsonString?['tax_no'] ?? 'Tax'}",
              value: "-",
              left: 3,
              right: 7,
            ),
            const VerifyTable(),
            const Spacer(),
            const Divider(
              color: Colors.grey,
            ),
            BuildTextRowBetween(
                text: "${_jsonString?['total'] ?? 'Total'}",
                price: 800.00,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "${_jsonString?['discount'] ?? 'Discount'}",
                price: 8430.00,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "${_jsonString?['net_price'] ?? 'Net Price'}",
                price: 00.00,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "${_jsonString?['vat'] ?? 'VAT (7%)'}",
                price: 7878.50,
                style: GobalStyles.textbBlack3),
            BuildTextRowBetween(
                text: "${_jsonString?['amount'] ?? 'Amount'}",
                price: 8430.00,
                style: GobalStyles.textbBlack3),
            ButtonFullWidth(
              text: "${_jsonString?['save'] ?? 'Save'}",
              textStyle: GobalStyles.text3,
              blackGroundColor: GobalStyles.successButtonColor,
              screen: const HomeScreen(index: 2),
            ),
          ],
        ),
      ),
    );
  }
}
