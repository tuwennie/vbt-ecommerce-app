class UserProfileModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? address;

  UserProfileModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.address,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final userData = json.containsKey('data') && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return UserProfileModel(
      id: userData['id']?.toString() ?? '',
      email: userData['email'] ?? '',
      name: userData['name'] ?? userData['fullName'] ?? userData['firstName'] ?? 'Kullanıcı',
      phoneNumber: userData['phoneNumber'] ?? userData['phone'],
      address: userData['address'],
    );
  }
}