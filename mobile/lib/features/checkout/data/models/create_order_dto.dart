export '../../../orders/data/models/order_model.dart';

class CreateOrderDto {
  final String addressId;
  final String paymentMethod;
  final String? note;

  CreateOrderDto({
    required this.addressId,
    this.paymentMethod = 'CREDIT_CARD',
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'addressId': addressId,
      'paymentMethod': paymentMethod,
      if (note != null && note!.isNotEmpty) 'note': note,
    };
  }
}