import 'package:_12sale_app/data/models/route/StoreVisit.dart';

class RouteVisit2 {
  final String id;
  final String period;
  final String area;
  final String day;
  final int storeAll;
  final int storePending;
  final int storeSell;
  final int storeNotSell;
  final int storeTotal;
  List<ListStore>? listStore;

  RouteVisit2({
    required this.id,
    required this.period,
    required this.area,
    required this.day,
    required this.storeAll,
    required this.storePending,
    required this.storeSell,
    required this.storeNotSell,
    required this.storeTotal,
    this.listStore,
  });

  // Factory method to parse JSON into RouteVisit2
  factory RouteVisit2.fromJson(Map<String, dynamic> json) {
    return RouteVisit2(
      id: json['id'],
      period: json['period'],
      area: json['area'],
      day: json['day'],
      storeAll: json['storeAll'],
      storePending: json['storePending'],
      storeSell: json['storeSell'],
      storeNotSell: json['storeNotSell'],
      storeTotal: json['storeTotal'],
      listStore: (json['listStore'] as List?)
              ?.map((store) => ListStore.fromJson(store))
              .toList() ??
          [],
    );
  }

  // Method to convert object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'period': period,
      'area': area,
      'day': day,
      'storeAll': storeAll,
      'storePending': storePending,
      'storeSell': storeSell,
      'storeNotSell': storeNotSell,
      'storeTotal': storeTotal,
      'listStore': listStore?.map((store) => store.toJson()).toList(),
    };
  }
}
