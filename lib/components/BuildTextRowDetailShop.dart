import 'package:_12sale_app/styles/gobalStyle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuildTextRowDetailShop extends StatefulWidget {
  final String text;
  final String value;
  final int left;
  final int right;

  const BuildTextRowDetailShop({
    super.key,
    required this.text,
    required this.value,
    required this.left,
    required this.right,
  });

  @override
  State<BuildTextRowDetailShop> createState() => _BuildTextRowDetailShopState();
}

class _BuildTextRowDetailShopState extends State<BuildTextRowDetailShop> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0), // Space between rows
      child: Row(
        children: [
          Expanded(
            flex: widget.left,
            child: Text(
              widget.text,
              style: GobalStyles.textbBlack3, // Bold label
            ),
          ),
          Expanded(
            flex: widget.right,
            child: Text(
              widget.value,
              style: GobalStyles.textbBlack3,
            ), // Value text
          ),
        ],
      ),
    );
  }
}

class BuildTextRowBetween extends StatefulWidget {
  final String text;
  final double price;
  final TextStyle? style;

  const BuildTextRowBetween({
    super.key,
    required this.text,
    required this.price,
    required this.style,
  });

  @override
  State<BuildTextRowBetween> createState() => _BuildTextRowBetweenState();
}

class _BuildTextRowBetweenState extends State<BuildTextRowBetween> {
  late String formattedCurrency;
  void initState() {
    super.initState();
    // Initialize the formatted currency in initState
    formattedCurrency = NumberFormat.currency(locale: 'en_US', symbol: '\$')
        .format(widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.text,
          style: widget.style,
        ),
        Text(
          formattedCurrency,
          style: widget.style,
        ),
      ],
    );
  }
}
