import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart'; // 👈 Somut uygulamayı (impl) import ediyoruz
import '../../domain/repositories/product_repository.dart';

// Repository katmanını sağlayan basit bir provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // DioClient singleton'ı doğru şekilde get etiyoruz
  return ProductRepositoryImpl(DioClient());
});

// UI katmanının dinleyeceği asenkron durum yöneticisi (AsyncNotifier)
class ProductListNotifier extends AsyncNotifier<List<ProductModel>> {
  late final ProductRepository _repository;

  @override
  FutureOr<List<ProductModel>> build() async {
    _repository = ref.watch(productRepositoryProvider);
    return _fetchLiveProducts();
  }

  Future<List<ProductModel>> _fetchLiveProducts() async {
    // Arayüzdeki skeleton animasyonunu test etmek için bu gecikmeyi tutabilirsin
    await Future.delayed(const Duration(seconds: 1));
    
    // Canlı API çağrısını tetikliyoruz
    return await _repository.getProducts();
  }
}

// UI'ın izleyeceği global provider tanımı
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductModel>>(() {
  return ProductListNotifier();
});