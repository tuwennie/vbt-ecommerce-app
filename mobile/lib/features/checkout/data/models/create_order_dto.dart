export '../../../orders/data/models/order_model.dart';

class CreateOrderDto {
  final String addressId;
  final String paymentMethod;

  CreateOrderDto({
    required this.addressId,
    this.paymentMethod = 'CREDIT_CARD',
  });

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'paymentMethod': paymentMethod,
    };
  }
}