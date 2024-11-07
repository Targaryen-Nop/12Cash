class Store {
  final String storeId;
  final String name;
  final String taxId;
  final String tel;
  final String route;
  final String type;
  final String typeName;
  final String address;
  final String district;
  final String subDistrict;
  final String province;
  final String provinceCode;
  final String zone;
  final String area;
  final String latitude;
  final String longitude;
  final String lineId;
  final String note;
  final Approve approve;
  final String status;
  final List<PolicyConsent> policyConsent;
  final List<dynamic> imageList;
  final List<dynamic> shippingAddress;
  final String createdDate;
  final String updatedDate;

  Store({
    required this.storeId,
    required this.name,
    required this.taxId,
    required this.tel,
    required this.route,
    required this.type,
    required this.typeName,
    required this.address,
    required this.district,
    required this.subDistrict,
    required this.province,
    required this.provinceCode,
    required this.zone,
    required this.area,
    required this.latitude,
    required this.longitude,
    required this.lineId,
    required this.note,
    required this.approve,
    required this.status,
    required this.policyConsent,
    required this.imageList,
    required this.shippingAddress,
    required this.createdDate,
    required this.updatedDate,
  });

  // Factory constructor to create a Store instance from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      storeId: json['storeId'],
      name: json['name'],
      taxId: json['taxId'],
      tel: json['tel'],
      route: json['route'],
      type: json['type'],
      typeName: json['typeName'],
      address: json['address'],
      district: json['district'],
      subDistrict: json['subDistrict'],
      province: json['province'],
      provinceCode: json['provinceCode'],
      zone: json['zone'],
      area: json['area'],
      latitude: json['latitude'],
      longitude: json['longtitude'],
      lineId: json['lineId'],
      note: json['note'],
      approve: Approve.fromJson(json['approve']),
      status: json['status'],
      policyConsent: (json['policyConsent'] as List)
          .map((e) => PolicyConsent.fromJson(e))
          .toList(),
      imageList: json['imageList'],
      shippingAddress: json['shippingAddress'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }

  // Method to convert Store instance to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'storeId': storeId,
      'name': name,
      'taxId': taxId,
      'tel': tel,
      'route': route,
      'type': type,
      'typeName': typeName,
      'address': address,
      'district': district,
      'subDistrict': subDistrict,
      'province': province,
      'provinceCode': provinceCode,
      'zone': zone,
      'area': area,
      'latitude': latitude,
      'longtitude': longitude,
      'lineId': lineId,
      'note': note,
      'approve': approve.toJson(),
      'status': status,
      'policyConsent': policyConsent.map((e) => e.toJson()).toList(),
      'imageList': imageList,
      'shippingAddress': shippingAddress,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
    };
  }
}

class Approve {
  final String dateSend;
  final String dateAction;
  final String appPerson;

  Approve({
    required this.dateSend,
    required this.dateAction,
    required this.appPerson,
  });

  factory Approve.fromJson(Map<String, dynamic> json) {
    return Approve(
      dateSend: json['dateSend'],
      dateAction: json['dateAction'],
      appPerson: json['appPerson'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dateSend': dateSend,
      'dateAction': dateAction,
      'appPerson': appPerson,
    };
  }
}

class PolicyConsent {
  final String status;
  final String date;

  PolicyConsent({
    required this.status,
    required this.date,
  });

  factory PolicyConsent.fromJson(Map<String, dynamic> json) {
    return PolicyConsent(
      status: json['status'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'date': date,
    };
  }
}
