import 'package:_12sale_app/core/components/chart/Test.dart';
import 'package:_12sale_app/data/models/Route.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RouteDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final ValueChanged<RouteStore?> onChanged;
  final String? initialSelectedValue; // Now a String? for route name

  RouteDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
    this.initialSelectedValue, // Expecting route name or identifier as String
  }) : super(key: key);

  @override
  _RouteDropdownState createState() => _RouteDropdownState();
}

class _RouteDropdownState extends State<RouteDropdown> {
  RouteStore? selectedValue;
  List<RouteStore> routes = [];

  @override
  void initState() {
    super.initState();
    _loadRoutesFromJson();
  }

  Future<void> _loadRoutesFromJson() async {
    // Load the JSON file
    final String response = await rootBundle.loadString('data/route.json');
    final data = json.decode(response);

    // Map JSON data to RouteStore model
    setState(() {
      routes = (data as List).map((json) => RouteStore.fromJson(json)).toList();

      // Find the initial selected RouteStore based on the route name
      if (routes.isNotEmpty && widget.initialSelectedValue != null) {
        selectedValue = routes.firstWhere(
          (route) => route.route == widget.initialSelectedValue,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<RouteStore>(
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
      style: Styles.black18(context),
      items: routes.map((RouteStore item) {
        return DropdownMenuItem<RouteStore>(
          value: item,
          child: Text(item.route), // Display the route name
        );
      }).toList(),
      onChanged: (RouteStore? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
