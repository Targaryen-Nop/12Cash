import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/button/AddStoreButton.dart';
import 'package:_12sale_app/core/page/store/AddStoreScreen.dart';
import 'package:_12sale_app/core/page/store/ProcessTimelineScreen.dart';
import 'package:_12sale_app/core/styles/gobalStyle.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/Store.dart';
import 'package:flutter/material.dart';

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
                    Row(
                      children: [
                        const Icon(
                          Icons.store,
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ข้อมูลร้านค้า",
                          style: Styles.black18(context),
                        ),
                      ],
                    ),
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
                              _buildCustomFormField('ชื่อร้านค้า',
                                  widget.customerName, Icons.store),
                              _buildCustomFormField(
                                  'เลขประจำตัวผู้เสียภาษี',
                                  '${widget.store.taxId}',
                                  Icons.person_outline),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomFormField('โทรศัพท์',
                                        '${widget.store.tel}', Icons.phone),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCustomFormField(
                                        'เส้นทาง',
                                        '${widget.store.route}',
                                        Icons.location_on),
                                  ),
                                ],
                              ),
                              _buildCustomFormField(
                                  'ไลน์',
                                  '${widget.store.lineId}',
                                  Icons.alternate_email),
                              _buildCustomFormField(
                                  'ประเภทร้านค้า',
                                  '${widget.store.typeName}',
                                  Icons.store_mall_directory),
                              _buildCustomFormField('หมายเหตุ',
                                  '${widget.store.note}', Icons.note),
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
                              offset: Offset(0,
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
                              Text(
                                "Function in Store",
                                style: Styles.black18(context),
                              ),
                              _buildCustomFormField('ชื่อร้านค้า',
                                  widget.customerName, Icons.store),
                              _buildCustomFormField('เลขประจำตัวผู้เสียภาษี',
                                  '1234567891011', Icons.person_outline),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCustomFormField(
                                        'โทรศัพท์', '089-2463592', Icons.phone),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCustomFormField(
                                        'เส้นทาง', 'R01', Icons.location_on),
                                  ),
                                ],
                              ),
                              _buildCustomFormField(
                                  'ไลน์', '@testja', Icons.alternate_email),
                              _buildCustomFormField('ประเภทร้านค้า',
                                  'แผงตลาดสด', Icons.store_mall_directory),
                              _buildCustomFormField(
                                  'หมายเหตุ',
                                  'ร้านปิดอาทิตย์ รับของ 15.00 - 16.00',
                                  Icons.note),
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

  Widget _buildCustomFormField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        initialValue: value,
        style: GobalStyles.kanit18,
        readOnly: true, // Makes the TextFormField read-only
        decoration: InputDecoration(
          labelText: label,
          // hintStyle: GobalStyles.kanit18,
          labelStyle: GobalStyles.kanit18,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
