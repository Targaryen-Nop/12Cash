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
    };
  }
}
