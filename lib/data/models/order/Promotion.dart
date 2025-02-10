class PromotionList {
  final String proId;
  final String proName;
  final String name;
  final String proType;
  final double discount;
  final String id;
  final String group;
  final String flavour;
  final String brand;
  final String size;
  final String unit;
  final int qty;
  final String objectId;

  PromotionList({
    required this.proId,
    required this.proName,
    required this.name,
    required this.proType,
    required this.discount,
    required this.id,
    required this.group,
    required this.flavour,
    required this.brand,
    required this.size,
    required this.unit,
    required this.qty,
    required this.objectId,
  });

  // ✅ Convert JSON to Dart Object
  factory PromotionList.fromJson(Map<String, dynamic> json) {
    return PromotionList(
      proId: json['proId'], //  field name
      proName: json['proName'], //  field name
      name: json['name'], //  field name
      proType: json['proType'], //  field name
      discount: (json['discount'] as num).toDouble(), //  it's double
      id: json['id'], //  field name
      group: json['group'], //  field name
      flavour: json['flavour'], //  field name
      brand: json['brand'], //  field name
      size: json['size'], //  field name
      unit: json['unit'], //  field name
      qty: json['qty'] as int, //  it's int
      objectId: json['_id'], //  field name (_id from JSON)
    );
  }

  // ✅ Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'proId': proId,
      'proName': proName,
      'name': name,
      'proType': proType,
      'discount': discount,
      'id': id,
      'group': group,
      'flavour': flavour,
      'brand': brand,
      'size': size,
      'unit': unit,
      'qty': qty,
      '_id': objectId,
    };
  }
}
