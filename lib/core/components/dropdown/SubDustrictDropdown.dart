import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:_12sale_app/data/models/SubDistrict.dart';
import 'package:flutter/material.dart';

class SubDistrictDropdown extends StatelessWidget {
  final String label;
  final String? hint;
  final List<SubDistrict> subDistricts;
  // final SubDistrict ? selectedSubDistrict
  final ValueChanged<SubDistrict?> onChanged;

  const SubDistrictDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    required this.subDistricts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SubDistrict>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Styles.grey18(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: subDistricts.map((subDistrict) {
        return DropdownMenuItem<SubDistrict>(
          value: subDistrict,
          child: Text(
            subDistrict.district,
            style: Styles.black18(context),
          ), // Display amphoe (district name)
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
