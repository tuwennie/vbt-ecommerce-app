class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? product['id']?.toString() ?? '',
      productName: product['name'] ?? json['productName'] ?? '',
      price: (json['price'] ?? product['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: product['imageUrl'] ?? json['imageUrl'],
    );
  }

  double get totalPrice => price * quantity;
}