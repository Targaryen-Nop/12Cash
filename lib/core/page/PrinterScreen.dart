import 'dart:typed_data';

import 'package:_12sale_app/core/page/StingHelper.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'dart:convert';

class BluetoothPrinterScreen4 extends StatefulWidget {
  @override
  _BluetoothPrinterScreen4State createState() =>
      _BluetoothPrinterScreen4State();
}

class _BluetoothPrinterScreen4State extends State<BluetoothPrinterScreen4> {
  List<BluetoothInfo> _devices = [];
  bool _connected = false;
  BluetoothInfo? _selectedDevice;
  final int paperWidth = 69;
  final int paperWidthHeader = 76;

  final Map<String, dynamic> receiptData = {
    "customer": {
      "customercode": "VB22600260",
      "customername": "เจ๊โฉลก",
      "address1": "172/1 ต.ศรีมหาโพธิ์",
      "address2": "อ.ปากน้ำ",
      "address3": "จ.สมุทรปราการ",
      "postcode": "10270",
      "taxno": "1234567890123",
      "salecode": "20359-คุณจาง"
    },
    "CUOR": "6707132130012",
    "OAORDT": "06/07/2024",
    "items": [
      {
        "itemname": "เมจิรุ้งหมูแดง แฮดชิ้น 5kg x4",
        "qtytext": "21",
        "unit": "ซอง",
        "OBSAPR": "1455.00",
        "disamount": "0.00",
        "itemamount": "2910.00"
      },
      {
        "itemname": "เมจิรุ้งหมูแดง 165g x6",
        "qtytext": "1",
        "unit": "หีบ",
        "OBSAPR": "762.00",
        "disamount": "0.00",
        "itemamount": "762.00"
      },
      {
        "itemname": "เมจิรุ้งหมูแดง แฮดชิ้น 5kg x1",
        "qtytext": "1",
        "unit": "ถุง",
        "OBSAPR": "0.00",
        "disamount": "0.00",
        "itemamount": "0.00"
      },
      {
        "itemname": "เมจิรุ้งหมูแดง 75g x10 x8",
        "qtytext": "6",
        "unit": "ถุง",
        "OBSAPR": "0.00",
        "disamount": "102.00",
        "itemamount": "0.00"
      },
      {
        "itemname": "เมจิรุ้งหมูแดง 165g x6",
        "qtytext": "13",
        "unit": "ซอง",
        "OBSAPR": "0.00",
        "disamount": "0.00",
        "itemamount": "0.00"
      }
    ],
    "totaltext": "3672.45",
    "ex_vat": "3431.78",
    "vat": "240.22",
    "totaldis": "0.00",
    "total": "3672.45",
    "OBSMCD": "ลูกนง ปทุมศรี"
  };

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

  @override
  void initState() {
    super.initState();
    _fetchPairedDevices();
  }

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

  Future<void> _connectToPrinter(BluetoothInfo device) async {
    bool result = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.macAdress);
    setState(() {
      _connected = result;
      _selectedDevice = result ? device : null;
    });

