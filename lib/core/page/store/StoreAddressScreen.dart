import 'dart:async';
import 'dart:convert';
import 'package:_12sale_app/core/components/dropdown/DistrictDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/ProvinceDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/SubDustrictDropdown.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/components/search/DistrictSearch.dart';
import 'package:_12sale_app/core/components/search/ProvinceSearch.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:_12sale_app/data/models/Poscode.dart';
import 'package:_12sale_app/data/models/Province.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/data/models/SubDistrict.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreAddressScreen extends StatefulWidget {
  const StoreAddressScreen({super.key});

  @override
  State<StoreAddressScreen> createState() => _StoreAddressScreenState();
}

class _StoreAddressScreenState extends State<StoreAddressScreen> {
  Map<String, dynamic>? _jsonString;
  String province = "";
  String amphoe = "";
  String district = "";
  List<District> districts = []; // Filtered list of districts
  List<SubDistrict> subDistricts = []; // Filtered list of districts
  List<Poscode> poscode = []; // Filtered list of districts
  District? selectedDistrict;
  SubDistrict? selectedsubDistricts;
  final TextEditingController poscodeController =
      TextEditingController(); // Controller for postcode

  Store? _storeData;
  Timer? _throttle;

  @override
  void initState() {
    super.initState();
    _loadJson();
    _loadStoreFromStorage();
  }

  Future<void> _loadStoreFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the JSON string list from SharedPreferences
    String? jsonStore = prefs.getString("add_store");

