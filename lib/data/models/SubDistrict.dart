class SubDistrict {
  String? id;
  final String district;
  final String amphoe;
  final String province;

  SubDistrict({
    this.id,
    required this.district,
    required this.amphoe,
    required this.province,
  });

  // Factory method to create a SubDistrict instance from JSON
  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    return SubDistrict(
      id: json['id'] ?? json['_id'] ?? '',
      district: json['district'] ?? '',
      amphoe: json['amphoe'] ?? '',
      province: json['province'] ?? '',
    );
  }

  // Method to convert SubDistrict instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'district': district,
      'amphoe': amphoe,
      'province': province,
    };
  }
}
