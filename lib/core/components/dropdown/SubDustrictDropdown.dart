import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:_12sale_app/data/models/SubDistrict.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SubDistrictDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final List<SubDistrict> subDistricts;
  // final SubDistrict ? selectedSubDistrict
  final ValueChanged<SubDistrict?> onChanged;
  final String? initialSelectedValue;

  const SubDistrictDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    required this.subDistricts,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  State<SubDistrictDropdown> createState() => _SubDistrictDropdownState();
}

class _SubDistrictDropdownState extends State<SubDistrictDropdown> {
  SubDistrict? selectedDistrict;
  List<SubDistrict> subdistricts = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
  }

  Future<void> _loadDataFromJson() async {
    // Load the JSON file
    final String response =
        await rootBundle.loadString('data/subdistrict.json');
    final data = json.decode(response);

    // Map JSON data to RouteStore model
    setState(() {
      subdistricts =
          (data as List).map((json) => SubDistrict.fromJson(json)).toList();
      // Find the initial selected RouteStore based on the route name
      if (subdistricts.isNotEmpty && widget.initialSelectedValue != '') {
        selectedDistrict = subdistricts.firstWhere(
          (subdistrict) => subdistrict.district == widget.initialSelectedValue,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<SubDistrict>(
      // key: ValueKey(selectedDistrict),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: Styles.grey18(context),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      value: selectedDistrict,
      items: subdistricts.map((subDistrict) {
        return DropdownMenuItem<SubDistrict>(
          value: subDistrict,
          child: Text(
            subDistrict.district,
            style: Styles.black18(context),
          ), // Display amphoe (district name)
        );
      }).toList(),
      onChanged: (SubDistrict? newValue) {
        setState(() {
          selectedDistrict = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
