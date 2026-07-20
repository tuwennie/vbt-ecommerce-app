class UserModel {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? role;

  UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      role: json['role']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
    };
  }

  String get fullName => '$firstName $lastName'.trim();
}