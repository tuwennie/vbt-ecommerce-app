class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String? description;

  final double price;
  final int quantity;
  final String? imageUrl;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.description,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    final product = (json['product'] is Map<String, dynamic>)
        ? json['product'] as Map<String, dynamic>
        : <String, dynamic>{};

    final rawPrice = json['price'] ?? json['unitPrice'] ?? product['price'] ?? json['productPrice'];
    double priceVal = double.tryParse(rawPrice?.toString() ?? '0') ?? 0.0;

    final int qty = json['quantity'] is int
        ? json['quantity'] as int
        : int.tryParse(json['quantity']?.toString() ?? '1') ?? 1;

    // Eğer birim fiyat 0 gelirse ama item seviyesinde toplam fiyat veya sepet toplamı varsa hesapla
    if (priceVal == 0.0) {
      final rawItemTotal = json['totalPrice'] ?? json['total'] ?? json['itemTotal'];
      final double itemTotalVal = double.tryParse(rawItemTotal?.toString() ?? '0') ?? 0.0;
      if (itemTotalVal > 0 && qty > 0) {
        priceVal = itemTotalVal / qty;
      }
    }

    String? imgUrl = json['imageUrl'] ?? product['imageUrl'];
    if (imgUrl == null && product['images'] is List && (product['images'] as List).isNotEmpty) {
      final firstImg = (product['images'] as List).first;
      if (firstImg is Map<String, dynamic>) {
        imgUrl = firstImg['imageUrl'];
      } else if (firstImg is String) {
        imgUrl = firstImg;
      }
    }

    return CartItemModel(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? product['id']?.toString() ?? '',
      productName: product['name'] ?? json['productName'] ?? json['title'] ?? 'Ürün',
      description: product['description'] ?? json['description'],
      price: priceVal,
      quantity: qty,
      imageUrl: imgUrl,
    );
  }

  double get totalPrice => price * quantity;
}