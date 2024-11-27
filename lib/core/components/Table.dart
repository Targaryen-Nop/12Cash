import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';

class CustomTable extends StatefulWidget {
  const CustomTable({super.key});

  @override
  State<CustomTable> createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'วันที่',
            style: Styles.black18(context),
          ),
        ),
        DataColumn(
          label: Text(
            'เส้นทาง',
            style: Styles.black18(context),
          ),
        ),
        DataColumn(
          label: Text(
            'สถานะ',
            style: Styles.black18(context),
          ),
        ),
      ],
      rows: <DataRow>[
        _buildDataRow('Day 01', '1', '5/5', Colors.green[100], Colors.green),
        _buildDataRow('Day 02', '2', '6/6', Colors.green[100], Colors.green),
        _buildDataRow('Day 03', '4', '0/9', Colors.red[100], Colors.red),
        _buildDataRow('Day 04', '5', '11/16', Colors.blue[100], Colors.blue),
        _buildDataRow('Day 05', '6', '2/9', Colors.blue[100], Colors.blue),
        _buildDataRow('Day 06', '7', '9/9', Colors.green[100], Colors.green),
        _buildDataRow('Day 06', '7', '9/9', Colors.green[100], Colors.green),
        _buildDataRow('Day 06', '7', '9/9', Colors.green[100], Colors.green),
        _buildDataRow('Day 06', '7', '9/9', Colors.green[100], Colors.green),
        _buildDataRow('Day 06', '7', '9/9', Colors.green[100], Colors.green),
        _buildDataRow('Day 7', '7', '9/9', Colors.green[100], Colors.green),
      ],
    );
  }

  DataRow _buildDataRow(String day, String route, String status, Color? bgColor,
      Color? textColor) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(
          day,
          style: TextStyle(color: Colors.black, fontSize: 18),
        )), // Text(day,)),
        DataCell(Text(
          route,
          style: TextStyle(color: Colors.black, fontSize: 18),
        )),
        DataCell(
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
