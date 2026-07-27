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
    final data = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : json;

    final idStr = data['id']?.toString() ?? '';
    final shortId = (idStr.length >= 8) ? idStr.substring(0, 8) : idStr;
    final generatedOrderNo = shortId.isNotEmpty ? '#SW-$shortId' : '#SW-1000';

    final shippingAddr = (data['shippingAddress'] is Map<String, dynamic>)
        ? data['shippingAddress'] as Map<String, dynamic>
        : (data['address'] is Map<String, dynamic> ? data['address'] as Map<String, dynamic> : <String, dynamic>{});

    String addressText = '';
    if (shippingAddr.isNotEmpty) {
      final line = shippingAddr['addressLine'] ?? shippingAddr['fullAddress'] ?? '';
      final dist = shippingAddr['district'] ?? '';
      final city = shippingAddr['city'] ?? '';
      addressText = '$line $dist/$city'.trim();
    } else {
      addressText = data['deliveryAddress']?.toString() ?? 'Teslimat Adresi';
    }

    final rawTotal = data['total'] ?? data['totalAmount'] ?? data['totalPrice'];
    final double parsedTotal = double.tryParse(rawTotal?.toString() ?? '0') ?? 0.0;

    return OrderResponseModel(
      id: idStr,
      orderNo: data['orderNo'] ?? data['orderCode'] ?? generatedOrderNo,
      deliveryAddress: addressText,
      totalAmount: parsedTotal,
      items: (data['items'] as List?) ?? [],
      status: data['status']?.toString() ?? 'Hazırlanıyor',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}