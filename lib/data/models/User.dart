class User {
  final String saleCode;
  final String salePayer;
  final String userName;
  final String firstName;
  final String surName;
  final String passWord;
  final String tel;
  final String zone;
  final String area;
  final String warehouse;
  final String role;
  final String status;

  User({
    required this.saleCode,
    required this.salePayer,
    required this.userName,
    required this.firstName,
    required this.surName,
    required this.passWord,
    required this.tel,
    required this.zone,
    required this.area,
    required this.warehouse,
    required this.role,
    required this.status,
  });

  // Factory method to create an instance from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      saleCode: json['saleCode'] ?? '',
      salePayer: json['salePayer'] ?? '',
      userName: json['userName'] ?? '',
      firstName: json['firstName'] ?? '',
      surName: json['surName'] ?? '',
      passWord: json['passWord'] ?? '',
      tel: json['tel'] ?? '',
      zone: json['zone'] ?? '',
      area: json['area'] ?? '',
      warehouse: json['warehouse'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'saleCode': saleCode,
      'salePayer': salePayer,
      'userName': userName,
      'firstName': firstName,
      'surName': surName,
      'passWord': passWord,
      'tel': tel,
      'zone': zone,
      'area': area,
      'warehouse': warehouse,
      'role': role,
      'status': status,
    };
  }
}
