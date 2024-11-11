class District {
  String? id;
  final String amphoe;
  final String province;

  District({
    this.id,
    required this.amphoe,
    required this.province,
  });

  // Factory method to create a District instance from JSON
  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] ?? json['_id'] ?? '',
      amphoe: json['amphoe'] ?? '',
      province: json['province'] ?? '',
    );
  }

  // Method to check if a filter string is contained in amphoe or province
  bool containsFilter(String filter) {
    final filterLower = filter.toLowerCase();
    return amphoe.toLowerCase().contains(filterLower);
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '${this.amphoe}';
  }

  // Method to convert District instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amphoe': amphoe,
      'province': province,
    };
  }

  @override
  String toString() => '$amphoe';
}
