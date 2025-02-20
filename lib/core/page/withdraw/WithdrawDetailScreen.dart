import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:flutter/material.dart';

class WithdrawDetailScreen extends StatefulWidget {
  const WithdrawDetailScreen({super.key});

  @override
  State<WithdrawDetailScreen> createState() => _WithdrawDetailScreenState();
}

class _WithdrawDetailScreenState extends State<WithdrawDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: " รายละเอียดการเบิกสินค้า",
          icon: Icons.local_shipping_outlined,
        ),
      ),
    );
  }
}
