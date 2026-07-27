class OrderResponseModel {
  final String id;
  final String orderNo;
  final String deliveryAddress;
  final double totalAmount;
  final List<dynamic> items;
  final String status;
  final DateTime createdAt; 

  OrderResponseModel({
    required this.id,
    required this.orderNo,
    required this.deliveryAddress,
    this.totalAmount = 0.0,
    this.items = const [],
    this.status = 'Tamamlandı', // Varsayılan değer
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    final address = data['address'] ?? {};

    return OrderResponseModel(
      id: data['id']?.toString() ?? '',
      orderNo: data['orderNo'] ?? data['orderCode'] ?? '#SW-${data['id']}',
      deliveryAddress: address['fullAddress'] != null
          ? '${address['fullAddress']} ${address['district']}/${address['city']}'
          : data['deliveryAddress'] ?? '',
      totalAmount: double.tryParse(data['totalAmount']?.toString() ?? '0') ?? 0.0,
      items: (data['items'] as List?) ?? [],
      status: data['status']?.toString() ?? 'Hazırlanıyor', // API'den gelen status
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}