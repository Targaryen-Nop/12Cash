import 'dart:async';
import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
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

late StreamSubscription<bool> keyboardSubscription;

class StoreDataScreen extends StatefulWidget {
  Store storeData;
  TextEditingController storeNameController;
  TextEditingController storeTaxIDController;
  TextEditingController storeTelController;
  TextEditingController storeLineController;
  TextEditingController storeNoteController;
  String initialSelectedRoute;
  String initialSelectedShoptype;

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
  }) : super(key: key);

  @override
  State<StoreDataScreen> createState() => _StoreDataScreenState();
}

class _StoreDataScreenState extends State<StoreDataScreen> {
  Map<String, dynamic>? _jsonString;
  bool storeInput = true;
  bool taxInput = true;
  bool phoneInput = true;
  bool shoptypeInput = true;
  bool sectionOne = true;
  bool sectionTwo = true;
  // Store? _storeData;
  Timer? _throttle;

  var keyboardVisibilityController = KeyboardVisibilityController();

  get http => null;

  //  late final KeyboardVisibilityController keyboardVisibilityController; // Declare it here
  @override
  void initState() {
    super.initState();

    _loadJson();
    _loadStoreFromStorage();
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: $visible');
      if (visible) {
      } else {
        setState(() {
          storeInput = true;
          taxInput = true;
          sectionOne = true;
          sectionTwo = true;
        });
        // print('storeNameController: ${storeNameController.text}');
        // print(storeNameController);
      }
    });
  }

  Future<void> _loadJson() async {
    String jsonString = await rootBundle.loadString('lang/main-th.json');
    setState(() {
      _jsonString = jsonDecode(jsonString)['shop']["add_shop_screen"];
    });
  }

  void _onTextChanged(String text, String field) {
    setState(() {
      widget.storeData = widget.storeData.copyWithDynamicField(field, text);
    });
    _saveStoreToStorage();
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
  }

  void _onTextChangedNote(String text, String field) {
    setState(() {
      widget.storeData = widget.storeData.copyWithDynamicField(field, text);
    });
    _saveStoreToStorage();
    // Cancel any existing timer to reset the delay
  }

  Future<void> _loadStoreFromStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the JSON string list from SharedPreferences
    String? jsonStore = prefs.getString("add_store");

    if (jsonStore != null) {
      setState(() {
        widget.storeData =
            // ignore: unnecessary_null_comparison
            (jsonStore == null ? null : Store.fromJson(jsonDecode(jsonStore)))!;
      });
    }
  }

  Future<void> _saveStoreToStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Convert Store object to JSON string
    String jsonStoreString = json.encode(widget.storeData!.toJson());

    // Save the JSON string list to SharedPreferences
    await prefs.setString('add_store', jsonStoreString);
  }

  Future<List<ShopType>> getShoptype(filter) async {
    //  var res = await http.post(Uri.parse(API.getRowCheck), body: {
    //   'user_code': Users.id,
    // });
    var response = await Dio().get(
      "https://8ac75a59-0e87-42a5-aad0-de57475b1f4e.mock.pstmn.io/cash/shoptype",
      queryParameters: {"filter": filter},
    );

    final data = jsonDecode(response.data);
    //  print('date' + response.data);
    if (data != null) {
      return ShopType.fromJsonList(data);
    }

    return [];
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
    keyboardSubscription.cancel();
    _throttle?.cancel();
    super.dispose();
    // TODO: implement dispose
  }
  // Listen to the keyboard visibility changes

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);

    return Column(
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
              if (sectionOne)
                Customtextinput(
                  max: 36,
                  onChanged: (text) {
                    _onTextChanged(text, 'name');
                  }, // Specify field as 'name',
                  // initialValue: widget.storeData.name,
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
              if (sectionOne) const SizedBox(height: 16),
              if (sectionOne)
                Customtextinput(
                  max: 13,
                  keypadType: TextInputType.number,
                  controller: widget.storeTaxIDController,
                  onChanged: (text) =>
                      _onTextChanged(text, 'taxId'), // Specify field as 'name',
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
              if (sectionOne) const SizedBox(height: 16),
              if (sectionOne)
                Customtextinput(
                  max: 10,
                  keypadType: TextInputType.number,
                  controller: widget.storeTelController,
                  onChanged: (text) => _onTextChanged(text, 'tel'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: 'โทรศัพท์',
                ),
              if (sectionTwo) const SizedBox(height: 16),
              if (sectionTwo)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SizedBox(
                          // child: ShopTypeDropdown(
                          //   label: 'เลือกประเภทร้านค้า *',
                          //   initialSelectedValue: widget.initialSelectedShoptype,
                          //   onChanged: (value) {
                          //     setState(() {
                          //       widget.storeData = widget.storeData
                          //           .copyWithDynamicField(
                          //               'typeName', value!.name);
                          //       widget.storeData = widget.storeData
                          //           .copyWithDynamicField('type', value.id);
                          //     });
                          //     _saveStoreToStorage();
                          //   },
                          // ),

                          child: DropdownSearchCustom<ShopType>(
                            label: "เลือกร้านค้า *",
                            titleText: "เลือกร้านค้า",
                            fetchItems: (filter) => getShoptype(filter),
                            onChanged: (selected) {
                              setState(() {
                                widget.storeData = widget.storeData
                                    .copyWithDynamicField(
                                        'typeName', selected!.name);
                                widget.storeData = widget.storeData
                                    .copyWithDynamicField('type', selected.id);
                              });
                              _saveStoreToStorage();
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
                        // height: 50,
                        // child: RouteDropdown(
                        //     initialSelectedValue: widget.initialSelectedRoute,
                        //     label: "เลือกรูท *",
                        //     onChanged: (value) {
                        //       setState(() {
                        //         widget.storeData = widget.storeData
                        //             .copyWithDynamicField(
                        //                 'route', value!.route);
                        //       });
                        //       _saveStoreToStorage();
                        //     }),
                        child: DropdownSearchCustom<RouteStore>(
                          label: "เลือกรูท *",
                          titleText: "เลือกรูท",
                          fetchItems: (filter) => getRoutes(filter),
                          onChanged: (selected) {
                            setState(() {
                              widget.storeData = widget.storeData
                                  .copyWithDynamicField(
                                      'route', selected!.route);
                            });
                            _saveStoreToStorage();
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
              if (sectionOne) const SizedBox(height: 16),
              if (sectionOne)
                Customtextinput(
                  controller: widget.storeLineController,
                  onChanged: (text) => _onTextChangedNote(text, 'lineId'),
                  onFieldTap: () {
                    setState(() {
                      sectionOne = true;
                      sectionTwo = false;
                    });
                  },
                  context,
                  label: 'Line ID',
                ),
              if (sectionOne) const SizedBox(height: 16),
              if (sectionOne)
                Customtextinput(
                  controller: widget.storeNoteController,
                  onChanged: (text) => _onTextChangedNote(text, 'note'),
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
      ],
    );
  }
}