    if (jsonStore != null) {
      setState(() {
        _storeData =
            (jsonStore == null ? null : Store.fromJson(jsonDecode(jsonStore)))!;
      });
    }
  }

  Future<List<District>> getDistrict(String filter, String province) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/district.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      final List<District> districts = (data as List)
          .map((json) => District.fromJson(json))
          .where((district) =>
              district.province == province &&
              district.amphoe
                  .toLowerCase()
                  .contains(filter.toLowerCase())) // Apply both filters
          .toList();

      return districts;
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  Future<void> _loadDistrictsFromJson(String province) async {
    // Load the JSON file for districts
    final String response = await rootBundle.loadString('data/district.json');
    final data = json.decode(response);

    // Filter districts by selected province
    setState(() {
      districts = (data as List)
          .map((json) => District.fromJson(json))
          .where((district) => district.province == province)
          .toList();

      // Reset selected district if not in filtered list
      selectedDistrict =
          districts.contains(selectedDistrict) ? selectedDistrict : null;
    });
  }

  Future<void> _loadSubDistrictsFromJson(String province, String amphoe) async {
    // Load the JSON file for districts
    final String response =
        await rootBundle.loadString('data/subdistrict.json');
    final data = json.decode(response);

    // Filter districts by selected province
    setState(() {
      subDistricts = (data as List)
          .map((json) => SubDistrict.fromJson(json))
          .where((subDistrict) =>
              subDistrict.province == province && subDistrict.amphoe == amphoe)
          // .where((subDistrict) =>
          //     // (subDistrict.province == province) &&
          //     (subDistrict.amphoe == amphoe))
          .toList();

      // Reset selected district if not in filtered list
      selectedsubDistricts = subDistricts.contains(selectedsubDistricts)
          ? selectedsubDistricts
          : null;
    });
  }

  Future<void> _loadPoscodeFromJson(
      String province, String amphoe, String district) async {
    // Load the JSON file for districts
    final String response = await rootBundle.loadString('data/poscode.json');
    final data = json.decode(response);

    // Filter districts by selected province
    setState(() {
      poscode = (data as List)
          .map((json) => Poscode.fromJson(json))
          .where((poscode) =>
              poscode.province == province && poscode.amphoe == amphoe)
          // .where((subDistrict) =>
          //     // (subDistrict.province == province) &&
          //     (subDistrict.amphoe == amphoe))
          .toList();
      if (poscode.isEmpty) {
        poscodeController.text = '';
      } else {
        setState(() {
          _storeData = _storeData?.copyWithDynamicField(
              'provinceCode', poscode[0].zipcode);
          _saveStoreToStorage();
        });
        poscodeController.text = poscode[0].zipcode;
      }

      // // Reset selected district if not in filtered list
      // selectedsubDistricts = subDistricts.contains(selectedsubDistricts)
      //     ? selectedsubDistricts
      //     : null;
    });
  }

  Future<void> _saveStoreToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert Store object to JSON string
    String jsonStoreString = json.encode(_storeData!.toJson());

    // Save the JSON string list to SharedPreferences
    await prefs.setString('add_store', jsonStoreString);
  }

  void _onTextChanged(String text, String field) {
    // Set a new timer for 3 milliseconds
    _throttle = Timer(const Duration(milliseconds: 3000), () {
      print(
          'Throttled text: $text'); // This will print the text with throttling
      setState(() {
        _storeData = _storeData?.copyWithDynamicField(field, text);
      });
      _saveStoreToStorage();
      // Cancel any existing timer to reset the delay
      if (_throttle?.isActive ?? false) {
        _throttle!.cancel();
      }
    });
  }

  @override
  void dispose() {
    poscodeController.dispose(); // Dispose controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenWidth / 80),
        Row(
          children: [
            const Icon(Icons.location_on_outlined, size: 40),
            const SizedBox(width: 8),
            Text(
              " ${_jsonString?['shop_address'] ?? "Shop Address"}",
              style: Styles.headerBlack24(context),
            ),
          ],
        ),
        SizedBox(height: screenWidth / 80),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenWidth / 37),
              Customtextinput(
                onChanged: (value) => _onTextChanged(value, 'address'),
                context,
                label: 'ที่อยู่ *',
              ),
              SizedBox(height: screenWidth / 37),

              // Province dropdown to select the province
              // ProvinceDropdown(
              //   label: "เลือกจังหวัด",
              //   onChanged: (value) {
              //     setState(() {
              //       province = value!.province;
              //     });
              //     _loadDistrictsFromJson(
              //         province); // Load districts for the selected province
              //   },
              // ),
              // SizedBox(height: screenWidth / 37),

              // // District dropdown to select the district based on the province
              // DistrictDropdown(
              //   label: "เลือกอำเภอ",
              //   districts: districts, // Pass the filtered list of districts
              //   onChanged: (value) {
              //     setState(() {
              //       selectedDistrict = value;
              //     });
              //   },
              // ),

              SizedBox(height: screenWidth / 37),
              ProvinceSearch(
                label: "เลือกจังหวัด",
                hint: "เลือกจังหวัด",
                onChanged: (Province? value) {
                  if (value != null) {
                    setState(() {
                      province = value.province;
                      _storeData = _storeData?.copyWithDynamicField(
                          'province', value!.province);
                      _saveStoreToStorage();
                    });
                    _loadDistrictsFromJson(
                        province); // Call _loadDistrictsFromJson with the selected province
                  }
                },
              ),
              SizedBox(height: screenWidth / 37),
              DistrictSearch(
                getDistrict: (filter) => getDistrict(filter, province),
                label: "เลือกอำเภอ",
                onChanged: (District? value) {
                  if (value != null) {
                    setState(() {
                      amphoe = value.amphoe;
                      _storeData = _storeData?.copyWithDynamicField(
                          'district', value!.amphoe);
                      _saveStoreToStorage();
                    });
                    _loadSubDistrictsFromJson(province, amphoe);
                  }
                  print(amphoe);
                  print(province);
                  print(subDistricts);
                },
              ),
              SizedBox(height: screenWidth / 37),
              SubDistrictDropdown(
                label: "เลือกตำบล",
                onChanged: (SubDistrict? value) {
                  if (value != null) {
                    setState(() {
                      district = value.district;
                      _storeData = _storeData?.copyWithDynamicField(
                          'subDistrict', value!.district);
                      _saveStoreToStorage();
                    });
                    _loadPoscodeFromJson(province, amphoe, district);
                  }
                  // print(amphoe);
                  // print(province);
                  print(poscode);
                  // print(poscode[0].zipcode);
                },
                subDistricts: subDistricts,
              ),
              SizedBox(height: screenWidth / 37),
              Customtextinput(
                context,
                onChanged: (value) => _onTextChanged(value, 'provinceCode'),
                readonly: true,
                controller: poscodeController, // Pass the controller here
                label: 'รหัสไปรณีย์',
              ),
            ],
          ),
        ),
        SizedBox(height: screenWidth / 80),
      ],
    );
  }
}
