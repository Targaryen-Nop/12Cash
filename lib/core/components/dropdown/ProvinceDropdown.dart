import 'package:_12sale_app/core/components/chart/Test.dart';
import 'package:_12sale_app/data/models/Location.dart';
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
  final ValueChanged<Location?> onChanged;

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
  Location? selectedValue;
  List<Location> routes = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
  }

  Future<void> _loadDataFromJson() async {
    try {
      // Load the JSON file
      final String response = await rootBundle.loadString('data/province.json');
      List<dynamic> jsonList = json.decode(response);

      // Map JSON data to Location model
      setState(() {
        routes = jsonList.map((json) => Location.fromJson(json)).toList();
      });
    } catch (e) {
      // Handle any errors that occur during JSON loading
      print("Error loading province data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Location>(
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
      items: routes.map((Location item) {
        return DropdownMenuItem<Location>(
          value: item,
          child: Text(item.province), // Display name of the province
        );
      }).toList(),
      onChanged: (Location? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
