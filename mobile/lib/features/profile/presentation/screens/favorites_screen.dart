import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../products/data/models/product_model.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.profile);
            }
          },
        ),
        title: const Text(
          'Favorilerim',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 56,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Henüz Favori Ürününüz Yok',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Beğendiğiniz ürünlerin üzerindeki kalp ikonuna dokunarak favorilerinize ekleyebilirsiniz.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => context.go(AppRouter.productList),
                      icon: const Icon(Icons.shopping_bag_outlined, size: 20),
                      label: const Text(
                        'Ürünleri Keşfet',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _mapProductToUi(favorites[index]);
                return _buildFavoriteCard(context, ref, item);
              },
            ),
    );
  }

  Widget _buildFavoriteCard(BuildContext context, WidgetRef ref, FavoriteUiModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Sol: Ürün Görseli
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[100],
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, color: Colors.grey),
                        )
                      : const Icon(Icons.image, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 14),

              // 2. Orta: Marka, Başlık, Açıklama, Fiyat
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.brand.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2563EB), // Canlı Mavi Marka Etiketi
                          ),
                        ),
                        // Çöp Kutusu Silme Butonu
                        GestureDetector(
                          onTap: () {
                            ref.read(favoritesProvider.notifier).removeFavorite(item.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${item.title} favorilerden çıkarıldı.'),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(2.0),
                            child: Icon(
                              Icons.delete_outline,
                              color: Color(0xFF9CA3AF),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '₺${item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (item.oldPrice != null) ...[
                          const SizedBox(width: 8),
                          Text(
                            '₺${item.oldPrice!.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        if (item.discountTag != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF86EFAC),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              item.discountTag!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF14532D),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Alt Kısım: Sepete Ekle Butonu (Canlı Yeşil Background & Beyaz Metin)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A34A), // Canlı Yeşil Background
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await ref.read(cartProvider.notifier).addToCart(
                  item.id,
                  productName: item.title,
                  price: item.price,
                  imageUrl: item.imageUrl,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${item.title} sepete eklendi!'),
                      backgroundColor: const Color(0xFF16A34A),
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Sepete Ekle',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  FavoriteUiModel _mapProductToUi(ProductModel p) {
    return FavoriteUiModel(
      id: p.id,
      brand: p.category.name.isNotEmpty ? p.category.name : 'ÜRÜN',
      title: p.name,
      description: p.description.isNotEmpty ? p.description : 'Stokta Mevcut',
      price: p.price,
      imageUrl: p.images.isNotEmpty ? p.images.first.imageUrl : '',
    );
  }
}

class FavoriteUiModel {
  final String id;
  final String brand;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final String? discountTag;
  final String imageUrl;

  FavoriteUiModel({
    required this.id,
    required this.brand,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    this.discountTag,
    required this.imageUrl,
  });
}
