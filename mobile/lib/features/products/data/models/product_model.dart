class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int stock;
  final bool isActive;
  final CategoryModel category; 
  final List<ProductImageModel> images; 

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.stock,
    required this.isActive,
    required this.category,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] ?? "",
      // API'den int veya double gelebileceği için güvenli tür dönüşümü
      price: json['price'] is num 
          ? (json['price'] as num).toDouble() 
          : double.parse(json['price'].toString()),
      currency: json['currency'] ?? "TRY",
      stock: json['stock'] as int,
      isActive: json['isActive'] ?? true,
      category: CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      // images dizisini güvenli bir şekilde map'liyoruz
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImageModel.fromJson(e as Map<String, dynamic>))
              .toList() ?? [],
    );
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      isActive: json['isActive'] ?? true,
    );
  }
}

class ProductImageModel {
  final String id;
  final String imageUrl;
  final bool isPrimary;
  final int sortOrder;

  ProductImageModel({
    required this.id,
    required this.imageUrl,
    required this.isPrimary,
    required this.sortOrder,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      isPrimary: json['isPrimary'] ?? false,
      sortOrder: json['sortOrder'] as int,
    );
  }
}