import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  // Instead of hardcoding, access values from the .env file
  static final String apiHost =
      dotenv.env['API_URL'] ?? 'https://default.host.com';

  static final String getCustomer = "$apiHost/erp/customer/top100";
}
