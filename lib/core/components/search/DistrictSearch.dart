import 'package:collection/collection.dart'; // Add collection package for grouping
import 'dart:convert';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Location.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DistrictSearch extends StatefulWidget {
  final String label;
  final String? hint;
  final ValueChanged<Location?> onChanged;
  final Future<List<Location>> Function(String) fetchDistricts;
  final String? initialSelectedValue;

  const DistrictSearch({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    required this.fetchDistricts,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  State<DistrictSearch> createState() => _DistrictSearchState();
}

class _DistrictSearchState extends State<DistrictSearch> {
  Location? _selectedDistrict;
  List<Location> initialDistricts = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
    // _initializeSelectedDistrict();
  }

  Future<void> _loadDataFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('data/location.json');
    final data = json.decode(response);

    // Map JSON data to RouteStore model
    if (mounted) {
      setState(() {
        initialDistricts =
            (data as List).map((json) => Location.fromJson(json)).toList();
        // Find the initial selected RouteStore based on the route name
        if (initialDistricts.isNotEmpty && widget.initialSelectedValue != '') {
          _selectedDistrict = initialDistricts.firstWhere(
            (province) => province.amphoe == widget.initialSelectedValue,
          );
        }
      });
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
          hintText: widget.hint ?? "เลือกอำเภอ",
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
          _selectedDistrict = data;
        });
        widget.onChanged(data);
      },
      selectedItem: _selectedDistrict,
      itemAsString: (Location location) => location.amphoe,
      asyncItems: (filter) async {
        List<Location> districts = await widget.fetchDistricts(filter);
        return districts
            .map((district) => district.amphoe)
            .toSet()
            .map((amphoe) => Location(
                  amphoe: amphoe,
                  province: '', // Empty other fields
                  district: '',
                  zipcode: '',
                  id: '',
                  amphoeCode: '',
                  districtCode: '',
                  provinceCode: '',
                ))
            .toList(); // Return grouped districts
      },
      popupProps: PopupPropsMultiSelection.dialog(
        showSearchBox: true,
        // constraints: const BoxConstraints(maxHeight: 400),
        itemBuilder: (context, item, isSelected) {
          return _popupItemWithGroup(context, item, isSelected);
        },
        searchFieldProps: TextFieldProps(style: Styles.black18(context)),
      ),
    );
  }

  Widget _popupItemWithGroup(
      BuildContext context, Location item, bool isSelected) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      color: isSelected ? Colors.grey[300] : Colors.transparent,
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
    );
  }
}
