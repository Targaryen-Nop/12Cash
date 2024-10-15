class ShippingModel {
  final int coNo;
  final String customerNo;
  final String addressID;
  final String customerName;
  final String shippingAddress1;
  final String shippingPhone;
  ShippingModel({
    required this.coNo,
    required this.customerNo,
    required this.addressID,
    required this.customerName,
    required this.shippingAddress1,
    required this.shippingPhone,
  });
  factory ShippingModel.fromJson(Map<String, dynamic> json) {
    return ShippingModel(
      coNo: json["coNo"],
      customerNo: json["customerNo"],
      addressID: json["addressID"],
      customerName: json["customerName"],
      shippingAddress1: json["shippingAddress1"],
      shippingPhone: json["shippingPhone"],
    );
  }
  static List<ShippingModel> fromJsonList(List list) {
    return list.map((item) => ShippingModel.fromJson(item)).toList();
  }

  // String userAsString() {
  //   return '''#
  //   ${this.customerNo}
  //   ${this.addressID}
  //   ${this.customerName}
  //   ${this.shippingAddress1}
  //   ${this.shippingPhone}
  //   ''';
  // }

  bool isEqual(ShippingModel model) {
    return this.customerNo == model.customerNo;
  }

  @override
  String toString() =>
      '$customerNo $addressID $customerName $shippingAddress1 $shippingPhone';
}
