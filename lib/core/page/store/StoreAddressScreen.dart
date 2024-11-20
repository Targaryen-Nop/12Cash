import 'dart:async';
import 'dart:convert';
import 'package:_12sale_app/core/components/dropdown/DistrictDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/ProvinceDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/SubDustrictDropdown.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/components/search/DistrictSearch.dart';
import 'package:_12sale_app/core/components/search/DropdownSearchCustom.dart';
import 'package:_12sale_app/core/components/search/DropdownSearchGroup.dart';
import 'package:_12sale_app/core/components/search/ProvinceSearch.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/District.dart';
import 'package:_12sale_app/data/models/Location.dart';
import 'package:_12sale_app/data/models/Poscode.dart';
import 'package:_12sale_app/data/models/Province.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/data/models/SubDistrict.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

class StoreAddressScreen extends StatefulWidget {
  Store storeData;
  TextEditingController storeAddressController;
  TextEditingController storePoscodeController;
  String initialSelectedProvince;
  String initialSelectedAmphoe;
  String initialSelectedSubDistrict;

  StoreAddressScreen({
    Key? key,
    required this.storeData,
    required this.storeAddressController,
    required this.storePoscodeController,
    required this.initialSelectedProvince,
    required this.initialSelectedAmphoe,
    required this.initialSelectedSubDistrict,
  }) : super(key: key);

  @override
  State<StoreAddressScreen> createState() => _StoreAddressScreenState();
}

class _StoreAddressScreenState extends State<StoreAddressScreen> {
  Map<String, dynamic>? _jsonString;
  String province = "";
  String amphoe = "";
  String district = "";
  List<Location> districts = []; // Filtered list of districts
  List<Location> subDistricts = []; // Filtered list of districts
  List<Location> poscode = []; // Filtered list of districts
  Location? selectedDistrict;
  Location? selectedsubDistricts;

  Store? _storeData;
  Timer? _throttle;

