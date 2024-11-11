import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:flutter/material.dart';

class DistrictDropdown extends StatelessWidget {
  final String label;
  final String? hint;
  final List<District> districts;
  final ValueChanged<District?> onChanged;

  const DistrictDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    required this.districts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<District>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Styles.grey18(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: districts.map((district) {
        return DropdownMenuItem<District>(
          value: district,
          child: Text(
            district.amphoe,
            style: Styles.black18(context),
          ), // Display amphoe (district name)
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
