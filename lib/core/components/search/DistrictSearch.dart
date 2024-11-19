import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class DistrictSearch extends StatefulWidget {
  final String label;
  final String? hint;
  // final List<District> districts;
  final ValueChanged<District?> onChanged;
  final Future<List<District>> Function(String) getDistrict;
  final String? initialSelectedValue;

  const DistrictSearch({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    // required this.districts,
    required this.getDistrict,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  State<DistrictSearch> createState() => _DistrictSearchState();
}

class _DistrictSearchState extends State<DistrictSearch> {
  District? _selectedDistrict;
  List<District> districts = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
  }

  Future<void> _loadDataFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('data/district.json');
    final data = json.decode(response);

    // Map JSON data to RouteStore model
    setState(() {
      districts =
          (data as List).map((json) => District.fromJson(json)).toList();
      // Find the initial selected RouteStore based on the route name
      if (districts.isNotEmpty && widget.initialSelectedValue != '') {
        _selectedDistrict = districts.firstWhere(
          (district) => district.amphoe == widget.initialSelectedValue,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DropdownSearch<District>(
      // items: districts,
      dropdownButtonProps: DropdownButtonProps(
        icon: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.arrow_drop_down,
            size: screenWidth / 20,
            color: Colors.black54,
          ),
        ),
      ),

      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: Styles.black18(context),
        dropdownSearchDecoration: InputDecoration(
          labelText: widget.label,
          labelStyle: Styles.grey18(context),
          hintText: "เลือกอำเภอ",
          hintStyle: Styles.grey18(context),
          floatingLabelBehavior: FloatingLabelBehavior
              .always, // Always show the label above the dropdown
          filled: true,
          fillColor:
              Colors.white, // Optional: Set background color for the dropdown
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(8)), // Customize the border radius
            borderSide: BorderSide(
              color: Colors.grey, // Border color
              width: 1, // Border width
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(8)), // Border radius when enabled
            borderSide: BorderSide(
              color: Color.fromARGB(
                  255, 100, 100, 100), // Border color for enabled state
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(8)), // Border radius when focused
            borderSide: BorderSide(
              color: Styles.primaryColor, // Border color for focused state
              width: 1.5,
            ),
          ),
        ),
      ),
      onChanged: (District? data) {
        setState(() {
          _selectedDistrict = data;
        });
        widget.onChanged(data);
      },
      selectedItem: _selectedDistrict,
      asyncItems: (filter) => widget.getDistrict(filter),
      // compareFn: (i, s) => i.isEqual(s),
      popupProps: PopupPropsMultiSelection.dialog(
        showSearchBox: true,
        itemBuilder: popupItemBuild,
        searchFieldProps: TextFieldProps(style: Styles.black18(context)),
      ),
    );
  }

  Widget popupItemBuild(BuildContext context, District item, bool isSelected) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          padding: const EdgeInsets.symmetric(vertical: 0),
          decoration: !isSelected
              ? null
              : BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
          child: ListTile(
            selected: isSelected,
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${item.amphoe}',
                    style: Styles.black18(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
