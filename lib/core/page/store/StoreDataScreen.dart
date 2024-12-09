import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:_12sale_app/core/components/button/Button.dart';
import 'package:_12sale_app/core/components/button/IconButtonWithLabel.dart';
import 'package:_12sale_app/core/components/input/CustomTextInput.dart';
import 'package:_12sale_app/core/components/search/DropdownSearchCustom.dart';
import 'package:_12sale_app/core/page/dashboard/DashboardScreen.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Route.dart';
import 'package:_12sale_app/data/models/Shoptype.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:_12sale_app/function/SavetoStorage.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';

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

  List<ImageItem> imageList = [];
  String storeImagePath = "";
  String taxIdImagePath = "";
  String personalImagePath = "";
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
    // _loadJson();
    _loadStoreFromStorage();
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
          imageList = List<ImageItem>.from(widget.imageList);
          for (var value in imageList.reversed) {
            if (value.type == "store") {
              setState(() {
                storeImagePath = value.path;
              });
            } else if (value.type == 'tax') {
              setState(() {
                taxIdImagePath = value.path;
              });
            } else {
              setState(() {
                personalImagePath = value.path;
              });
            }
          }
        });
        // province = _storeData.province!;
      }
    } catch (e) {
      print("Error loading from storage: $e");
    }
  }

  Future<void> uploadFormDataWithDio(String imagePath, String typeImage) async {
    try {
      final dio = Dio();
      var formData = FormData.fromMap({
        'storeImage': await MultipartFile.fromFile(imagePath),
        'area': "BE211",
      });
      var response = await dio.post(
        'https://f8c3-171-103-242-50.ngrok-free.app/api/upload',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      if (response.statusCode == 201) {
        print("Image uploaded successfully ${response.data}");
        final newImage = ImageItem(
            name: response.data['data']['ImageName'],
            path: response.data['data']['path'],
            type: typeImage);
        imageList.insert(0, newImage);
        setState(() {
          storeImagePath = imagePath;
          _storeData =
              _storeData?.copyWithDynamicField('imageList', '', imageList);
        });
        _saveStoreToStorage();
      } else {}
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  Future<void> _onTextChanged(String text, String field) async {
    setState(() {
      _storeData = _storeData?.copyWithDynamicField(field, text);
    });

    _saveStoreToStorage();
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

  Future<List<ShopType>> getShoptype(String filter) async {
    try {
      // Load the JSON file for districts
      final String response = await rootBundle.loadString('data/shoptype.json');
      final data = json.decode(response);

      // Filter and map JSON data to District model based on selected province and filter
      final List<ShopType> route =
          (data as List).map((json) => ShopType.fromJson(json)).toList();

      // Group districts by amphoe
      return route;
    } catch (e) {
      print("Error occurred: $e");
      return [];
    }
  }

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
                "store.store_data_screen.title".tr(),
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
                  label: '${"store.store_data_screen.input_name.name".tr()} *',
                  hint: "store.store_data_screen.input_name.hint".tr(),
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
                  label: '${"store.store_data_screen.input_taxId.name".tr()} ',
                  hint: '${"store.store_data_screen.input_taxId.hint".tr()}',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  max: 10,
                  label: '${"store.store_data_screen.input_tel.name".tr()} *',
                  hint: "${"store.store_data_screen.input_tel.hint".tr()}",
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
                            label:
                                '${"store.store_data_screen.input_shoptype.name".tr()} *',
                            titleText:
                                "${"store.store_data_screen.input_shoptype.name".tr()}",
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
                          label:
                              "${"store.store_data_screen.input_route.name".tr()} *",
                          titleText:
                              "${"store.store_data_screen.input_route.name".tr()}",
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
                  hint: '${"store.store_data_screen.input_lineId.hint".tr()}',
                  label: '${"store.store_data_screen.input_lineId.name".tr()}',
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
                  hint: "store.store_data_screen.input_note.hint".tr(),
                  label: '${"store.store_data_screen.input_note.name".tr()}',
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
                "store.store_data_screen.title_image".tr(),
                style: Styles.headerBlack24(context),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButtonWithLabel(
                icon: Icons.photo_camera,
                imagePath: storeImagePath != "" ? storeImagePath : null,
                label: "store.store_data_screen.image_store".tr(),
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath, 'store');
                },
              ),
              IconButtonWithLabel(
                icon: Icons.photo_camera,
                imagePath: taxIdImagePath != "" ? taxIdImagePath : null,
                label: "store.store_data_screen.image_taxId".tr(),
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath, 'tax');
                },
              ),
              IconButtonWithLabel(
                icon: Icons.photo_camera,
                imagePath: personalImagePath != "" ? personalImagePath : null,
                label: "store.store_data_screen.image_identify".tr(),
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath, 'person');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
