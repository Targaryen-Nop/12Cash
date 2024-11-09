import 'package:_12sale_app/core/components/chart/Test.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Shoptype.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopTypeDropdown extends StatefulWidget {
  final String label;
  final String? hint;
  final ValueChanged<ShopType?> onChanged;

  const ShopTypeDropdown({
    Key? key,
    required this.label,
    this.hint,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ShopTypeDropdownState createState() => _ShopTypeDropdownState();
}

class _ShopTypeDropdownState extends State<ShopTypeDropdown> {
  ShopType? selectedValue;
  List<ShopType> items = [];

  @override
  void initState() {
    super.initState();
    _fetchShopTypes();
  }

  Future<void> _fetchShopTypes() async {
    try {
      final response = await http.get(Uri.parse(
          'https://8ac75a59-0e87-42a5-aad0-de57475b1f4e.mock.pstmn.io/cash/shoptype'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          items = data.map((json) => ShopType.fromJson(json)).toList();
        });
      } else {
        // Handle other response status codes
        print('Failed to load shop types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // Display a message to the user or retry logic
    }
  }

  void loadShopTypes() async {
    List<ShopType> shopTypes = await getShopTypes();
    setState(() {
      items = shopTypes;
    });
  }

  Future<List<ShopType>> getShopTypes() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init(); // Initialize API service (e.g., load .env)

      var response = await apiService.request(
        endpoint: 'cash/shoptype', // Only the endpoint is needed
        method: 'GET', // Assuming a GET request here, adjust if necessary
      );

      print("ApiService Response: $response");

      // Checking if response is not null and converting it to a list of ShopType
      if (response != null) {
        return (response as List)
            .map((json) => ShopType.fromJson(json))
            .toList();
      }
      return [];
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ShopType>(
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
      items: items.map((ShopType item) {
        return DropdownMenuItem<ShopType>(
          value: item,
          child: Text(item.name), // Display name of ShopType in dropdown
        );
      }).toList(),
      onChanged: (ShopType? newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
