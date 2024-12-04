import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
import 'package:path/path.dart';
import 'package:mime/mime.dart';

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
  Map<String, dynamic>? staticData;

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
    required this.staticData,
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

  // Future<void> uploadFormData(
  //     String url, Map<String, String> fields, File file) async {
  //   try {
  //     // Determine MIME type of the file
  //     final mimeType = lookupMimeType(file.path);

  //     // Create a Multipart Request
  //     var request = http.MultipartRequest('POST', Uri.parse(url));

  //     // Add fields to the request
  //     fields.forEach((key, value) {
  //       request.fields[key] = value;
  //     });

  //     // Add the file
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'file', // Key for the file
  //         await file.readAsBytes(),
  //         filename: basename(file.path),
  //         contentType: mimeType != null ? MediaType.parse(mimeType) : null,
  //       ),
  //     );

  //     // Send the request
  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       print("Upload successful");
  //       final responseBody = await response.stream.bytesToString();
  //       print("Response: $responseBody");
  //     } else {
  //       print("Failed to upload. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error uploading file: $e");
  //   }
  // }

  // Future<void> adw(
  //     String url, Map<String, String> fields, File file) async {
  //   try {
  //     // Create Dio instance
  //     Dio dio = Dio();

  //     // Create a MultipartFile
  //     String fileName = file.path.split('/').last;
  //     FormData formData = FormData.fromMap({
  //       ...fields, // Add fields to FormData
  //       'file': await MultipartFile.fromFile(
  //         file.path,
  //         filename: fileName,
  //       ),
  //     });

  //     // Send POST request
  //     Response response = await dio.post(
  //       url,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           "Content-Type": "multipart/form-data",
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       print("Upload successful: ${response.data}");
  //     } else {
  //       print("Failed to upload. Status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error uploading file: $e");
  //   }
  // }

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

  Future<void> uploadFormDataWithDio(String imagePath) async {
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
                widget.staticData?['title'] ?? 'Store Detail',
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
                  label:
                      '${widget.staticData?['input_name']['name'] ?? "Shop Name"} *',
                  hint:
                      '${widget.staticData?['input_name']['hint'] ?? "Max 36 Characters"}',
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
                  label:
                      '${widget.staticData?['input_taxId']['name'] ?? "Tax ID"}',
                  hint:
                      '${widget.staticData?['input_taxId']['hint'] ?? "Max 13 Characters"}',
                ),
                const SizedBox(height: 16),
                Customtextinput(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  max: 10,
                  label:
                      '${widget.staticData?['input_tel']['name'] ?? "Phone"} *',
                  hint:
                      "${widget.staticData?['input_tel']['hint'] ?? "Max 10 Characters"}",
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
                                '${widget.staticData?['input_shoptype']['name'] ?? "Shop Type"} *',
                            titleText:
                                "${widget.staticData?['input_shoptype']['name'] ?? "Shop Type"}",
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
                              "${widget.staticData?['input_route']['name'] ?? "Route"} *",
                          titleText:
                              "${widget.staticData?['input_route']['name'] ?? "Route"}",
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
                  label:
                      '${widget.staticData?['input_lineId']['name'] ?? "Line ID"}',
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
                  label:
                      '${widget.staticData?['input_note']['name'] ?? "Note"}',
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
                " ${widget.staticData?['title_image'] ?? "Image"}",
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
                label: "${widget.staticData?['image_store'] ?? "Store"}",
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath);
                  final newImage = ImageItem(
                      name: imagePath, path: imagePath, type: "store");
                  imageList.insert(0, newImage);
                  setState(() {
                    storeImagePath = imagePath;
                    _storeData = _storeData?.copyWithDynamicField(
                        'imageList', '', imageList);
                  });
                  _saveStoreToStorage();
                },
              ),
              IconButtonWithLabel(
                icon: Icons.photo_camera,
                imagePath: taxIdImagePath != "" ? taxIdImagePath : null,
                label: "${widget.staticData?['image_taxId'] ?? "Tax ID"}",
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath);
                  final updatedImageList =
                      List<ImageItem>.from(_storeData!.imageList);
                  final newImage =
                      ImageItem(name: imagePath, path: imagePath, type: "tax");
                  updatedImageList.add(newImage);
                  setState(() {
                    taxIdImagePath = imagePath;
                    _storeData = _storeData?.copyWithDynamicField(
                        'imageList', '', updatedImageList);
                  });
                  _saveStoreToStorage();
                },
              ),
              IconButtonWithLabel(
                icon: Icons.photo_camera,
                imagePath: personalImagePath != "" ? personalImagePath : null,
                label:
                    "${widget.staticData?['image_identify'] ?? "Persona Identify"}",
                onImageSelected: (String imagePath) async {
                  await uploadFormDataWithDio(imagePath);
                  // Create a new imageList and add the imagePath
                  final updatedImageList =
                      List<ImageItem>.from(_storeData!.imageList);
                  final newImage = ImageItem(
                      name: imagePath, path: imagePath, type: "person");

                  updatedImageList.add(newImage);

                  setState(() {
                    personalImagePath = imagePath;
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
