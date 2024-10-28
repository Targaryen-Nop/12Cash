import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
      statusColor: _getColorFromStatus(map['statusColor']),
    );
  }

  // Helper method to convert color from string or other format
  static Color _getColorFromStatus(dynamic colorValue) {
    // Assuming colorValue is a string like "green", "red", etc.
    switch (colorValue) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red;
      case 'blue':
        return Colors.blue;
      default:
        return Colors.grey; // Fallback color
    }
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

class ApiService {
  final Dio _dio = Dio();

  Future<List<TableRowData>> fetchData() async {
    try {
      final response = await _dio
          .get('https://example.com/api/data'); // Replace with your API URL
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => TableRowData.fromMap(item)).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}
