import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class CustomDropdownSearch extends StatelessWidget {
  const CustomDropdownSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: ["Item 1", "Item 2", "Item 3", "Item 4"],
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          hintText: "ค้นหา", // Placeholder text in Thai for "Search"
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      dropdownButtonProps: const DropdownButtonProps(
        icon: Padding(
          padding: EdgeInsets.only(right: 8.0),
          child: Icon(
            Icons.search,
            size: 20,
            color: Colors.black54,
          ),
        ),
      ),
      popupProps: const PopupProps.menu(
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(8),
            hintText: 'ค้นหา...',
          ),
        ),
      ),
      clearButtonProps: const ClearButtonProps(isVisible: false),
    );
  }
}
