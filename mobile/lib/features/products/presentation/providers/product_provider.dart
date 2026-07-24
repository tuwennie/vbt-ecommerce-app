import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

// Repository katmanını sağlayan provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(DioClient());
});

// Seçilen kategoriye göre ürünleri yükleyen provider
final productListProvider = FutureProvider.family<List<ProductModel>, String?>((ref, categoryId) async {
  final repository = ref.watch(productRepositoryProvider);

  await Future.delayed(const Duration(seconds: 1));

  return repository.getProducts(categoryId: categoryId);
});

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productListProvider(null)).value ?? [];
});