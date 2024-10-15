import 'package:flutter_dotenv/flutter_dotenv.dart';

class erpAPI {
  // Get the base URL from .env
  static String apiUrl = dotenv.env['API_URL'] ?? 'https://localhost:8000';
  static String getCustomer = "$apiUrl/erp/customer";
  static String getShippingAll = "$apiUrl/erp/shinpping/all";
  static String insertOrder = "$apiUrl/erp/insrt/order";
  static String getOrder = "$apiUrl/erp/order";
}
