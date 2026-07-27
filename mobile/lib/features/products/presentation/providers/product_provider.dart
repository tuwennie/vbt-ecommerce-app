import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

// Repository katmanını sağlayan provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(DioClient());
});

// Arama metnini tutan state provider
final productSearchQueryProvider = StateProvider<String>((ref) => '');

// Seçilen kategori ve arama sorgusuna göre ürünleri yükleyen provider
final productListProvider = FutureProvider.family<List<ProductModel>, String?>((ref, categoryId) async {
  final repository = ref.watch(productRepositoryProvider);
  final searchQuery = ref.watch(productSearchQueryProvider).trim();

  try {
    final products = await repository.getProducts(
      categoryId: categoryId,
      search: searchQuery.isNotEmpty ? searchQuery : null,
    );

    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      final filtered = products.where((p) {
        final nameMatch = p.name.toLowerCase().contains(queryLower);
        final descMatch = p.description.toLowerCase().contains(queryLower);
        final catMatch = p.category.name.toLowerCase().contains(queryLower);
        return nameMatch || descMatch || catMatch;
      }).toList();
      return filtered;
    }

    return products;
  } catch (e) {
    // Hata durumunda yeniden fırlatıyoruz
    rethrow;
  }
});

final allProductsProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productListProvider(null)).value ?? [];
});