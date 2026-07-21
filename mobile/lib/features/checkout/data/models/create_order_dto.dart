class CreateOrderDto {
  final String addressId;
  final String? note;

  CreateOrderDto({
    required this.addressId,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}

class OrderResponseModel {
  final String id;
  final String orderNo;
  final String deliveryAddress;

  OrderResponseModel({
    required this.id,
    required this.orderNo,
    required this.deliveryAddress,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    final address = data['address'] ?? {};
    
    return OrderResponseModel(
      id: data['id']?.toString() ?? '',
      orderNo: data['orderNo'] ?? data['orderCode'] ?? '#SW-${data['id']}',
      deliveryAddress: address['fullAddress'] != null 
          ? '${address['fullAddress']} ${address['district']}/${address['city']}'
          : data['deliveryAddress'] ?? '',
    );
  }
}