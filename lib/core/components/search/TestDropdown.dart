import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Customer.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';

class CustomerDropdownSearch2 extends StatefulWidget {
  const CustomerDropdownSearch2({Key? key}) : super(key: key);

  @override
  State<CustomerDropdownSearch2> createState() =>
      _CustomerDropdownSearch2State();
}

class _CustomerDropdownSearch2State extends State<CustomerDropdownSearch2> {
  TextEditingController _searchController = TextEditingController();
  CustomerModel? _selectedCustomer;
  List<CustomerModel> _allCustomers = [];
  List<CustomerModel> _filteredCustomers = [];
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _searchController.addListener(_filterCustomers);
  }

  void _fetchCustomers() async {
    _allCustomers = await getCustomers(); // Fetch all customers initially
    setState(() {
      _filteredCustomers =
          _allCustomers; // Set the filtered list to all customers initially
    });
  }

  void _filterCustomers() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCustomers = _allCustomers.where((customer) {
        return customer.customerName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectCustomer(CustomerModel customer) {
    setState(() {
      _selectedCustomer = customer;
      _searchController.text = customer.customerName;
      _isDropdownOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: "ค้นหาร้านค้า",
            hintStyle: Styles.grey18(context),
            labelStyle: Styles.black18(context),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            filled: true,
            fillColor: Colors.white,
            suffixIcon: Icon(Icons.search,
                size: screenWidth / 20, color: Colors.black54),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 100, 100, 100), width: 1),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 100, 100, 100), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide(color: Colors.indigo, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          onTap: () {
            setState(() {
              _isDropdownOpen = !_isDropdownOpen;
            });
          },
        ),
        if (_isDropdownOpen)
          Container(
            constraints:
                BoxConstraints(maxHeight: 200), // Limit dropdown height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: _filteredCustomers.length,
              itemBuilder: (context, index) {
                final customer = _filteredCustomers[index];
                return ListTile(
                  title: Text(
                    'ร้าน ${customer.customerName}',
                    style: TextStyle(
                        fontSize: 16, color: GobalStyles.primaryColor),
                  ),
                  subtitle: Text('รหัสร้าน: ${customer.customerNo}'),
                  onTap: () => _selectCustomer(customer),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<List<CustomerModel>> getCustomers() async {
    try {
      var apiService = ApiService();
      await apiService.init();

      var response = await apiService.request(
        endpoint: 'erp/customer/',
        method: 'POST',
        body: {
          "customerNo": "VB20700031",
        },
      );

      if (response != null) {
        return CustomerModel.fromJsonList(response);
      }
      return [];
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }
}
