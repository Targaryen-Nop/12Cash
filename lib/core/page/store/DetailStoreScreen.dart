import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/button/AddStoreButton.dart';
import 'package:_12sale_app/core/components/button/IconButtonWithLabel.dart';
import 'package:_12sale_app/core/components/button/ShowPhotoButton.dart';
import 'package:_12sale_app/core/page/store/ProcessTimelineScreen.dart';

import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class DetailShopScreen extends StatefulWidget {
  String customerNo;
  String customerName;
  Store store;
  DetailShopScreen(
      {super.key,
      required this.customerNo,
      required this.customerName,
      required this.store});

  @override
  State<DetailShopScreen> createState() => _DetailShopScreenState();
}

class _DetailShopScreenState extends State<DetailShopScreen> {
  bool onEdit = true;
  late TextEditingController storeNameController;

  @override
  initState() {
    super.initState();
    storeNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 100, // Set the width of the button
        height: screenWidth / 8, // Set the height of the button
        child: AddStoreButton(
          icon: Icons.add,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProcessTimelinePage(),
              ),
            );
          },
        ),
      ),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
            title: " รายละเอียดร้านค้า",
            icon: Icons.store_mall_directory_rounded),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: viewportConstraints.maxHeight),
            child: IntrinsicHeight(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth / 80),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with transparency
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 8, // Blur radius of the shadow
                              offset: const Offset(0,
                                  4), // Offset of the shadow (horizontal, vertical)
                            ),
                          ],
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.store,
                                        size: 40,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "ข้อมูลร้านค้า",
                                        style: Styles.black24(context),
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          onEdit =
                                              !onEdit; // Toggle the value of onEdit
                                        });
                                        if (onEdit) {
                                          toastification.show(
                                            context: context,
                                            primaryColor: Colors.green,
                                            type: ToastificationType.success,
                                            style:
                                                ToastificationStyle.flatColored,
                                            title: Text(
                                              "บันทึกข้อมูลสําเร็จ",
                                              style: Styles.black18(context),
                                            ),
                                          );
                                        }
                                      },
                                      child: BoxShadowCustom(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: onEdit
                                                  ? Styles.primaryColor
                                                  : Styles.successButtonColor),
                                          child: Row(
                                            children: [
                                              Icon(
                                                onEdit
                                                    ? Icons.edit
                                                    : Icons.save_outlined,
                                                size: 40,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                onEdit ? "แก้ไข" : "บันทึก",
                                                style: Styles.white18(context),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                              SizedBox(height: screenWidth / 37),
                              _buildCustomFormField('ชื่อร้านค้า',
                                  widget.customerName, Icons.store,
                                  readOnly: onEdit),
                              _buildCustomFormField(
                                'เลขประจำตัวผู้เสียภาษี',
                                '${widget.store.taxId}',
                                Icons.person_outline,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomFormField('โทรศัพท์',
                                        '${widget.store.tel}', Icons.phone,
                                        readOnly: onEdit),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCustomFormField(
                                        'เส้นทาง',
                                        '${widget.store.route}',
                                        Icons.location_on,
                                        readOnly: onEdit),
                                  ),
                                ],
                              ),
                              _buildCustomFormField(
                                  'ไลน์',
                                  '${widget.store.lineId == "" ? '-' : widget.store.lineId}',
                                  Icons.alternate_email,
                                  readOnly: onEdit),
                              _buildCustomFormField(
                                  'ประเภทร้านค้า',
                                  '${widget.store.typeName}',
                                  Icons.store_mall_directory),
                              _buildCustomFormField('หมายเหตุ',
                                  '${widget.store.note}', Icons.note,
                                  readOnly: onEdit),
                              SizedBox(height: screenWidth / 37),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  onEdit
                                      ? ShowPhotoButton(
                                          label: "ร้านค้า",
                                          icon: Icons
                                              .image_not_supported_outlined,
                                          imagePath:
                                              widget.store.imageList.length > 0
                                                  ? widget.store.imageList[0]
                                                  : null,
                                        )
                                      : IconButtonWithLabel(
                                          label: "ร้านค้า",
                                          icon: Icons.photo_camera,
                                          imagePath:
                                              widget.store.imageList.length > 0
                                                  ? widget.store.imageList[0]
                                                  : null,
                                          onImageSelected:
                                              (String imagePath) async {
                                            widget.store.imageList
                                                .add(imagePath);
                                          },
                                        ),
                                  onEdit
                                      ? ShowPhotoButton(
                                          label: "พรก.",
                                          icon: Icons
                                              .image_not_supported_outlined,
                                          imagePath:
                                              widget.store.imageList.length > 1
                                                  ? widget.store.imageList[1]
                                                  : null,
                                        )
                                      : IconButtonWithLabel(
                                          label: "พรก.",
                                          icon: Icons.photo_camera,
                                          imagePath:
                                              widget.store.imageList.length > 1
                                                  ? widget.store.imageList[1]
                                                  : null,
                                          onImageSelected:
                                              (String imagePath) async {
                                            widget.store.imageList
                                                .add(imagePath);
                                            // final updatedImageList =
                                            //     List<String>.from(
                                            //         widget.store.imageList);
                                            // widget.store.imageList
                                            //     .add(updatedImageList);
                                          },
                                        ),
                                  onEdit
                                      ? ShowPhotoButton(
                                          label: "สำเนาบัตรปปช.",
                                          icon: Icons
                                              .image_not_supported_outlined,
                                          imagePath:
                                              widget.store.imageList.length > 2
                                                  ? widget.store.imageList[2]
                                                  : null,
                                        )
                                      : IconButtonWithLabel(
                                          label: "สำเนาบัตรปปช.",
                                          icon: Icons.photo_camera,
                                          imagePath:
                                              widget.store.imageList.length > 2
                                                  ? widget.store.imageList[2]
                                                  : null,
                                          onImageSelected:
                                              (String imagePath) async {
                                            widget.store.imageList
                                                .add(imagePath);
                                            // final updatedImageList =
                                            //     List<String>.from(
                                            //         widget.store.imageList);
                                            // widget.store.imageList
                                            //     .add(updatedImageList);
                                          },
                                        ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenWidth / 37),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(
                                  0.2), // Shadow color with transparency
                              spreadRadius: 2, // Spread of the shadow
                              blurRadius: 8, // Blur radius of the shadow
                              offset: const Offset(0,
                                  4), // Offset of the shadow (horizontal, vertical)
                            ),
                          ],
                          // border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Call Card",
                                    style: Styles.black18(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCustomFormField(String label, String value, IconData icon,
      {bool readOnly = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: readOnly ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          enabled: !readOnly,
          initialValue: value,
          style: Styles.black18(context),
          readOnly: readOnly, // Makes the TextFormField read-only
          decoration: InputDecoration(
            // fillColor: Colors.black,

            labelText: label,
            // hintStyle: Styles.kanit18,
            labelStyle: Styles.black18(context),
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}
