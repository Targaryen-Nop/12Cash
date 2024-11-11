import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class Customtextinput extends StatefulWidget {
  final String label;
  final String? hint;
  final String? initialValue;
  final bool readonly;
  VoidCallback? onFieldTap; // Callback for custom actions
  final TextEditingController? controller; // Add controller as an option
  Customtextinput(
    BuildContext context, {
    super.key,
    required this.label,
    this.hint,
    this.initialValue,
    this.readonly = false,
    this.onFieldTap,
    this.controller,
  });

  @override
  State<Customtextinput> createState() => _CustomtextinputState();
}

class _CustomtextinputState extends State<Customtextinput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        // Check if onFieldTap is not null before calling it
        if (widget.onFieldTap != null) {
          widget.onFieldTap!();
        }
      },
      readOnly: widget.readonly,
      style: Styles.black18(context),
      controller: widget.controller, // Use controller if provided
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Styles.grey18(context),
        hintText: widget.hint,
        hintStyle: Styles.grey18(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
    );
  }
}
