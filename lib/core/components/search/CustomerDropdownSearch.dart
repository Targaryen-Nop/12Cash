import 'dart:convert';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Customer.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/data/repositories/apiService.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart';

class CustomerDropdownSearch extends StatefulWidget {
  // final List<CustomerModel> customerModel;
  // final VoidCallback onPressed;

  const CustomerDropdownSearch({
    super.key,

    // required this.onPressed,
  });

  @override
  State<CustomerDropdownSearch> createState() => _CustomerDropdownSearchState();
}

class _CustomerDropdownSearchState extends State<CustomerDropdownSearch> {
  CustomerModel? _selectedCustomer;
  List<CustomerModel> customerList = [];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return DropdownSearch<CustomerModel>(
      // showSearchBox: true,
      // mode: Mode.BOTTOM_SHEET,
      asyncItems: (String filter) =>
          getCustomers(), // Filters data as user types
      dropdownButtonProps: DropdownButtonProps(
        icon: Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Icon(
            Icons.search,
            size: screenWidth / 20,
            color: Colors.black54,
          ),
        ),
      ),
      dropdownDecoratorProps: DropDownDecoratorProps(
        baseStyle: Styles.black18(context),
        dropdownSearchDecoration: InputDecoration(
          hintText: "ค้นหาร้านค้า",
          hintStyle: Styles.grey18(context),
          labelStyle: Styles.black18(context),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Color.fromARGB(255, 100, 100, 100),
              width: 1,
            ),
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
            borderSide: BorderSide(
              color: Colors.indigo,
              width: 1.5,
            ),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
      ),
      onChanged: (CustomerModel? data) => setState(() {
        _selectedCustomer = data;
      }),
      selectedItem: _selectedCustomer,
      // popupProps: const PopupProps.menu(
      //   showSearchBox: false,
      //   fit: FlexFit.loose,
      //   constraints: BoxConstraints(),
      // ),
      popupProps: PopupProps.menu(
        showSearchBox: true, // Disable the popup search box
        itemBuilder: _customCustomer, // Custom item builder for dropdown items
        // constraints: const BoxConstraints(),
      ),
    );
  }

  Future<List<CustomerModel>> getCustomers() async {
    try {
      ApiService apiService = ApiService();
      await apiService.init(); // Load .env before making any API calls

      var response = await apiService.request(
        endpoint:
            'erp/customer/', // You only need to pass the endpoint, the base URL is handled
        method: 'POST',
        body: {
          "customerNo": "VB20700031",
        },
      );
      print("ApiService: $response}");

      // // Checking if data is not null and returning the list of CustomerModel
      if (response != null) {
        return CustomerModel.fromJsonList(response);
      }
      return [];
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  Widget _customCustomer(
      BuildContext context, CustomerModel item, bool isSelected) {
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
                    text: 'ร้าน ${item.customerName}\n',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GobalStyles.primaryColor,
                    ),
                  ),
                  const TextSpan(
                    text: 'รหัสร้าน : ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${item.customerNo} \n',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                  const TextSpan(
                    text: 'เลขที่ : ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${item.customerNo} \n',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                  const TextSpan(
                    text: 'ที่อยู่ : ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '${item.customerAddress1} ${item.customerPoscode}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Color of the divider line
          thickness: 1, // Thickness of the line
          indent: 16, // Left padding for the divider line
          endIndent: 16, // Right padding for the divider line
        ),
      ],
    );
  }
}
