class Company {
  final String id;
  final String name;
  final String email;
  final String planId;
  final int members;

  const Company({
    required this.id,
    required this.name,
    required this.email,
    required this.planId,
    required this.members,
  });

  Company copyWith({
    String? id,
    String? name,
    String? email,
    String? planId,
    int? members,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      planId: planId ?? this.planId,
      members: members ?? this.members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'planId': planId,
      'members': members,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      planId: json['planId'],
      members: json['members'],
    );
  }
}
