import 'dart:async';
import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/button/IconButtonWithLabel.dart';
import 'package:_12sale_app/core/components/dropdown/RouteDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/ShopTypeDropdown.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/components/search/DropdownSearchCustom.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Route.dart';
import 'package:_12sale_app/data/models/Shoptype.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreDataScreen extends StatefulWidget {
  Store storeData;
  List<dynamic> imageList = [];
  TextEditingController storeNameController;
  TextEditingController storeTaxIDController;
  TextEditingController storeTelController;
  TextEditingController storeLineController;
  TextEditingController storeNoteController;
  RouteStore initialSelectedRoute;
  ShopType initialSelectedShoptype;

  StoreDataScreen({
    Key? key,
    required this.storeData,
    required this.storeNameController,
    required this.storeTaxIDController,
    required this.storeTelController,
    required this.storeLineController,
    required this.storeNoteController,
    required this.initialSelectedRoute,
    required this.initialSelectedShoptype,
    required this.imageList,
  }) : super(key: key);

  @override
  State<StoreDataScreen> createState() => _StoreDataScreenState();
}

class _StoreDataScreenState extends State<StoreDataScreen> {
  Timer? _debounce;
  Store? _storeData;
  Map<String, dynamic>? _jsonString;
  List<String> imageList = [];
  bool storeInput = true;
  bool taxInput = true;
  bool phoneInput = true;
  bool shoptypeInput = true;
  bool sectionOne = true;
  bool sectionTwo = true;
  // Store? _storeData;
  Timer? _throttle;
  RouteStore selectedRoute = RouteStore(route: '');
  ShopType selectedShoptype =
      ShopType(id: '', name: '', descript: '', status: '');

  void initState() {
    super.initState();
    _loadJson();
    _loadStoreFromStorage();
    // _loadStoreFromStorage();
  }

  Future<void> _loadStoreFromStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? jsonStore = prefs.getString("add_store");

