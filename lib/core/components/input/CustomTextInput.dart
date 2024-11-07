import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class Customtextinput extends StatefulWidget {
  final String label;
  final String? hint;
  const Customtextinput(BuildContext context,
      {super.key, required this.label, this.hint});

  @override
  State<Customtextinput> createState() => _CustomtextinputState();
}

class _CustomtextinputState extends State<Customtextinput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Styles.grey18(context),
        hintText: widget.hint != null ? widget.hint : null,
        hintStyle: Styles.grey18(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
