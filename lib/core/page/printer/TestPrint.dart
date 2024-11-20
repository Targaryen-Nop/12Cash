// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class ReceiptPrinterScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Receipt Printer")),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
//               final pdf = pw.Document();

//               pdf.addPage(
//                 pw.Page(
//                   pageFormat: format,
//                   build: (context) {
//                     return pw.Column(
//                       crossAxisAlignment: pw.CrossAxisAlignment.start,
//                       children: [
//                         pw.Text('บริษัท วันบูรณ์เทรดดิ้ง จำกัด',
//                             style: pw.TextStyle(
//                                 fontSize: 14, fontWeight: pw.FontWeight.bold)),
//                         pw.Text(
//                             '58/3 หมู่ที่ 6 ถ.พระประโทน-บ้านแพ้ว, ต.ดอนตูม, อ.ดอนตูม, จ.นครปฐม 73110',
//                             style: pw.TextStyle(fontSize: 10)),
//                         pw.Text('โทร: (034) 981-555',
//                             style: pw.TextStyle(fontSize: 10)),
//                         pw.SizedBox(height: 10),
//                         pw.Text('รหัสลูกค้า VB22600260',
//                             style: pw.TextStyle(fontSize: 10)),
//                         pw.Text('ชื่อลูกค้า: เจ๊โฉลก',
//                             style: pw.TextStyle(fontSize: 10)),
//                         pw.Text(
//                             'ที่อยู่: 172/1 ต.ศรีมหาโพธิ์, อ.ปากน้ำ, จ.สมุทรปราการ 10270',
//                             style: pw.TextStyle(fontSize: 10)),
//                         pw.SizedBox(height: 20),

//                         // Table Header
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('รายการสินค้า',
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.Text('จำนวน',
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.Text('ราคา',
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.Text('ส่วนลด',
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.Text('รวม',
//                                 style: pw.TextStyle(
//                                     fontSize: 10,
//                                     fontWeight: pw.FontWeight.bold)),
//                           ],
//                         ),
//                         pw.Divider(),
//                         // Example Item Row
//                         _buildTableRow('เมจิรุ้งหมูแดง ครึ่งตัว 5kg x4', '2',
//                             '1455.00', '0.00', '2910.00'),
//                         _buildTableRow('เมจิรุ้งหมูแดง 165g x6', '1', '762.00',
//                             '0.00', '762.00'),
//                         pw.Divider(),

//                         // Total Section
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('รวมค่าสินค้า'),
//                             pw.Text('3,672.00',
//                                 style: pw.TextStyle(
//                                     fontWeight: pw.FontWeight.bold))
//                           ],
//                         ),
//                         pw.SizedBox(height: 20),

//                         // Signature Area
//                         pw.Row(
//                           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                           children: [
//                             pw.Text('ลงชื่อผู้รับเงิน 20359-คุณจาง'),
//                             pw.Text('ลายเซ็นลูกค้า')
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               );

//               return pdf.save();
//             });
//           },
//           child: Text("Print Receipt"),
//         ),
//       ),
//     );
//   }

//   pw.Widget _buildTableRow(String product, String quantity, String price,
//       String discount, String total) {
//     return pw.Row(
//       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//       children: [
//         pw.Expanded(child: pw.Text(product, style: pw.TextStyle(fontSize: 10))),
//         pw.Text(quantity, style: pw.TextStyle(fontSize: 10)),
//         pw.Text(price, style: pw.TextStyle(fontSize: 10)),
//         pw.Text(discount, style: pw.TextStyle(fontSize: 10)),
//         pw.Text(total, style: pw.TextStyle(fontSize: 10)),
//       ],
//     );
//   }
// }
