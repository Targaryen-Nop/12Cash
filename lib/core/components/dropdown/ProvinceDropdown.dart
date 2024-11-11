import 'package:_12sale_app/core/components/chart/Test.dart';
import 'package:_12sale_app/data/models/Province.dart';
import 'package:_12sale_app/data/models/Route.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProvinceDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final ValueChanged<Province?> onChanged;

  const ProvinceDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ProvinceDropdownState createState() => _ProvinceDropdownState();
}

class _ProvinceDropdownState extends State<ProvinceDropdown> {
  Province? selectedValue;
  List<Province> routes = [];

  @override
  void initState() {
    super.initState();
    _loadRoutesFromJson();
  }

  Future<void> _loadRoutesFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('data/province.json');
    final data = json.decode(response);

    // Map JSON data to Province model
    setState(() {
      routes = (data as List).map((json) => Province.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Province>(
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
      items: routes.map((Province item) {
        return DropdownMenuItem<Province>(
          value: item,
          child: Text(item.province), // Display name of Province in dropdown
        );
      }).toList(),
      onChanged: (Province? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