      if (jsonStore != null) {
        setState(() {
          _storeData = (jsonStore == null
              ? null
              : Store.fromJson(jsonDecode(jsonStore)))!;
          imageList = List<String>.from(widget.imageList);
        });
        // province = _storeData.province!;
      }
    } catch (e) {
      print("Error loading from storage: $e");
    }
  }

  // Future<void> _loadStoreFromStorage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();

  //   // Get the JSON string list from SharedPreferences
  //   String? jsonStore = prefs.getString("add_store");

  //   if (jsonStore != null) {
  //     setState(() {
  //       _storeData =
  //           (jsonStore == null ? null : Store.fromJson(jsonDecode(jsonStore)))!;
  //     });
  //     // province = _storeData.province!;
  //   }
  //   if (mounted) {
  //     setState(() {
  //       widget.initialSelectedShoptype = ShopType(
  //           id: _storeData!.type,
  //           name: _storeData!.typeName,
  //           descript: '',
  //           status: '');
  //     });
  //   }
  // }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  Future<void> _onTextChanged(String text, String field) async {
    setState(() {
      _storeData = _storeData?.copyWithDynamicField(field, text);
    });

    _saveStoreToStorage();

    // setState(() {
    //   widget.storeData = widget.storeData.copyWithDynamicField(field, text);
    // });
    // _saveStoreToStorage();

    // setState(() {
    //   widget.storeData = widget.storeData.copyWithDynamicField(field, text);
    // });
    // _saveStoreToStorage();
    // print(text);
  }

  Future<void> _saveStoreToStorage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // Convert Store object to JSON string
      String jsonStoreString = json.encode(_storeData!.toJson());
      await prefs.setString('add_store', jsonStoreString);
      print("Data saved to storage successfully.");
    } catch (e) {
      print("Error saving to storage: $e");
    }
  }
  // Cancel any existing timer to reset the delay
  // if (_throttle?.isActive ?? false) {
  //   _throttle!.cancel();
  // }
  // // Set a new timer for 3 milliseconds
  // _throttle = Timer(const Duration(milliseconds: 3000), () {
  //   print(
  //       'Throttled text: $text'); // This will print the text with throttling
  //   setState(() {
  //     widget.storeData = widget.storeData.copyWithDynamicField(field, text);
  //   });
  //   _saveStoreToStorage();
  //   // Cancel any existing timer to reset the delay
  //   if (_throttle?.isActive ?? false) {
  //     _throttle!.cancel();
  //   }
  // });

  // void _onTextChangedNote(String text, String field) {
  //   setState(() {https://myaccount.google.com/personal-info?gar=WzJd
  //     widget.storeData = widget.storeData.copyWithDynamicField(field, text);
  //   });
  //   _saveStoreToStorage();
  //   // Cancel any existing timer to reset the delay
  // }

  Future<List<ShopType>> getShoptype(String filter) async {
    try {
      var response = await Dio().get(
        "https://8ac75a59-0e87-42a5-aad0-de57475b1f4e.mock.pstmn.io/cash/shoptype",
        queryParameters: {"filter": filter},
      );

      final data = jsonDecode(response.data);

      return ShopType.fromJsonList(data);
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  // Future<void> _fetchShopTypes() async {
  //   try {
  //     final response = await http.get(Uri.parse(
  //         'https://8ac75a59-0e87-42a5-aad0-de57475b1f4e.mock.pstmn.io/cash/shoptype'));

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       if (mounted) {
  //         setState(() {
  //           items = data.map((json) => ShopType.fromJson(json)).toList();

  //           if (items.isNotEmpty && widget.initialSelectedValue != '') {
  //             selectedValue = items.firstWhere(
  //               (item) => item.name == widget.initialSelectedValue,
  //             );
  //           }
  //         });
  //       }
  //     } else {
  //       // Handle other response status codes
  //       print('Failed to load shop types: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     // Display a message to the user or retry logic
  //   }
  // }

  Future<List<RouteStore>> getRoutes(String filter) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/route.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      final List<RouteStore> route =
          (data as List).map((json) => RouteStore.fromJson(json)).toList();

      // Group districts by amphoe
      return route;
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

  @override
  void dispose() {
    _throttle?.cancel();
    super.dispose();
    // TODO: implement dispose
  }
  // Listen to the keyboard visibility changes

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenWidth / 80),
          Row(
            children: [
              const Icon(Icons.store, size: 40),
              const SizedBox(width: 8),
              Text(
                " ${_jsonString?['shop_detail'] ?? "Shop Detail"}",
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
                Customtextinput(
                  max: 36,
                  onChanged: (value) => _onTextChanged(value, 'name'),
                  controller: widget.storeNameController,
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: '${_jsonString?['shop_name'] ?? "Shop Name"} *',
                  hint:
                      '${_jsonString?['shop_name_hint'] ?? "Max 36 Characters"}',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  max: 13,
                  keypadType: TextInputType.number,
                  controller: widget.storeTaxIDController,
                  onChanged: (value) => _onTextChanged(value, 'taxId'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: '${_jsonString?['shop_tax'] ?? "Tax ID"} *',
                  hint:
                      '${_jsonString?['shop_tax_hint'] ?? "Max 13 Characters"}',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  max: 10,
                  keypadType: TextInputType.number,
                  controller: widget.storeTelController,
                  onChanged: (value) => _onTextChanged(value, 'tel'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: 'โทรศัพท์',
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          child: DropdownSearchCustom<ShopType>(
                            initialSelectedValue:
                                widget.initialSelectedShoptype.name == ''
                                    ? null
                                    : widget.initialSelectedShoptype,
                            label: "เลือกร้านค้า *",
                            titleText: "เลือกร้านค้า",
                            fetchItems: (filter) => getShoptype(filter),
                            onChanged: (ShopType? selected) async {
                              if (selected != null) {
                                selectedShoptype = ShopType(
                                  id: selected.id,
                                  name: selected.name,
                                  descript: selected.descript,
                                  status: selected.status,
                                );
                                setState(() {
                                  widget.initialSelectedShoptype =
                                      selectedShoptype;
                                  // Update the storeData fields
                                  _storeData = _storeData?.copyWithDynamicField(
                                      'typeName', selected.name);
                                  _storeData = _storeData?.copyWithDynamicField(
                                      'type', selected.id);
                                  // widget.storeData = widget.storeData
                                  //     .copyWithDynamicField(
                                  //         'typeName', selected.name);
                                  // widget.storeData = widget.storeData
                                  //     .copyWithDynamicField(
                                  //         'type', selected.id);
                                });
                                _saveStoreToStorage();
                              }
                            },
                            itemAsString: (ShopType data) => data.name,
                            itemBuilder: (context, item, isSelected) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      " ${item.name}",
                                      style: Styles.black18(context),
                                    ),
                                    selected: isSelected,
                                  ),
                                  Divider(
                                    color: Colors
                                        .grey[200], // Color of the divider line
                                    thickness: 1, // Thickness of the line
                                    indent:
                                        16, // Left padding for the divider line
                                    endIndent:
                                        16, // Right padding for the divider line
                                  ),
                                ],
                              );
                            },
                          ),
                        )),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SizedBox(
                        child: DropdownSearchCustom<RouteStore>(
                          initialSelectedValue:
                              widget.initialSelectedRoute.route == ''
                                  ? null
                                  : widget.initialSelectedRoute,
                          label: "เลือกรูท *",
                          titleText: "เลือกรูท",
                          fetchItems: (filter) => getRoutes(filter),
                          onChanged: (RouteStore? selected) async {
                            if (selected != null) {
                              setState(() {
                                _storeData = _storeData?.copyWithDynamicField(
                                    'route', selected.route);

                                selectedRoute =
                                    RouteStore(route: selected.route);
                                widget.initialSelectedRoute = selectedRoute;
                                // widget.storeData = widget.storeData
                                //     .copyWithDynamicField(
                                //         'route', selected.route);
                              });
                              _saveStoreToStorage();
                            }
                          },
                          itemAsString: (RouteStore data) => data.route,
                          itemBuilder: (context, item, isSelected) {
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    " ${item.route}",
                                    style: Styles.black18(context),
                                  ),
                                  selected: isSelected,
                                ),
                                Divider(
                                  color: Colors
                                      .grey[200], // Color of the divider line
                                  thickness: 1, // Thickness of the line
                                  indent:
                                      16, // Left padding for the divider line
                                  endIndent:
                                      16, // Right padding for the divider line
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  controller: widget.storeLineController,
                  onChanged: (text) => _onTextChanged(text, 'lineId'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: 'Line ID',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  controller: widget.storeNoteController,
                  onChanged: (text) => _onTextChanged(text, 'note'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: 'หมายเหตุ',
                ),
              ],
            ),
          ),
          SizedBox(height: screenWidth / 80),
          Row(
            children: [
              const Icon(Icons.photo, size: 40),
              const SizedBox(width: 8),
              Text(
                " ภาพถ่าย",
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButtonWithLabel(
                icon: Icons.image_not_supported_outlined,
                imagePath: imageList.isNotEmpty ? imageList[0] : null,
                label: "ร้านค้า",
                onImageSelected: (String imagePath) async {
                  imageList.add(imagePath);
                  widget.imageList.add(imagePath);
                  setState(() {
                    _storeData = _storeData?.copyWithDynamicField(
                        'imageList', "", imageList);
                  });
                  _saveStoreToStorage();
                },
              ),
              IconButtonWithLabel(
                icon: Icons.image_not_supported_outlined,
                imagePath: imageList.length > 1 ? imageList[1] : null,
                label: "พรก.",
                onImageSelected: (String imagePath) async {
                  // Create a new imageList and add the imagePath
                  final updatedImageList =
                      List<String>.from(_storeData!.imageList);

                  updatedImageList.add(imagePath);

                  imageList.add(imagePath);
                  widget.imageList.add(updatedImageList);
                  setState(() {
                    _storeData = _storeData?.copyWithDynamicField(
                        'imageList', "", updatedImageList);
                  });

                  // Save the updated storeData to storage
                  _saveStoreToStorage();
                },
              ),
              IconButtonWithLabel(
                icon: Icons.image_not_supported_outlined,
                imagePath: imageList.length > 2 ? imageList[2] : null,
                label: "บัตรปปช.",
                onImageSelected: (String imagePath) async {
                  // Create a new imageList and add the imagePath
                  final updatedImageList =
                      List<String>.from(_storeData!.imageList);
                  updatedImageList.add(imagePath);
                  imageList.add(imagePath);
                  widget.imageList.add(updatedImageList);
                  setState(() {
                    _storeData = _storeData?.copyWithDynamicField(
                        'imageList', "", updatedImageList);
                  });

                  // Save the updated storeData to storage
                  _saveStoreToStorage();
                },
              ),
            ],
          ),
          // GestureDetector(
          //   onTap: () {
          //     print(widget.storeData.imageList);
          //   },
          //   child: Text(
          //     "Data",
          //     style: Styles.black18(context),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     imageList.clear();
          //   },
          //   child: Text(
          //     "Delete",
          //     style: Styles.black18(context),
          //   ),
          // )
        ],
      ),
    );
  }
}
