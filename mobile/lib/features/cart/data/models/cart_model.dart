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
    final itemsList = rawItems
        .whereType<Map<String, dynamic>>()
        .map((e) => CartItemModel.fromJson(e))
        .toList();

    final calculatedTotal = itemsList.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final rawTotal = json['total'] ?? json['totalPrice'] ?? json['subtotal'] ?? json['totalAmount'];
    final double? backendTotal = double.tryParse(rawTotal?.toString() ?? '');

    return CartModel(
      items: itemsList,
      totalPrice: (backendTotal != null && backendTotal > 0) ? backendTotal : calculatedTotal,
    );
  }
}