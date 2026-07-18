import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/product_model.dart';

class ProductListNotifier extends AsyncNotifier<List<ProductModel>> {
  @override
  FutureOr<List<ProductModel>> build() async {
    // DoD Kriteri: Yükleniyor/skeleton durumunu görselleştirmek için 2 saniye bekletiyoruz
    await Future.delayed(const Duration(seconds: 2));
    return _getMockProducts();
  }

  // Kübra'nın endpoint şemasıyla birebir aynı veri seti
  List<ProductModel> _getMockProducts() {
    return [
      ProductModel(
        id: "prod-1",
        name: "ShopSwift Özel Tasarım Sırt Çantası",
        description: "Su geçirmeyen, laptop bölmeli konforlu çanta.",
        price: 899.90,
        stock: 15,
        isActive: true,
        imageUrls: ["https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500"],
      ),
      ProductModel(
        id: "prod-2",
        name: "Kablosuz ANC Kulaklık v2",
        description: "Aktif gürültü engelleme özellikli, 40 saat pil ömürlü.",
        price: 2450.00,
        stock: 4,
        isActive: true,
        imageUrls: ["https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500"],
      ),
      ProductModel(
        id: "prod-3",
        name: "Minimalist Deri Cüzdan",
        description: "RFID korumalı, hakiki deri kartlık ve cüzdan.",
        price: 450.00,
        stock: 50,
        isActive: true,
        imageUrls: ["https://images.unsplash.com/photo-1627123424574-724758594e93?w=500"],
      ),
      ProductModel(
        id: "prod-4",
        name: "Akıllı Spor Saati PRO",
        description: "Amoled ekranlı, nabız ve uyku takibi destekli.",
        price: 3199.99,
        stock: 0, // Tükendi durumunu test etmek için
        isActive: true,
        imageUrls: ["https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500"],
      ),
    ];
  }
}

// UI katmanından dinleyeceğimiz küresel sağlayıcı (provider)
final productListProvider = AsyncNotifierProvider<ProductListNotifier, List<ProductModel>>(() {
  return ProductListNotifier();
});