  @override
  void initState() {
    super.initState();
    _loadJson();
    _loadStoreFromStorage();
    _loadDistrictsFromJson(widget.initialSelectedProvince);
    _loadSubDistrictsFromJson(
        widget.initialSelectedProvince, widget.initialSelectedAmphoe);
    _loadPoscodeFromJson(widget.initialSelectedProvince,
        widget.initialSelectedAmphoe, widget.initialSelectedSubDistrict);
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
      province = widget.initialSelectedProvince;
      amphoe = widget.initialSelectedAmphoe;
      district = widget.initialSelectedSubDistrict;
    }
  }

  Future<List<Location>> _fetchDistricts(String filter) async {
    Map<String, List<Location>> groupedDistricts =
        await getDistrict(filter, province);

    // Flatten the grouped results for display
    return groupedDistricts.values
        .expand((districtList) => districtList)
        .toList();
  }

  Future<List<Location>> _fetchSubDistricts(String filter) async {
    Map<String, List<Location>> groupedDistricts =
        await getSubDistrict(filter, province, amphoe);

    // Flatten the grouped results for display
    return groupedDistricts.values
        .expand((districtList) => districtList)
        .toList();
  }

  Future<Map<String, List<Location>>> getSubDistrict(
      String filter, String province, String amphoe) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/location.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      final List<Location> districts = (data as List)
          .map((json) => Location.fromJson(json))
          .where((district) =>
              district.province == province &&
              district.amphoe == amphoe &&
              district.district
                  .toLowerCase()
                  .contains(filter.toLowerCase())) // Apply both filters
          .toList();
      Map<String, List<Location>> groupedData =
          groupBy(districts, (Location location) => location.district);

      // Group districts by amphoe
      return groupedData;
    } catch (e) {
      print("Error occurred: $e");
      return {};
    }
  }

  Future<Map<String, List<Location>>> getDistrict(
      String filter, String province) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/location.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      final List<Location> districts = (data as List)
          .map((json) => Location.fromJson(json))
          .where((district) =>
              district.province == province &&
              district.amphoe
                  .toLowerCase()
                  .contains(filter.toLowerCase())) // Apply both filters
          .toList();
      Map<String, List<Location>> groupedData =
          groupBy(districts, (Location location) => location.amphoe);

      // Group districts by amphoe
      return groupedData;
    } catch (e) {
      print("Error occurred: $e");
      return {};
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
    final String response = await rootBundle.loadString('data/location.json');
    final data = json.decode(response);

    // Filter districts by selected province
    if (mounted) {
      setState(() {
        districts = (data as List)
            .map((json) => Location.fromJson(json))
            .where((district) => district.province == province)
            .toList();

        // Reset selected district if not in filtered list
        selectedDistrict =
            districts.contains(selectedDistrict) ? selectedDistrict : null;
      });
    }
  }

  Future<void> _loadSubDistrictsFromJson(String province, String amphoe) async {
    // Load the JSON file for districts

    final String response = await rootBundle.loadString('data/location.json');
    final data = json.decode(response);

    // Filter districts by selected province
    if (mounted) {
      setState(() {
        subDistricts = (data as List)
            .map((json) => Location.fromJson(json))
            .where((subDistrict) =>
                subDistrict.province == province &&
                subDistrict.amphoe == amphoe)
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
  }

  Future<void> _loadPoscodeFromJson(
      String province, String amphoe, String district) async {
    // Load the JSON file for districts
    final String response = await rootBundle.loadString('data/location.json');
    final data = json.decode(response);

    // Filter districts by selected province
    if (mounted) {
      setState(() {
        poscode = (data as List)
            .map((json) => Location.fromJson(json))
            .where((poscode) =>
                poscode.province == province && poscode.amphoe == amphoe)
            // .where((subDistrict) =>
            //     // (subDistrict.province == province) &&
            //     (subDistrict.amphoe == amphoe))
            .toList();
        if (poscode.isEmpty) {
          widget.storePoscodeController.text = '';
        } else {
          setState(() {
            widget.storePoscodeController.text = poscode.first.zipcode!;
            _storeData = _storeData?.copyWithDynamicField(
                'postcode', poscode.first.zipcode!);
          });

          print(widget.storePoscodeController.text);
          widget.storePoscodeController.text = poscode.first.zipcode!;
          _saveStoreToStorage();
        }
      });
    }
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
    setState(() {
      _storeData = _storeData?.copyWithDynamicField(field, text);
    });
    _saveStoreToStorage();
    // _throttle = Timer(const Duration(milliseconds: 3000), () {
    //   print(
    //       'Throttled text: $text'); // This will print the text with throttling

    //   // Cancel any existing timer to reset the delay
    //   if (_throttle?.isActive ?? false) {
    //     _throttle!.cancel();
    //   }
    // });
  }

  @override
  void dispose() {
    _throttle?.cancel();
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
                max: 36,
                controller: widget.storeAddressController,
                onChanged: (value) => _onTextChanged(value, 'address'),
                context,
                label: 'ที่อยู่ *',
              ),
              SizedBox(height: screenWidth / 37),
              ProvinceSearch(
                initialSelectedValue: widget.initialSelectedProvince,
                label: "เลือกจังหวัด",
                hint: "เลือกจังหวัด",
                onChanged: (Province? value) {
                  if (value != null) {
                    setState(() {
                      province = value.province;
                      widget.initialSelectedProvince = value.province;
                      widget.initialSelectedAmphoe = '';
                      widget.initialSelectedSubDistrict = '';
                      widget.storePoscodeController.text = '';
                      _storeData = _storeData?.copyWithDynamicField(
                          'province', value.province);
                    });
                    _saveStoreToStorage();
                  }
                },
              ),
              SizedBox(height: screenWidth / 37),
              // DropdownSearchCustom<Location>(
              //   titleText: "เลือกอําเภอ",
              //   label: "เลือกอําเภอ",
              //   hint: "เลือกอําเภอ",
              //   fetchItems: (filter) =>
              //       _fetchDistricts(filter), // Fetch districts dynamically
              //   initialSelectedValue: widget.initialSelectedProvince != null
              //       ? Location(
              //           amphoe: widget.initialSelectedAmphoe!,
              //           amphoeCode: '',
              //           district: '',
              //           districtCode: '',
              //           province: '',
              //           provinceCode: '',
              //           zipcode: '',
              //           id: '') // Map initial value
              //       : null,
              //   onChanged: (Location? value) {
              //     if (value != null) {
              //       setState(() {
              //         widget.initialSelectedAmphoe = value.amphoe;
              //         amphoe = value.amphoe;
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'district', value.amphoe);
              //       });
              //       // _loadPoscodeFromJson(province, amphoe, district);
              //       _saveStoreToStorage();
              //     }
              //   },
              //   itemAsString: (Location location) =>
              //       location.amphoe, // Show amphoe name
              //   itemBuilder: (context, item, isSelected) {
              //     return ListTile(
              //       title: Text(
              //         item.amphoe,
              //         style: Styles.black18(context),
              //       ),
              //       selected: isSelected,
              //     );
              //   },
              //   showSearchBox: true, // Enable search box for filtering
              // ),
              DropdownSearchCustomGroup<Location>(
                key: ValueKey(
                    'DistrictSearch-${widget.initialSelectedProvince}'),
                label: "เลือกอำเภอ/เขต",
                hint: "เลือกอำเภอ/เขต",
                titleText: "เลือกอำเภอ/เขต",
                fetchItems: (filter) async {
                  // Replace with your district fetching logic
                  return await _fetchDistricts(filter);
                },
                groupByKey: (Location location) =>
                    location.amphoe, // Group by amphoe
                transformGroup: (String amphoe) => Location(
                  amphoe: amphoe,
                  province: '',
                  district: '',
                  zipcode: '',
                  id: '',
                  amphoeCode: '',
                  districtCode: '',
                  provinceCode: '',
                ), // Transform group key into Location
                itemAsString: (Location location) =>
                    location.amphoe, // Display amphoe name
                itemBuilder: (context, item, isSelected) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          " ${item.amphoe}",
                          style: Styles.black18(context),
                        ),
                        selected: isSelected,
                      ),
                      Divider(
                        color: Colors.grey[200], // Color of the divider line
                        thickness: 1, // Thickness of the line
                        indent: 16, // Left padding for the divider line
                        endIndent: 16, // Right padding for the divider line
                      ),
                    ],
                  );
                },
                onChanged: (Location? selected) {
                  if (selected != null) {
                    setState(() {
                      widget.initialSelectedAmphoe = selected.amphoe;
                      amphoe = selected.amphoe;
                      _storeData = _storeData?.copyWithDynamicField(
                          'district', selected.amphoe);
                    });
                    // _loadPoscodeFromJson(province, amphoe, district);
                    _saveStoreToStorage();
                  }
                },
                initialSelectedValue: null,
              ),
              SizedBox(height: screenWidth / 37),
              DropdownSearchCustomGroup<Location>(
                key: ValueKey(
                    'SubDistrictDropdown-${widget.initialSelectedProvince}'),
                label: "เลือกตำบล/เขต",
                hint: "เลือกตำบล/เขต",
                titleText: "เลือกตำบล/เขต",
                fetchItems: (filter) async {
                  // Replace with your district fetching logic
                  return await _fetchSubDistricts(filter);
                },
                groupByKey: (Location location) =>
                    location.district, // Group by amphoe
                transformGroup: (String district) => Location(
                  amphoe: '',
                  province: '',
                  district: district,
                  zipcode: '',
                  id: '',
                  amphoeCode: '',
                  districtCode: '',
                  provinceCode: '',
                ), // Transform group key into Location
                itemAsString: (Location location) =>
                    location.district, // Display amphoe name
                itemBuilder: (context, item, isSelected) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(
                          " ${item.district}",
                          style: Styles.black18(context),
                        ),
                        selected: isSelected,
                      ),
                      Divider(
                        color: Colors.grey[200], // Color of the divider line
                        thickness: 1, // Thickness of the line
                        indent: 16, // Left padding for the divider line
                        endIndent: 16, // Right padding for the divider line
                      ),
                    ],
                  );
                },
                onChanged: (Location? selected) {
                  if (selected != null) {
                    setState(() {
                      district = selected.district;
                      widget.initialSelectedSubDistrict = selected.district;
                      _storeData = _storeData?.copyWithDynamicField(
                          'subDistrict', selected.district);
                      _storeData = _storeData?.copyWithDynamicField(
                          'postcode', widget.storePoscodeController.text);
                    });
                    _loadPoscodeFromJson(province, amphoe, district);
                    _saveStoreToStorage();
                  }
                },
                initialSelectedValue: null,
              ),

              // DistrictSearch(
              //   key: ValueKey(
              //       'DistrictSearch-${widget.initialSelectedProvince}'),
              //   initialSelectedValue: widget.initialSelectedAmphoe,
              //   fetchDistricts: (filter) => _fetchDistricts(filter),
              //   label: "เลือกอำเภอ/เขต",
              //   onChanged: (Location? value) {
              //     if (value != null) {
              //       setState(() {
              //         widget.initialSelectedAmphoe = value.amphoe;
              //         amphoe = value.amphoe;
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'district', value.amphoe);
              //       });
              //       // _loadPoscodeFromJson(province, amphoe, district);
              //       _saveStoreToStorage();
              //     }
              //   },
              // ),

              // DistrictSearch2(
              //   key: ValueKey(
              //       'SubDistrictDropdown-${widget.initialSelectedProvince}'),
              //   initialSelectedValue: widget.initialSelectedSubDistrict,
              //   fetchDistricts: (filter) => _fetchSubDistricts(filter),
              //   label: "เลือกตำบล/แขวง",
              //   onChanged: (Location? value) {
              //     if (value != null) {
              //       setState(() {
              //         district = value.district;
              //         widget.initialSelectedSubDistrict = value.district;
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'subDistrict', value.district);
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'postcode', widget.storePoscodeController.text);
              //       });
              //       _loadPoscodeFromJson(province, amphoe, district);
              //       _saveStoreToStorage();
              //     }
              //   },
              // ),
              // SubDistrictDropdown(
              //   key: ValueKey(
              //       'SubDistrictDropdown-${widget.initialSelectedProvince}'),
              //   label: "เลือกตำบล",
              //   initialSelectedValue: widget.initialSelectedSubDistrict,
              //   // value: subDistricts,
              //   onChanged: (Location? value) {
              //     if (value != null) {
              //       setState(() {
              //         district = value.district;
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'subDistrict', value.district);
              //         _storeData = _storeData?.copyWithDynamicField(
              //             'postcode', widget.storePoscodeController.text);
              //       });
              //     }
              //     // print(province);
              //     // print(amphoe);
              //     // print(district);
              //     _loadPoscodeFromJson(province, amphoe, district);
              //     _saveStoreToStorage();
              //   },
              //   subDistricts: subDistricts,
              // ),
              SizedBox(height: screenWidth / 37),
              Customtextinput(
                key: ValueKey('PoscodeInput-${widget.initialSelectedProvince}'),
                context,
                onChanged: (value) => _onTextChanged(value, 'postcode'),
                readonly: true,
                controller:
                    widget.storePoscodeController, // Pass the controller here
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
