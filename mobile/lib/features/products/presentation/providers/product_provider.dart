import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';

// Repository katmanını sağlayan provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryImpl(DioClient());
});

// UI katmanının dinleyeceği asenkron durum yöneticisi (AsyncNotifier)
class ProductListNotifier extends AsyncNotifier<List<ProductModel>> {
  
  // 🛡️ 'late final' kalıbını kaldırdık! 
  // Repository'yi build metodu içinde güvenle alıyoruz.
  @override
  FutureOr<List<ProductModel>> build() async {
    return _fetchLiveProducts();
  }

  Future<List<ProductModel>> _fetchLiveProducts() async {
    // Repository'yi her istek anında provider'dan güvenle çekiyoruz
    final repository = ref.read(productRepositoryProvider);

    // Arayüzdeki skeleton animasyonunu test etmek için gecikme
    await Future.delayed(const Duration(seconds: 1));
    
    // Canlı API çağrısını tetikliyoruz
    return await repository.getProducts();
  }
}

// UI'ın izleyeceği global provider tanımı
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductModel>>(() {
  return ProductListNotifier();
});