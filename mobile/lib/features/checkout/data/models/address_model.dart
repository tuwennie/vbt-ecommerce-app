class AddressModel {
  final String id;
  final String title; // Örn: Ev, İş
  final String fullAddress;
  final String city;
  final String district;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    required this.city,
    required this.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      fullAddress: json['fullAddress'] ?? json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fullAddress': fullAddress,
      'city': city,
      'district': district,
    };
  }
}