// Main model class
class StoreVisit {
  final String id;
  final String period;
  final String area;
  final String day;
  final int? storeAll;
  final int? storePending;
  final int? storeBuy;
  final int? storeNotBuy;
  final int? storeTotal;
  final List<ListStore> listStore;

  StoreVisit({
    required this.id,
    required this.period,
    required this.area,
    required this.day,
    required this.listStore,
    this.storeAll,
    this.storePending,
    this.storeBuy,
    this.storeNotBuy,
    this.storeTotal,
  });

  factory StoreVisit.fromJson(Map<String, dynamic> json) {
    return StoreVisit(
      id: json['id'],
      period: json['period'],
      area: json['area'],
      day: json['day'],
      storeAll: json['storeAll'],
      storePending: json['storePending'],
      storeNotBuy: json['storeNotBuy'],
      storeBuy: json['storeBuy'],
      storeTotal: json['storeTotal'],
      listStore: (json['listStore'] as List)
          .map((store) => ListStore.fromJson(store))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period': period,
      'area': area,
      'day': day,
      'storeAll': storeAll,
      'storePending': storePending,
      'storeBuy': storeBuy,
      'storeNotBuy': storeNotBuy,
      'storeTotal': storeTotal,
      'listStore': listStore.map((store) => store.toJson()).toList(),
    };
  }
}

// ListStore class
class ListStore {
  final StoreInfo storeInfo;
  final String note;
  final String? image;
  final String? latitude;
  final String? longtitude;
  final String status;
  final String statusText;
  final String? date;
  final List<dynamic> listOrder;

  ListStore({
    required this.storeInfo,
    required this.note,
    this.image,
    this.latitude,
    this.longtitude,
    required this.status,
    required this.statusText,
    this.date,
    required this.listOrder,
  });

  factory ListStore.fromJson(Map<String, dynamic> json) {
    return ListStore(
      storeInfo: StoreInfo.fromJson(json['storeInfo']),
      note: json['note'] ?? '',
      image: json['image'],
      latitude: json['latitude'],
      longtitude: json['longtitude'],
      status: json['status'] ?? '0',
      statusText: json['statusText'] ?? '',
      date: json['date'] ?? '',
      listOrder: json['listOrder'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeInfo': storeInfo.toJson(),
      'note': note,
      'image': image,
      'latitude': latitude,
      'longtitude': longtitude,
      'status': status,
      'statusText': statusText,
      'date': date,
      'listOrder': listOrder,
    };
  }
}

// StoreInfo class
class StoreInfo {
  final String id;
  final String storeId;
  final String name;
  final String typeName;
  final String address;

  StoreInfo({
    required this.id,
    required this.storeId,
    required this.name,
    required this.typeName,
    required this.address,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      id: json['_id'],
      storeId: json['storeId'],
      name: json['name'],
      typeName: json['typeName'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'storeId': storeId,
      'name': name,
      'typeName': typeName,
      'address': address,
    };
  }
}
