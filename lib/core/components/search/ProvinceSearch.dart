import 'dart:convert';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Location.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

class ProvinceSearch extends StatefulWidget {
  final String label;
  final String? hint;
  final ValueChanged<Location?> onChanged;
  final String? initialSelectedValue;

  const ProvinceSearch({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  State<ProvinceSearch> createState() => _ProvinceSearchState();
}

class _ProvinceSearchState extends State<ProvinceSearch> {
  Location? _selected;
  List<Location> provinces = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Load provinces and set the initial selected value
    List<Location> loadedProvinces = await getProvince('');
    setState(() {
      provinces = loadedProvinces;
      if (widget.initialSelectedValue != null) {
        _selected = provinces.firstWhere(
          (location) => location.province == widget.initialSelectedValue,
        );
      }
    });
  }

  Future<List<Location>> getProvince(String filter) async {
    try {
      // Load the JSON file for provinces
      String response = await rootBundle.loadString('data/province.json');
      List<dynamic> data = json.decode(response);

      // Map JSON data to Location model and apply filtering
      return data
          .map((json) => Location.fromJson(json))
          .where((location) =>
              location.province.toLowerCase().contains(filter.toLowerCase()))
          .toList();
    } catch (e) {
      print("Error occurred while loading provinces: $e");
      return [];
    }
  }

  Future<Map<String, List<Location>>> getProvinceGroupedByProvince(
      String filter) async {
    try {
      // Load the JSON file for provinces
      String response = await rootBundle.loadString('data/province.json');
      List<dynamic> data = json.decode(response);

      // Map JSON data to Location model and apply filtering
      List<Location> locations = data
          .map((json) => Location.fromJson(json))
          .where((location) =>
              location.province.toLowerCase().contains(filter.toLowerCase()))
          .toList();

      // Group by province
      Map<String, List<Location>> groupedProvinces =
          groupBy(locations, (Location location) => location.province);

      return groupedProvinces;
    } catch (e) {
      print("Error occurred while loading and grouping provinces: $e");
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DropdownSearch<Location>(
      dropdownButtonProps: DropdownButtonProps(
        icon: Padding(
          padding: const EdgeInsets.only(right: 8.0),
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
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 100, 100, 100),
              width: 1,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Styles.primaryColor, width: 1.5),
          ),
        ),
      ),
      onChanged: (Location? data) {
        setState(() {
          _selected = data;
        });
        widget.onChanged(data);
      },
      selectedItem: _selected,
      asyncItems: (filter) => getProvince(filter),
      popupProps: PopupPropsMultiSelection.dialog(
        showSearchBox: true,
        itemBuilder: popupItemBuild,
        searchFieldProps: TextFieldProps(style: Styles.black18(context)),
      ),
    );
  }

  Widget popupItemBuild(BuildContext context, Location item, bool isSelected) {
    return Container(
      decoration: isSelected
          ? BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            )
          : null,
      child: ListTile(
        selected: isSelected,
        title: Text(
          item.province,
          style: Styles.black18(context),
        ),
      ),
    );
  }
}
