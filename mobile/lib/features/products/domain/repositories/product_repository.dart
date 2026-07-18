import '../../data/models/product_model.dart'; // Modelin data içinde olduğunu varsayıyoruz

abstract class ProductRepository {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int size = 20,
    String? search,
    String? categoryId,
    String? sort,
  });
}