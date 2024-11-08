import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DropdownCustom extends StatefulWidget {
  final String label;
  final String? hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const DropdownCustom({
    Key? key,
    required this.label,
    this.hint,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  _DropdownCustomState createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
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
      value: selectedValue,
      icon: const Icon(Icons.arrow_drop_down),
      style: Styles.black18(context),
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
