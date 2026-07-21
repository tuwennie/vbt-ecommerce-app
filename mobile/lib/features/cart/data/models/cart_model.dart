import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({
    required this.items,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    final itemsList = rawItems.map((e) => CartItemModel.fromJson(e)).toList();
    
    // Toplam fiyatı backend verisinden alıyoruz, yoksa yerelde hesaplıyoruz
    final calculatedTotal = itemsList.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final backendTotal = (json['totalPrice'] ?? json['total'])?.toDouble();

    return CartModel(
      items: itemsList,
      totalPrice: backendTotal ?? calculatedTotal,
    );
  }
}