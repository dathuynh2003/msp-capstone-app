class Plan {
  final String id;
  final String name;
  final int pricePerMonth;
  final int maxUsers;
  final List<String> features;

  const Plan({
    required this.id,
    required this.name,
    required this.pricePerMonth,
    required this.maxUsers,
    this.features = const [],
  });

  Plan copyWith({
    String? id,
    String? name,
    int? pricePerMonth,
    int? maxUsers,
    List<String>? features,
  }) {
    return Plan(
      id: id ?? this.id,
      name: name ?? this.name,
      pricePerMonth: pricePerMonth ?? this.pricePerMonth,
      maxUsers: maxUsers ?? this.maxUsers,
      features: features ?? this.features,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pricePerMonth': pricePerMonth,
      'maxUsers': maxUsers,
      'features': features,
    };
  }

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      pricePerMonth: json['pricePerMonth'],
      maxUsers: json['maxUsers'],
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
