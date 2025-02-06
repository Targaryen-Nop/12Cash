class Cart {
  final String id;
  final String type;
  final String area;
  final String storeId;
  final double total;
  final List<CartList> listCartList;
  final DateTime created;
  final DateTime updated;

  Cart({
    required this.id,
    required this.type,
    required this.area,
    required this.storeId,
    required this.total,
    required this.listCartList,
    required this.created,
    required this.updated,
  });

  // ✅ Convert JSON to Dart Object
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      type: json['type'],
      area: json['area'],
      storeId: json['storeId'],
      total: json['total'],
      listCartList: (json['listCartList'] as List)
          .map((item) => CartList.fromJson(item))
          .toList(),
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
    );
  }

  // ✅ Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'area': area,
      'storeId': storeId,
      'total': total,
      'listCartList': listCartList.map((product) => product.toJson()).toList(),
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  // @override
  // String toString() {
  //   return 'Cart(id: $id, type: $type, area: $area, storeId: $storeId, total: $total, created: $created, updated: $updated, listCartList: $listCartList)';
  // }
}

class CartList {
  final String id;
  final String name;
  double qty;
  final String unit;
  final double price;
  final String productId;

  CartList({
    required this.id,
    required this.name,
    required this.qty,
    required this.unit,
    required this.price,
    required this.productId,
  });

  // ✅ Convert JSON to Dart Object
  factory CartList.fromJson(Map<String, dynamic> json) {
    return CartList(
      id: json['id'],
      name: json['name'],
      qty: json['qty'].toDouble(),
      unit: json['unit'],
      price: json['price'].toDouble(),
      productId: json['id'],
    );
  }

  // ✅ Convert Dart Object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'qty': qty,
      'unit': unit,
      'price': price,
      'id': productId,
    };
  }

  // @override
  // String toString() {
  //   return 'CartList(id: $id, name: $name, qty: $qty, unit: $unit, price: $price, productId: $productId)';
  // }
}
