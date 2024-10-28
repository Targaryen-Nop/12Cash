import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class JsonLoader {
  // Function to load JSON data from a specified path
  static Future<Map<String, dynamic>> loadJson(String path) async {
    try {
      String jsonString = await rootBundle.loadString(path);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print("Error loading JSON: $e");
      return {}; // Return an empty map in case of an error
    }
  }
}
