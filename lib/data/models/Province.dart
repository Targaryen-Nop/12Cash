class Province {
  String? id;
  final String province;

  Province({
    this.id,
    required this.province,
  });

  // Factory method to create a Province instance from JSON
  factory Province.fromJson(Map<String, dynamic> json) {
    return Province(
      id: json['id'] ?? json['_id'] ?? '',
      province: json['province'] ?? '',
    );
  }

  // Method to check if a filter string is contained in amphoe or province
  bool containsFilter(String filter) {
    final filterLower = filter.toLowerCase();
    return province.toLowerCase().contains(filterLower);
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.province}';
  }

  // Method to convert Province instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'province': province,
    };
  }

  @override
  String toString() => '$province';
}
