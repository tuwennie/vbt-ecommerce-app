class OrderItemModel {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'] ?? {};
    return OrderItemModel(
      productId: json['productId']?.toString() ?? product['id']?.toString() ?? '',
      productName: product['name'] ?? json['productName'] ?? 'Ürün',
      price: (json['price'] ?? product['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      imageUrl: product['imageUrl'] ?? json['imageUrl'],
    );
  }
}

class OrderModel {
  final String id;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List? ?? [];
    return OrderModel(
      id: json['id']?.toString() ?? '',
      totalAmount: (json['totalAmount'] ?? json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'PENDING',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      items: rawItems.map((e) => OrderItemModel.fromJson(e)).toList(),
    );
  }
}