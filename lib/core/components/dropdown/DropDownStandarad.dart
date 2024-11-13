import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DropDownStandard extends StatelessWidget {
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String hintText;

  const DropDownStandard({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.hintText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(
        Icons.chevron_left,
      ),
      isExpanded: true,
      alignment: Alignment.center,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      value: selectedValue,
      style: Styles.black18(context),
      items: items.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Center(
            child: Text(
              value,
              style: Styles.black18(context),
              textAlign: TextAlign.center,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      hint: Text(
        hintText,
        style: Styles.black18(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
