import 'dart:async';
import 'dart:convert';

import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/dropdown/RouteDropdown.dart';
import 'package:_12sale_app/core/components/dropdown/ShopTypeDropdown.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
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

  StoreDataScreen({
    Key? key,
    required this.storeData,
    required this.storeNameController,
    required this.storeTaxIDController,
    required this.storeTelController,
    required this.storeLineController,
    required this.storeNoteController,
    required this.initialSelectedRoute,
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
                  label: '${_jsonString?['shop_tax'] ?? "Tax ID"} ',
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
                        child: ShopTypeDropdown(
                          label: 'เลือกประเภทร้านค้า *',
                          onChanged: (value) {
                            setState(() {
                              widget.storeData = widget.storeData
                                  .copyWithDynamicField(
                                      'typeName', value!.name);
                              widget.storeData = widget.storeData
                                  .copyWithDynamicField('type', value.id);
                            });
                            _saveStoreToStorage();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SizedBox(
                        // height: 50,
                        child: RouteDropdown(
                            initialSelectedValue: widget.initialSelectedRoute,
                            label: "เลือกรูท *",
                            onChanged: (value) {
                              setState(() {
                                widget.storeData = widget.storeData
                                    .copyWithDynamicField(
                                        'route', value!.route);
                              });
                              _saveStoreToStorage();
                            }),
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
