import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:_12sale_app/data/models/Province.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProvinceSearch extends StatefulWidget {
  final String label;
  final String? hint;
  // final List<District> districts;
  final ValueChanged<Province?> onChanged;
  final String? initialSelectedValue;
  // final Future<List<Province>> Function(String) getProvince;

  const ProvinceSearch({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    this.initialSelectedValue,
    // required this.districts,
    // required this.getProvince,
  }) : super(key: key);

  @override
  State<ProvinceSearch> createState() => _ProvinceSearchState();
}

class _ProvinceSearchState extends State<ProvinceSearch> {
  Province? _selected;
  List<Province> provinces = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
  }

  Future<void> _loadDataFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('data/province.json');
    final data = json.decode(response);

    // Map JSON data to RouteStore model
    setState(() {
      provinces =
          (data as List).map((json) => Province.fromJson(json)).toList();
      // Find the initial selected RouteStore based on the route name
      if (provinces.isNotEmpty && widget.initialSelectedValue != '') {
        _selected = provinces.firstWhere(
          (province) => province.province == widget.initialSelectedValue,
        );
      }
    });
  }

  Future<List<Province>> getProvince(String filter) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/province.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      // final List<Province> districts =
      //     (data as List).map((json) => Province.fromJson(json)).toList();

      setState(() {
        provinces =
            (data as List).map((json) => Province.fromJson(json)).toList();
        // Find the initial selected RouteStore based on the route name
        if (provinces.isNotEmpty && widget.initialSelectedValue != '') {
          _selected = provinces.firstWhere(
            (province) => province.province == widget.initialSelectedValue,
          );
        }
      });
      return provinces;
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DropdownSearch<Province>(
      // items: provinces,
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
          hintText: widget.hint,
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
      onChanged: (Province? data) {
        setState(() {
          _selected = data;
        });
        widget.onChanged(data);
      },
      selectedItem: _selected,
      asyncItems: (filter) => getProvince(filter),
      // compareFn: (i, s) => i.isEqual(s),
      popupProps: PopupPropsMultiSelection.modalBottomSheet(
        showSearchBox: true,
        itemBuilder: popupItemBuild,
        searchFieldProps: TextFieldProps(style: Styles.black18(context)),
      ),
    );
  }

  Widget popupItemBuild(BuildContext context, Province item, bool isSelected) {
    return Column(
      children: [
        Container(
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
                    text: '${item.province}',
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
