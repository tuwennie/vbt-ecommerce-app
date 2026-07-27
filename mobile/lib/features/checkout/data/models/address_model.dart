class AddressModel {
  final String id;
  final String? title; // Örn: Ev, İş
  final String fullAddress;
  final String city;
  final String district;
  final String? recipientName;
  final String? phone;
  final String? postalCode;

  AddressModel({
    required this.id,
    this.title,
    required this.fullAddress,
    required this.city,
    required this.district,
    this.recipientName,
    this.phone,
    this.postalCode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String?,
      fullAddress: json['addressLine'] ?? json['fullAddress'] ?? json['address'] ?? '',
      city: json['city'] ?? '',
      district: json['district'] ?? '',
      recipientName: json['recipientName'] as String?,
      phone: json['phone'] as String?,
      postalCode: json['postalCode']?.toString() ?? json['zipCode']?.toString() ?? '34000',
    );
  }

  Map<String, dynamic> toJson() {
    final String cleanPhone = (phone != null && phone!.replaceAll(RegExp(r'[^0-9]'), '').length >= 10)
        ? phone!.replaceAll(RegExp(r'[^0-9]'), '')
        : '05555555555';

    final String cleanPostalCode = (postalCode != null && RegExp(r'^[0-9]{5}$').hasMatch(postalCode!.trim()))
        ? postalCode!.trim()
        : '34000';

    final String trimmedAddress = fullAddress.trim();
    final String cleanAddressLine = (trimmedAddress.length >= 10)
        ? trimmedAddress
        : '$trimmedAddress (Teslimat Adresi)';

    return {
      'title': (title != null && title!.isNotEmpty) ? title : 'Teslimat Adresi',
      'recipientName': (recipientName != null && recipientName!.length >= 2) ? recipientName : 'Müşteri Adı',
      'phone': cleanPhone,
      'city': city.length >= 2 ? city : 'İstanbul',
      'district': district.length >= 2 ? district : 'Merkez',
      'addressLine': cleanAddressLine,
      'postalCode': cleanPostalCode,
    };
  }
}