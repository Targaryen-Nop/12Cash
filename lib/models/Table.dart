import 'package:flutter/material.dart';

class TableRowData {
  final String day;
  final String path;
  final String status;
  final Color statusColor;

  TableRowData({
    required this.day,
    required this.path,
    required this.status,
    required this.statusColor,
  });

  // Factory constructor for creating a new instance from a map
  factory TableRowData.fromMap(Map<String, dynamic> map) {
    return TableRowData(
      day: map['day'] as String,
      path: map['path'] as String,
      status: map['status'] as String,
      statusColor: map['statusColor'] as Color,
    );
  }

  // Method to convert the instance to a map
  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'path': path,
      'status': status,
      'statusColor': statusColor,
    };
  }
}
