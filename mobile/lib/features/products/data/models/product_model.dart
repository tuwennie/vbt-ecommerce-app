class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final bool isActive;
  final List<String> imageUrls; // Kübra'nın images dizisindeki imageUrl alanları için

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    required this.isActive,
    required this.imageUrls,
  });
}