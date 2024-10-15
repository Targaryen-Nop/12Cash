class CustomerModel {
  final int coNo;
  final String customerNo;
  final String customerChannel;
  final String customerName;
  final String customerAddress1;
  final String customerAddress2;
  final String customerAddress3;
  final String customerAddress4;
  final String customerPoscode;
  final String customerPhone;
  final String creditTerm;
  final String orderType;
  final String saleCode;
  final String salePayer;
  final String zone;
  final String taxno;
  final String OKCSCD;
  final String OKECAR;
  final String OKFACI;
  final String OKCUCD;
  final String OKALCU;
  final String OKPYCD;
  final String OKMODL;
  final String OKTEDL;

  CustomerModel({
    required this.coNo,
    required this.customerNo,
    required this.customerChannel,
    required this.customerName,
    required this.customerAddress1,
    required this.customerAddress2,
    required this.customerAddress3,
    required this.customerAddress4,
    required this.customerPoscode,
    required this.customerPhone,
    required this.creditTerm,
    required this.orderType,
    required this.saleCode,
    required this.salePayer,
    required this.zone,
    required this.taxno,
    required this.OKCSCD,
    required this.OKECAR,
    required this.OKFACI,
    required this.OKCUCD,
    required this.OKALCU,
    required this.OKPYCD,
    required this.OKMODL,
    required this.OKTEDL,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      coNo: json["coNo"],
      customerNo: json["customerNo"],
      customerChannel: json["customerChannel"],
      customerName: json["customerName"],
      customerAddress1: json["customerAddress1"],
      customerAddress2: json["customerAddress2"],
      customerAddress3: json["customerAddress3"],
      customerAddress4: json["customerAddress4"],
      customerPoscode: json["customerPoscode"],
      customerPhone: json["customerPhone"],
      creditTerm: json["creditTerm"],
      orderType: json["orderType"],
      zone: json["zone"],
      saleCode: json["saleCode"],
      salePayer: json["salePayer"],
      taxno: json["taxno"],
      OKCSCD: json["OKCSCD"],
      OKECAR: json["OKECAR"],
      OKFACI: json["OKFACI"],
      OKCUCD: json["OKCUCD"],
      OKALCU: json["OKALCU"],
      OKPYCD: json["OKPYCD"],
      OKMODL: json["OKMODL"],
      OKTEDL: json["OKTEDL"],
    );
  }

  static List<CustomerModel> fromJsonList(List list) {
    return list.map((item) => CustomerModel.fromJson(item)).toList();
  }

// this method will prevent the override of toString
//   String userAsString() {
//     return '''
//   coNo: ${this.coNo},
//   customerNo: ${this.customerNo},
//   customerChannel: ${this.customerChannel},
//   customerName: ${this.customerName},
//   customerAddress1: ${this.customerAddress1},
//   customerAddress2: ${this.customerAddress2},
//   customerAddress3: ${this.customerAddress3},
//   customerAddress4: ${this.customerAddress4},
//   customerPoscode: ${this.customerPoscode},
//   customerPhone: ${this.customerPhone},
//   creditTerm: ${this.creditTerm},
//   orderType: ${this.orderType},
// ''';
//   }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return (this.nameEN.toString().contains(filter) ||
  //           this.name.toString().contains(filter)) &&
  //       (this.name.toString() != "O-0019" ||
  //           this.name.toString() != "O-0041" ||
  //           this.name.toString() != "O-0040");
  // }

  ///custom comparing function to check if two users are equal
  // bool isEqual(CustomerModel model) {
  //   return this.customerNo == model.customerNo;
  // }

  @override
  String toString() =>
      '$customerNo $customerName $customerChannel Order type: $orderType';
}
