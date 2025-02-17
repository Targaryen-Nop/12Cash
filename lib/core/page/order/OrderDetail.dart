import 'dart:async';
import 'dart:typed_data';

import 'package:_12sale_app/core/components/Appbar.dart';
import 'package:_12sale_app/core/components/BoxShadowCustom.dart';
import 'package:_12sale_app/core/components/Loading.dart';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:_12sale_app/data/models/User.dart';

import 'package:_12sale_app/data/models/order/OrderDetail.dart';
import 'package:_12sale_app/data/service/apiService.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class OrderDetailScreen extends StatefulWidget {
  final orderId;
  const OrderDetailScreen({
    super.key,
    required this.orderId,
  });

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Sale? saleDetail;
  Store? storeDetail;
  List<Product> listProduct = [];
  List<Promotion> listPromotions = [];
  List<PromotionListItem> listPromotionItems = [];

  double subtotal = 0;
  double discount = 0;
  double discountProduct = 0;
  double vat = 0;
  double totalExVat = 0;
  double total = 0;
//  Map<String, dynamic> itemPr = [];

  @override
  void initState() {
    super.initState();
    // requestPermissions();
    // _getCart();
    _getOrderDetail();
    _fetchPairedDevices();
  }

  final ScrollController _cartScrollController = ScrollController();
  final ScrollController _promotionScrollController = ScrollController();

  bool _loadOrderDetail = false;

  Future<void> _getOrderDetail() async {
    try {
      print("Order ID : ${widget.orderId}");
      ApiService apiService = ApiService();
      await apiService.init();
      var response = await apiService.request(
        endpoint: 'api/cash/order/detail/${widget.orderId}',
        method: 'GET',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'][0]['listProduct'];
        final List<dynamic> prData = response.data['data'][0]['listPromotions'];
        setState(() {
          saleDetail = Sale.fromJson(response.data['data'][0]['sale']);
          storeDetail = Store.fromJson(response.data['data'][0]['store']);
          listProduct = data.map((item) => Product.fromJson(item)).toList();

          listPromotions =
              prData.map((item) => Promotion.fromJson(item)).toList();

          subtotal = response.data['data'][0]['subtotal'].toDouble();
          discount = response.data['data'][0]['discount'].toDouble();
          discountProduct =
              response.data['data'][0]['discountProduct'].toDouble();
          vat = response.data['data'][0]['vat'].toDouble();
          totalExVat = response.data['data'][0]['totalExVat'].toDouble();
          total = response.data['data'][0]['total'].toDouble();
          // Map cartList to receiptData["items"]
          receiptData['customer']['customercode'] = storeDetail?.storeId;
          receiptData['customer']['customername'] = storeDetail?.name;
          receiptData['customer']['address1'] = storeDetail?.address;
          receiptData['customer']['salecode'] = storeDetail?.storeId;
          receiptData['customer']['customercode'] = storeDetail?.storeId;
          receiptData['CUOR'] = widget.orderId;
          receiptData['OAORDT'] =
              DateFormat('dd/MM/yyyy').format(DateTime.now());

          receiptData['totaltext'] =
              "${response.data['data'][0]['subtotal'].toStringAsFixed(2)}";
          receiptData['ex_vat'] =
              "${response.data['data'][0]['totalExVat'].toStringAsFixed(2)}";
          receiptData['vat'] =
              "${response.data['data'][0]['vat'].toStringAsFixed(2)}";
          receiptData['discountProduct'] =
              "${response.data['data'][0]['discountProduct'].toStringAsFixed(2)}";
          receiptData['discount'] =
              "${response.data['data'][0]['discount'].toStringAsFixed(2)}";
          receiptData['total'] =
              "${response.data['data'][0]['total'].toStringAsFixed(2)}";
          receiptData['OBSMCD'] = "${saleDetail?.name}";
          receiptData['taxno'] = "${storeDetail?.taxId}";

          receiptData["items"] = listProduct
              .map((cartItem) => {
                    "name": cartItem.name,
                    "qty": cartItem.qty.toString(),
                    "unit": cartItem.unit,
                    "price": cartItem.price.toStringAsFixed(2),
                    "disamount": cartItem.discount.toStringAsFixed(2),
                    "itemamount": cartItem.netTotal.toStringAsFixed(2)
                  })
              .toList();
          for (var promotion in listPromotions) {
            for (var item in promotion.listPromotion) {
              listPromotionItems.add(item);
            }
          }

          for (var promotion in listPromotions) {
            for (var item in promotion.listPromotion) {
              receiptData["items"].add({
                "name": item.name,
                "qty": item.qty.toString(),
                "unit": item.unit,
                "price": "00.00",
                "disamount": "00.00",
                "itemamount": "00.00"
              });
            }
          }
        });
        print(receiptData);
        Timer(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _loadOrderDetail = false;
            });
          }
        });
      }
    } catch (e) {
      print("Error $e");
    }
  }

  // Bluetooth Connect
  List<BluetoothInfo> _devices = [];
  bool _connected = false;
  BluetoothInfo? _selectedDevice;
  final int paperWidth = 69;
  final int paperWidthHeader = 76;

  static const String encoding = 'TIS-620';
  final List<String> vowelAndToneMark = [
    '่',
    '้',
    '๊',
    '๋',
    'ั',
    '็',
    'ิ',
    'ี',
    'ุ',
    'ู',
    'ึ',
    'ื',
    '์',
    '.'
  ];

  final Map<String, dynamic> receiptData = {
    "customer": {
      "customercode": "",
      "customername": "",
      "address1": "",
      "address2": "",
      "address3": "",
      "postCode": "",
      "taxno": "",
      "salecode": ""
    },
    "CUOR": "",
    "OAORDT": "",
    "items": [],
    "totaltext": "00.00",
    "ex_vat": "00.00",
    "vat": "00.00",
    "discount": "0.00",
    "discountProduct": "0.00",
    "total": "00.00",
    "OBSMCD": ""
  };

  Future<void> _fetchPairedDevices() async {
    try {
      final List<BluetoothInfo> pairedDevices =
          await PrintBluetoothThermal.pairedBluetooths;
      setState(() {
        _devices = pairedDevices;
      });
    } catch (e) {
      print("Error fetching paired devices: $e");
    }
  }

  Future<void> printTest() async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      // await printHeaderSeparator();
      await printHeaderBill('บิลเงินสด/ใบกำกับภาษี');
      await printBodyBill(receiptData);
      // await printHeaderSeparator();
      // await printHeaderBill('ใบลดหนี้');
      // await printBodyBill(receiptData);
    } else {
      print("Printer is disconnected ($connectionStatus)");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Printer is not connected")),
      );
    }
  }

  String centerText(String text, int width) {
    int leftPadding = (width - text.length) ~/ 2;
    return ' ' * leftPadding + text;
  }

  Future<void> printHeaderBill(String typeBill) async {
    String header = '''
${centerText('บริษัท วันทูเทรดดิ้ง จำกัด', paperWidthHeader)}
${centerText('58/3 หมู่ที่ 6 ถ.พระประโทน-บ้านแพ้ว', paperWidthHeader)}
${centerText('ต.ตลาดจินดา อ.สามพราน จ.นครปฐม 73110', paperWidthHeader)}
${centerText('โทร.(034) 981-555', paperWidthHeader)}
${centerText('เลขประจำตัวผู้เสียภาษี 0105563063410', paperWidthHeader)}
${centerText('ออกใบกำกับภาษีโดยสำนักงานใหญ่', paperWidthHeader)}
${centerText('($typeBill)', paperWidthHeader)}
${centerText('เอกสารออกเป็นชุด', paperWidthHeader)}''';
    Uint8List encodedContent = await CharsetConverter.encode('TIS-620', header);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedContent));
  }

  Future<void> printHeaderSeparator() async {
    String header =
        '''\n${centerTextSeparator('ตัดตามรอยปะ', paperWidth)}\n\n\n''';
    Uint8List encodedContent = await CharsetConverter.encode('TIS-620', header);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedContent));
  }

  String centerTextSeparator(String text, int width) {
    int totalPadding = width - text.length;
    int leftPadding = totalPadding ~/ 2;
    int rightPadding = totalPadding - leftPadding;
    return '-' * leftPadding + text + '-' * rightPadding;
  }

  Future<void> _printText(String text,
      {int fontSize = 1, bool isBold = false, int newLine = 1}) async {
    // Convert text to TIS-620 encoding
    Uint8List encodedText = await CharsetConverter.encode(encoding, text);

    // Print the encoded text
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedText));
  }

  int _getNoOfUpperLowerChars(String text) {
    int counter = 0;
    for (var char in vowelAndToneMark) {
      counter += char.allMatches(text).length;
    }
    return counter;
  }

  Future<void> printBill(String text,
      {TextAlign align = TextAlign.left,
      int newLine = 1,
      int fontSize = 1,
      bool isBold = false}) async {
    String alignedText;

    switch (align) {
      case TextAlign.center:
        alignedText = text.padLeft((paperWidth + text.length) ~/ 2);
        break;
      case TextAlign.right:
        alignedText = text.padLeft(paperWidth);
        break;
      default:
        alignedText = text;
    }

    await _printText(alignedText,
        fontSize: fontSize, isBold: isBold, newLine: newLine);
  }

  Future<void> printBetween(String frontText, String backText,
      {int fontSize = 1, bool isBold = false}) async {
    int frontSpaces = paperWidth ~/ 2 + _getNoOfUpperLowerChars(frontText);
    int backSpaces = paperWidth ~/ 2 + _getNoOfUpperLowerChars(backText);

    String formattedText =
        frontText.padRight(frontSpaces) + backText.padLeft(backSpaces);
    await _printText(formattedText, fontSize: fontSize, isBold: isBold);
  }

  String thaiNumberToWords(double amount) {
    String convert(int number) {
      final values = [
        '',
        'หนึ่ง',
        'สอง',
        'สาม',
        'สี่',
        'ห้า',
        'หก',
        'เจ็ด',
        'แปด',
        'เก้า'
      ];
      final places = ['', 'สิบ', 'ร้อย', 'พัน', 'หมื่น', 'แสน', 'ล้าน'];
      final exceptions = {
        'หนึ่งสิบ': 'สิบ',
        'สองสิบ': 'ยี่สิบ',
        'สิบหนึ่ง': 'สิบเอ็ด'
      };

      String output = '';
      var numStr = number.toString().split('').reversed.toList();

      for (int i = 0; i < numStr.length; i++) {
        if (i % 6 == 0 && i > 0) output = places[6] + output;
        if (numStr[i] != '0')
          output = values[int.parse(numStr[i])] + places[i % 6] + output;
      }

      exceptions.forEach((search, replace) {
        output = output.replaceAll(search, replace);
      });

      return output;
    }

    List<String> parts = amount.toStringAsFixed(2).split('.');
    String baht = convert(int.parse(parts[0]));
    String satang = convert(int.parse(parts[1]));
    String output = amount < 0 ? 'ลบ' : '';
    output += baht.isNotEmpty ? '$bahtบาท' : '';
    output += satang.isNotEmpty ? '$satangสตางค์' : 'ถ้วน';

    return output.isEmpty ? 'ศูนย์บาทถ้วน' : output;
  }

  String formatFixedWidthRow2(String itemName, String qty, String unit,
      String price, String discount, String total) {
    const int nameWidth = 31;
    const int qtyWidth = 3;
    const int unitWidth = 5;
    const int priceWidth = 8;
    const int discountWidth = 8;
    const int totalWidth = 8;
    List<String> wrapText(String text, int width) {
      List<String> lines = [];
      for (int i = 0; i < text.length; i += width) {
        lines.add(text.substring(
            i, i + width > text.length ? text.length : i + width));
      }
      return lines;
    }

    List<String> itemNameLines = wrapText(itemName, nameWidth);
    for (var i = 0; i < itemNameLines.length; i++) {
      for (var j = itemNameLines[i].length; j < nameWidth; j++) {
        itemNameLines[i] += ' ';
      }
    }

    String formattedQty = qty.padLeft(qtyWidth);
    String formattedUnit =
        unit.padRight(unitWidth + _getNoOfUpperLowerChars(unit));
    String formattedPrice = price.padLeft(priceWidth);
    String formattedDiscount = discount.padLeft(discountWidth);
    String formattedTotal = total.padLeft(totalWidth);
    // Format each line with wrapped itemName
    StringBuffer rowBuffer = StringBuffer();
    for (int i = 0; i < itemNameLines.length; i++) {
      // First line includes all columns, subsequent lines only contain `itemName`
      rowBuffer.write(
          itemNameLines[i].padRight(18 + _getNoOfUpperLowerChars(itemName)));
      if (i == 0) {
        // First line includes other columns
        rowBuffer.write(
            '${'   $formattedQty'}${' $formattedUnit'}${'  $formattedPrice'}${' $formattedDiscount'}${' $formattedTotal'}\n');
      } else {
        // Subsequent lines only contain the item name to create a wrapped effect
        rowBuffer.write('\n');
      }
    }
    return rowBuffer.toString();
  }

  String leftRightText(String left, String right, int width) {
    int space = width - left.length - right.length;
    return left + ' ' * space + right;
  }

  Future<void> printBodyBill(Map<String, dynamic> data) async {
    await printBetween('รหัสลูกค้า ${data['customer']['customercode']}',
        'เลขที่ ${data['CUOR']}');
    await printBetween('ชื่อลูกค้า ${data['customer']['customername']}',
        'วันที่ ${data['OAORDT']}');
    await printBill(
        'ที่อยู่ ${data['customer']['address1']} ${data['customer']['address2']} ${data['customer']['address3']}');

    await printBill('เลชประจำตัวผู้เสียภาษี ${data['customer']['taxno']}');
    // String body = formatFixedWidthRow2(
    //     'รายการสินค้า', 'จํานวน', '', 'ราคา', 'ส่วนลด', 'รวม');
    String body = '''
รายการสินค้า${' ' * (21)}จำนวน${' ' * (10)}ราคา${' ' * (4)}ส่วนลด${' ' * (6)}รวม
''';
    // Print table header
//     String header = '''
// ${padThaiText('รายการสินค้า', nameWidth)}${padThaiText('จำนวน', 11)}${padThaiText('ราคา', priceWidth)}${padThaiText('ส่วนลด', discountWidth)}${padThaiText('รวม', totalWidth)}
// ''';
    Uint8List encodedBody = await CharsetConverter.encode('TIS-620', body);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedBody));

    String items = await data['items'].asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      // Safely get a substring only if the length is greater than 36
      String itemName = item['name'];
      return formatFixedWidthRow2(
        '${(index + 1).toString()} $itemName',
        item['qty'],
        item['unit'],
        item['price'],
        item['disamount'],
        item['itemamount'],
      );
    }).join('\n');
    Uint8List encodedItems = await CharsetConverter.encode('TIS-620', items);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedItems));

    double? totalValue = double.tryParse(data['totaltext'] ?? "00.00");
    String totalText = thaiNumberToWords(totalValue!);
    await printBetween('รวมมูลค่าสินค้า', data['ex_vat'].toString());
    await printBetween('ส่วนลด', '0.00');
    await printBetween('ภาษีมูลค่าเพิ่ม 7%', data['vat'].toString());
    await printBetween('ส่วนลดท้ายบิล', data['discountProduct'].toString());
    await printBetween('ส่วนลดร้านค้า', data['discount'].toString());
    await printBetween('จำนวนเงินรวมสุทธิ', data['total'].toString());
    await printBetween("", "($totalText)");
    String footer = '''
    ${leftRightText('ผู้รับเงิน ${data['OBSMCD']}', '.........................', 70)}
    ${leftRightText('', 'ลายเซ็นลูกค้า', 58)}
    ''';
    Uint8List encodedFooter = await CharsetConverter.encode('TIS-620', footer);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedFooter));
  }

  Future<void> _disconnectPrinter() async {
    bool result = await PrintBluetoothThermal.disconnect;
    print("Printer disconnected ($result)");
    setState(() {
      _connected = !result;
      _selectedDevice = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Printer disconnected")),
    );
  }

  Future<void> _connectToPrinter(BluetoothInfo device) async {
    bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress);
    setState(() {
      _connected = result;
      _selectedDevice = result ? device : null;
    });

    final snackBarText = result
        ? "เชื่อมต่อแล้วกับอุปกรณ์ ${device.name}"
        : "การเชื่อมต่อล้มเหลว ${device.name}";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarText)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _cartScrollController.dispose();
    _promotionScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppbarCustom(
          title: " รายละเอียดออเดอร์",
          icon: FontAwesomeIcons.clipboardList,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Container(
                    height:
                        MediaQuery.of(context).size.height * 0.9, // Set height
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            BoxShadowCustom(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "${widget.storeId}",
                                          "${storeDetail?.name} ${storeDetail?.storeId}",
                                          style: Styles.black24(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "${widget.storeId}",
                                          "เลขที่ผู้เสียภาษี : ${storeDetail?.taxId}",
                                          style: Styles.black18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "${widget.storeId}",
                                          "เบอร์โทรศัพท์ : ${storeDetail?.tel}",
                                          style: Styles.black18(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "ที่อยู่การจัดส่ง",
                                          style: Styles.black18(context),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                elevation: 0, // Disable shadow
                                                shadowColor: Colors
                                                    .transparent, // Ensure no shadow color
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .zero, // No rounded corners
                                                  side: BorderSide
                                                      .none, // Remove border
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color: Colors.black,
                                                          size: 30,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            // " ${widget.storeAddress}",
                                                            "${storeDetail?.address}",
                                                            style:
                                                                Styles.grey18(
                                                                    context),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              onPressed: () {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "${widget.storeId}",
                                          "พนักงานขาย : ${saleDetail?.name} เขต ${saleDetail?.warehouse}",
                                          style: Styles.black24(context),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "${widget.storeId}",
                                          "เบอร์โทรศัพท์ : ${saleDetail?.tel}",
                                          style: Styles.black18(context),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: BoxShadowCustom(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: screenHeight * 0.9,
                                    // color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "รายการที่สั่ง",
                                                style: Styles.black18(context),
                                              ),
                                              Text(
                                                "จำนวน ${listProduct.length} รายการ",
                                                style: Styles.black18(context),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: Scrollbar(
                                            controller: _cartScrollController,
                                            thumbVisibility: true,
                                            trackVisibility: true,
                                            radius: Radius.circular(16),
                                            thickness: 10,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              controller: _cartScrollController,
                                              itemCount: listProduct.length,
                                              itemBuilder: (context, index) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.network(
                                                            'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                            width:
                                                                screenWidth / 8,
                                                            height:
                                                                screenWidth / 8,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return const Center(
                                                                child: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        listProduct[index]
                                                                            .name,
                                                                        style: Styles.black16(
                                                                            context),
                                                                        softWrap:
                                                                            true,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              'จำนวน : ${listProduct[index].qty.toStringAsFixed(0)} ${listProduct[index].unit}',
                                                                              style: Styles.black16(context),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              'ราคา : ${listProduct[index].price}',
                                                                              style: Styles.black16(context),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[200],
                                                      thickness: 1,
                                                      indent: 16,
                                                      endIndent: 16,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: viewportConstraints.maxHeight * 0.4,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BoxShadowCustom(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "รายการโปรโมชั่น",
                                            style: Styles.black18(context),
                                          ),
                                          Text(
                                            "จำนวน ${listPromotions.length} รายการ",
                                            style: Styles.black18(context),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                          child: Container(
                                        height:
                                            200, // Set a height to avoid rendering errors
                                        child: Scrollbar(
                                          controller:
                                              _promotionScrollController,
                                          thumbVisibility: true,
                                          trackVisibility: true,
                                          radius: Radius.circular(16),
                                          thickness: 10,
                                          child: ListView.builder(
                                              controller:
                                                  _promotionScrollController,
                                              itemCount:
                                                  listPromotionItems.length,
                                              itemBuilder:
                                                  (context, innerIndex) {
                                                return Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Image.network(
                                                            'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                                            width:
                                                                screenWidth / 8,
                                                            height:
                                                                screenWidth / 8,
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return const Center(
                                                                child: Icon(
                                                                  Icons.error,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 50,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        listPromotionItems[innerIndex]
                                                                            .name,
                                                                        style: Styles.black16(
                                                                            context),
                                                                        softWrap:
                                                                            true,
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.visible,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                // Row(
                                                                //   children: [
                                                                //     Expanded(
                                                                //       child: Text(
                                                                //         listPromotions[
                                                                //                 innerIndex]
                                                                //             .proName,
                                                                //         style: Styles
                                                                //             .black16(
                                                                //                 context),
                                                                //         softWrap: true,
                                                                //         maxLines: 2,
                                                                //         overflow:
                                                                //             TextOverflow
                                                                //                 .visible,
                                                                //       ),
                                                                //     ),
                                                                //   ],
                                                                // ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${listPromotionItems[innerIndex].id}',
                                                                              style: Styles.black16(context),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Text(
                                                                              '${listPromotionItems[innerIndex].group} รส${listPromotionItems[innerIndex].flavour}',
                                                                              style: Styles.black16(context),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(4),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.grey,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                          ),
                                                                          width:
                                                                              75,
                                                                          child:
                                                                              Text(
                                                                            '${listPromotionItems[innerIndex].qty.toStringAsFixed(0)} ${listPromotionItems[innerIndex].unit}',
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                            style:
                                                                                Styles.black18(
                                                                              context,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // _showCartSheet(context, cartList);
                                                                          },
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shape:
                                                                                CircleBorder(
                                                                              side: BorderSide(color: Styles.warning!, width: 1),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(8),
                                                                            backgroundColor:
                                                                                Colors.white, // Button color
                                                                          ),
                                                                          child:
                                                                              Icon(
                                                                            FontAwesomeIcons.penToSquare,
                                                                            size:
                                                                                24,
                                                                            color:
                                                                                Styles.warning!,
                                                                          ), // Example
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[200],
                                                      thickness: 1,
                                                      indent: 16,
                                                      endIndent: 16,
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BoxShadowCustom(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "รวมมูลค่าสินค้า",
                                      style: Styles.grey18(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(subtotal)} บาท",
                                      style: Styles.grey18(context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ภาษีมูลค่าเพิ่ม 7% (VAT)",
                                      style: Styles.grey18(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(vat)} บาท",
                                      style: Styles.grey18(context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "รวมมูลค่าสินค้าก่อนหักภาษี",
                                      style: Styles.grey18(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(totalExVat)} บาท",
                                      style: Styles.grey18(context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ส่วนลดท้ายบิล",
                                      style: Styles.red18(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(discount)} บาท",
                                      style: Styles.red18(context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "ส่วนลดสินค้า",
                                      style: Styles.red18(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(discountProduct)} บาท",
                                      style: Styles.red18(context),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "จำนวนเงินรวมสุทธิ",
                                      style: Styles.green24(context),
                                    ),
                                    Text(
                                      "฿${NumberFormat.currency(locale: 'th_TH', symbol: '').format(total)} บาท",
                                      style: Styles.green24(context),
                                    )
                                  ],
                                ),
                                // Row(
                                //   children: [
                                //     Text(
                                //       "ชำระเงินโดย",
                                //       style: Styles.black18(context),
                                //     ),
                                //   ],
                                // ),
                                // Row(
                                //   children: [
                                //     Expanded(
                                //       child: Container(
                                //         width: double.infinity,
                                //         child: ElevatedButton(
                                //           style: ElevatedButton.styleFrom(
                                //             padding:
                                //                 const EdgeInsets.all(0),
                                //             elevation:
                                //                 0, // Disable shadow
                                //             shadowColor: Colors
                                //                 .transparent, // Ensure no shadow color
                                //             backgroundColor: Colors.white,
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius
                                //                   .zero, // No rounded corners
                                //               side: BorderSide
                                //                   .none, // Remove border
                                //             ),
                                //           ),
                                //           child: Row(
                                //             mainAxisAlignment:
                                //                 MainAxisAlignment
                                //                     .spaceBetween,
                                //             children: [
                                //               Row(
                                //                 children: [
                                //                   ClipRRect(
                                //                     borderRadius:
                                //                         BorderRadius
                                //                             .circular(8),
                                //                     child: Image.network(
                                //                       'https://jobbkk.com/upload/employer/0D/53D/03153D/images/202045.webp',
                                //                       width: screenWidth /
                                //                           15,
                                //                       height:
                                //                           screenWidth /
                                //                               15,
                                //                       fit: BoxFit.cover,
                                //                       errorBuilder:
                                //                           (context, error,
                                //                               stackTrace) {
                                //                         return const Center(
                                //                           child: Icon(
                                //                             Icons.error,
                                //                             color: Colors
                                //                                 .red,
                                //                             size: 50,
                                //                           ),
                                //                         );
                                //                       },
                                //                     ),
                                //                   ),
                                //                   Text(
                                //                     " QR พร้อมเพย์",
                                //                     style: Styles.grey18(
                                //                         context),
                                //                   )
                                //                 ],
                                //               ),
                                //               Icon(
                                //                 Icons
                                //                     .arrow_forward_ios_rounded,
                                //                 color: Colors.black,
                                //                 size: 20,
                                //               )
                                //             ],
                                //           ),
                                //           onPressed: () {
                                //             Navigator.push(
                                //               context,
                                //               MaterialPageRoute(
                                //                 builder: (context) =>
                                //                     CheckOutScreen(),
                                //               ),
                                //             );
                                //           },
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  _devices.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BoxShadowCustom(
                              child: Container(
                                height: viewportConstraints.maxHeight * 0.2,
                                // color: Colors.red,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "อุปกรณ์ที่พบ",
                                            style: Styles.black18(context),
                                          ),
                                          Text(
                                            "${_devices.length} รายการ",
                                            style: Styles.black18(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: _devices.length,
                                        itemBuilder: (context, index) {
                                          final device = _devices[index];
                                          return ListTile(
                                            title: Text(
                                              device.name ?? "Unknown Device",
                                              style: Styles.black18(context),
                                            ),
                                            subtitle: Text(
                                              device.macAdress,
                                              style: Styles.black18(context),
                                            ),
                                            trailing: _connected &&
                                                    _selectedDevice == device
                                                ? Icon(Icons.check,
                                                    color: Colors.green)
                                                : null,
                                            onTap: () =>
                                                _connectToPrinter(device),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text("No paired devices found"),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Styles.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    // await _getOrderDetail();
                    await printTest();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.print,
                              color: Colors.white,
                              size: 25,
                            ),
                            Text(
                              " พิมพ์ใบสั่งซื้อ",
                              style: Styles.headerWhite18(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    backgroundColor: Styles.fail,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => OrderDetailScreen()),
                    // );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ยกเลิกออร์เดอร์",
                          style: Styles.headerWhite18(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