    final snackBarText = result
        ? "Connected to ${device.name}"
        : "Failed to connect to ${device.name}";
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarText)));
  }

  // --------------------------- Printer Test--------------------------
  int getNoOfUpperLowerChar(String text) {
    int counter = 0;
    for (var char in text.characters) {
      if (vowelAndToneMark.contains(char)) {
        counter++;
      }
    }
    return counter;
  }

  Future<void> printBetween(String frontText, String backText,
      {int fontSize = 1, bool isBold = false}) async {
    int frontSpaces = paperWidth ~/ 2 + _getNoOfUpperLowerChars(frontText);
    int backSpaces = paperWidth ~/ 2 + _getNoOfUpperLowerChars(backText);

    String formattedText =
        frontText.padRight(frontSpaces) + backText.padLeft(backSpaces);
    await _printText(formattedText, fontSize: fontSize, isBold: isBold);
  }

  int _getNoOfUpperLowerChars(String text) {
    int counter = 0;
    for (var char in vowelAndToneMark) {
      counter += char.allMatches(text).length;
    }
    return counter;
  }

  Future<void> _printText(String text,
      {int fontSize = 1, bool isBold = false, int newLine = 1}) async {
    // Convert text to TIS-620 encoding
    Uint8List encodedText = await CharsetConverter.encode(encoding, text);

    // Print the encoded text
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedText));

    // Add newline characters
    // for (int i = 0; i < newLine; i++) {
    //   await PrintBluetoothThermal.writeBytes([10]); // ASCII newline code
    // }
  }

  String leftRightText(String left, String right, int width) {
    int space = width - left.length - right.length;
    return left + ' ' * space + right;
  }

  String centerText(String text, int width) {
    int leftPadding = (width - text.length) ~/ 2;
    return ' ' * leftPadding + text;
  }

  String leftText(String text, int width) {
    return text.padRight(width);
  }

  String rightText(String text, int width) {
    return text.padLeft(width);
  }

  String padThaiText(String text, int length) {
    int extraSpaces = getNoOfUpperLowerChar(text);
    return text.padRight(length + extraSpaces);
  }

  Future<void> printTest() async {
    bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
    if (connectionStatus) {
      await printHeaderBill();
      await printBodyBill(receiptData);
      // Print header
      // final receiptContent =
      //     await formatReceipt(receiptData); // Format the receipt content
      // Encode the receipt text for TIS-620 before sending to the printer
      // Uint8List encodedContent =
      //     await CharsetConverter.encode('TIS-620', receiptContent);
      // // Send the encoded content to the Bluetooth printer
      // await PrintBluetoothThermal.writeBytes(List<int>.from(encodedContent));

      // Convert each section of the text to UTF-8 before sending to the printer
    } else {
      print("Printer is disconnected ($connectionStatus)");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Printer is not connected")),
      );
    }
  }

  Future<void> printHeaderBill() async {
    String header = '''
${centerText('บริษัท วันทูเทรดดิ้ง จำกัด', paperWidthHeader)}
${centerText('58/3 หมู่ที่ 6 ถ.พระประโทน-บ้านแพ้ว', paperWidthHeader)}
${centerText('ต.ตลาดจินดา อ.สามพราน จ.นครปฐม 73110', paperWidthHeader)}
${centerText('โทร.(034) 981-555', paperWidthHeader)}
${centerText('เลขประจำตัวผู้เสียภาษี 0105563063410', paperWidthHeader)}
${centerText('ออกใบกำกับภาษีโดยสำนักงานใหญ่', paperWidthHeader)}
${centerText('(บิลเงินสด/ใบกำกับภาษี)', paperWidthHeader)}
${centerText('เอกสารออกเป็นชุด', paperWidthHeader)}''';
    Uint8List encodedContent = await CharsetConverter.encode('TIS-620', header);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedContent));
  }

  Future<void> printBodyBill(Map<String, dynamic> data) async {
    const int nameWidth = 20; // Width for item name
    const int qtyWidth = 10; // Width for quantity
    const int discountWidth = 10; // Width for discount

    await printBetween('รหัสลูกค้า ${data['customer']['customercode']}',
        'เลขที่ ${data['CUOR']}');
    await printBetween('ชื่อลูกค้า ${data['customer']['customername']}',
        'วันที่ ${data['OAORDT']}');

    String body = '''
รายการสินค้า${' ' * (nameWidth - 4)}จำนวน${' ' * (qtyWidth - 4)}ราคา${' ' * (discountWidth - 2)}ส่วนลด${' ' * (discountWidth - 2)}รวม
''';
    Uint8List encodedBody = await CharsetConverter.encode('TIS-620', body);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedBody));

    String items = await data['items'].asMap().entries.map((entry) {
      int index = entry.key;
      var item = entry.value;

      // Safely get a substring only if the length is greater than 36
      String itemName = item['itemname'];
      return formatFixedWidthRow(
        '${(index + 1).toString()} $itemName',
        item['qtytext'],
        item['unit'],
        item['OBSAPR'],
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
    await printBetween('ส่วนลดท้ายบิล', '00.00');
    await printBetween('ส่วนลดร้านค้า', data['totaldis'].toString());
    await printBetween('จำนวนเงินรวมสุทธิ', data['total'].toString());
    await printBetween("", "($totalText)");
    String footer = '''
    ${leftRightText('ผู้รับเงิน ${data['OBSMCD']}', '.........................', 70)}
    ${leftRightText('', 'ลายเซ็นลูกค้า', 58)}
    ''';
    Uint8List encodedFooter = await CharsetConverter.encode('TIS-620', footer);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedFooter));

//     String footer = '''
// ${leftRightText('ส่วนลด', '0.00', paperWidth)}
// ${leftRightText('ภาษีมูลค่าเพิ่ม 7%', data['vat'].toString(), paperWidth)}
// ${leftRightText('ส่วนลดท้ายบิล', '0.00', paperWidth)}
// ${leftRightText('ส่วนลดร้านค้า', data['totaldis'].toString(), paperWidth)}
// ${leftRightText('จำนวนเงินรวมสุทธิ', data['total'].toString(), paperWidth)}
// ${rightText('($totalText)', paperWidth)}
// ${leftRightText('ผู้รับเงิน ${data['OBSMCD']}', '.........................', paperWidth)}
// ${leftRightText('', 'ลายเซ็นลูกค้า', paperWidth)}
// ''';
  }

  String formatItemRow(String index, String itemName, String qty, String price,
      String discount, String total) {
    const int indexWidth = 3;
    const int itemNameWidth = 30;
    const int qtyWidth = 8;
    const int priceWidth = 10;
    const int discountWidth = 10;
    const int totalWidth = 10;

    String formattedIndex = index.padRight(indexWidth);
    String formattedQty = qty.padLeft(qtyWidth);
    String formattedPrice = price.padLeft(priceWidth);
    String formattedDiscount = discount.padLeft(discountWidth);
    String formattedTotal = total.padLeft(totalWidth);

    // Split item name if it exceeds the width
    List<String> wrappedItemName = _wrapText(itemName, itemNameWidth);

    // Build the first row with index, item name, qty, price, discount, and total
    String formattedRow =
        '$formattedIndex${wrappedItemName[0].padRight(itemNameWidth)}'
        '$formattedQty$formattedPrice$formattedDiscount$formattedTotal';

    // Append any additional lines for wrapped item names, aligning them to the item column
    for (int i = 1; i < wrappedItemName.length; i++) {
      formattedRow += '\n' +
          ' '.padRight(indexWidth) +
          wrappedItemName[i].padRight(itemNameWidth) +
          ' ' *
              (qtyWidth +
                  priceWidth +
                  discountWidth +
                  totalWidth); // Fill remaining columns with spaces
    }

    return formattedRow;
  }

  static List<String> _wrapText(String text, int maxWidth) {
    List<String> lines = [];
    while (text.length > maxWidth) {
      lines.add(text.substring(0, maxWidth));
      text = text.substring(maxWidth);
    }
    lines.add(text); // Add remaining text
    return lines;
  }

  String formatFixedWidthRow(String itemName, String qty, String unit,
      String price, String discount, String total) {
    const int nameWidth = 20;
    const int qtyWidth = 7;
    const int qtyunit = 3;
    const int priceWidth = 10;
    const int discountWidth = 10;
    const int totalWidth = 10;

    // // Define fixed widths for each column
    // const int nameWidth = 20; // Width for item name
    // const int qtyWidth = 15; // Width for quantity
    // const int priceWidth = 10; // Width for price
    // const int discountWidth = 10; // Width for discount
    // const int totalWidth = 10; // Width for total
    // Helper to split long text into lines of fixed width
    List<String> wrapText(String text, int width) {
      List<String> lines = [];
      for (int i = 0; i < text.length; i += width) {
        lines.add(text.substring(
            i, i + width > text.length ? text.length : i + width));
      }
      return lines;
    }

    // Wrap `itemName` if it exceeds the width
    List<String> itemNameLines = wrapText(itemName, nameWidth);

    // For other columns, align text to the right by padding on the left
    String formattedQty = qty.padLeft(qtyWidth);
    String formattedUnit = unit.padLeft(qtyunit);
    String formattedPrice = StringHelper.padLeftWithSpaces(price, priceWidth);
    String formattedDiscount =
        StringHelper.padLeftWithSpaces(discount, discountWidth);
    String formattedTotal = StringHelper.padLeftWithSpaces(total, totalWidth);

    // Format each line with wrapped itemName
    StringBuffer rowBuffer = StringBuffer();
    for (int i = 0; i < itemNameLines.length; i++) {
      // First line includes all columns, subsequent lines only contain `itemName`
      rowBuffer
          .write(StringHelper.padRightWithSpaces(itemNameLines[i], nameWidth));
      if (i == 0) {
        // First line includes other columns
        rowBuffer.write(
            '${'    $formattedQty '}${'$formattedUnit'}${formattedPrice + '  '}${formattedDiscount + '  '}${formattedTotal + '  '}\n');
      } else {
        // Subsequent lines only contain the item name to create a wrapped effect
        rowBuffer.write('\n');
      }
    }
    return rowBuffer.toString();
  }

  String formatItem(String no, String name, String qty, String price,
      String discount, String total) {
    return '$no ${padThaiText(name, 31)} ${padThaiText(qty, 7)} ${rightText(price, 6)} ${rightText(discount, 6)} ${rightText(total, 11)}';
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

  // Convert a UTF-8 string to Windows-874 encoded bytes

  Future<void> _printUtf8Text(String text,
      {bool isBold = false, int size = 1}) async {
    // final encodedText = utf8.encode(text); // Convert text to UTF-8 bytes
    Uint8List encodedText = await CharsetConverter.encode('TIS-620', text);
    await PrintBluetoothThermal.writeBytes(
        List<int>.from(encodedText)); // Ensure List<int> type
  }

  Future<void> _printItemRowUtf8(String product, String quantity, String price,
      String discount, String total) async {
    String formattedRow =
        "$product${_alignTextLeftRight(quantity, 10)}${_alignTextLeftRight(price, 100)}${_alignTextLeftRight(discount, 100)}$total\n";
    // final encodedText = utf8.encode(formattedRow); // Encode row to UTF-8 bytes
    Uint8List encodedText =
        await CharsetConverter.encode('TIS-620', formattedRow);
    await PrintBluetoothThermal.writeBytes(List<int>.from(encodedText));
  }

  String _alignTextLeftRight(String text, int width) {
    return text.padRight(width);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bluetooth Printers"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _devices.isNotEmpty
                ? ListView.builder(
                    itemCount: _devices.length,
                    itemBuilder: (context, index) {
                      final device = _devices[index];
                      return ListTile(
                        title: Text(device.name ?? "Unknown Device"),
                        subtitle: Text(device.macAdress),
                        trailing: _connected && _selectedDevice == device
                            ? Icon(Icons.check, color: Colors.green)
                            : null,
                        onTap: () => _connectToPrinter(device),
                      );
                    },
                  )
                : Center(child: Text("No paired devices found")),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Print Test"),
                  onPressed: _connected ? printTest : null,
                ),
                ElevatedButton(
                  child: Text("Disconnect"),
                  onPressed: _connected ? _disconnectPrinter : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
