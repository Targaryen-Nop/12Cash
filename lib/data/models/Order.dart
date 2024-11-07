class Order {
  final String textShow;
  final String itemName;
  // final String itemCode;
  final double count;
  final double unit;
  final double pricePerUnit;
  final double totalPrice;
  double qty = 0;

  Order({
    required this.textShow,
    required this.itemName,
    // required this.itemCode,
    required this.count,
    required this.unit,
    required this.pricePerUnit,
    required this.qty,
  }) : totalPrice = count *
            unit *
            pricePerUnit; // Calculate total price based on count and unit

  // Convert an Order object to a Map (for JSON encoding)
  Map<String, dynamic> toJson() {
    return {
      'textShow': textShow,
      'itemName': itemName,
      // 'itemCode': itemCode,
      'count': count,
      'unit': unit,
      'pricePerUnit': pricePerUnit,
      'totalPrice': totalPrice,
      'qty': qty,
    };
  }

  // Convert a Map (from JSON decoding) to an Order object
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      textShow: json['textShow'],
      itemName: json['itemName'],
      // itemCode: json['itemCode'],
      count: json['count'],
      unit: json['unit'],
      pricePerUnit: json['pricePerUnit'],
      qty: json['qty'],
    );
  }
}
