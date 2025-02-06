import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CheckoutScreen extends StatefulWidget {
  final String? storeName;
  final String? storeId;
  CheckoutScreen({
    super.key,
    required this.storeId,
    required this.storeName,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: "${widget.storeName}",
        ),
      ),
      body: Container(
        child: BoxShadowCustom(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
