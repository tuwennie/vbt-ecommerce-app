import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/navigation/app_router.dart';
import '../providers/cart_provider.dart';
import '../../../products/presentation/providers/product_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartItems = cartState.cart?.items ?? [];
    final isCartEmpty = cartItems.isEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          isCartEmpty ? 'ShopSwift' : 'Sepetim',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRouter.productList);
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: cartState.isLoading && cartState.cart == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => ref.read(cartProvider.notifier).fetchCart(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: isCartEmpty
                    ? _buildEmptyCartView(context, ref)
                    : _buildFilledCartView(context, ref, cartState),
              ),
            ),
    );
  }

  // ==========================================
  // 1. BOŞ SEPET GÖRÜNÜMÜ (1. Görsel Birebir)
  // ==========================================
  Widget _buildEmptyCartView(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return Column(
      children: [
        const SizedBox(height: 10),
        // Yuvarlak İllüstrasyon / Görsel Alanı
        CircleAvatar(
          radius: 110,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
        ),
        const SizedBox(height: 24),

        // Başlık ve Açıklama
        const Text(
          'Sepetiniz Boş',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Görünüşe göre henüz bir ürün eklemediniz. En yeni ürünlerimize göz atmaya ne dersiniz?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
          ),
        ),
        const SizedBox(height: 24),

        // Alışverişe Başla Butonu (Yeşil)
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.go(AppRouter.productList),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            label: const Text(
              'Alışverişe Başla',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Önceki Siparişlerim Butonu
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: () => context.go(AppRouter.profile),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD1D5DB)),
              backgroundColor: const Color(0xFFF9FAFB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Önceki Siparişlerim',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D61E7)),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Sizin İçin Seçtiklerimiz Başlığı
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sizin İçin Seçtiklerimiz',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            TextButton(
              onPressed: () => context.go(AppRouter.productList),
              child: const Text(
                'Tümünü Gör',
                style: TextStyle(color: Color(0xFF1D61E7), fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Yatay Öneri Ürün Listesi
        SizedBox(
          height: 240,
          child: productsAsync.when(
            data: (products) {
              final recommendedProducts = products.take(4).toList();

              if (recommendedProducts.isEmpty) {
                return const Center(child: Text('Önerilen ürün bulunamadı.'));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];

                  // Görsel Seçim Mantığı (Önce birincil/isPrimary, yoksa ilk imaj)
                  String? displayImageUrl;
                  if (product.images.isNotEmpty) {
                    final primaryImage = product.images.firstWhere(
                      (img) => img.isPrimary,
                      orElse: () => product.images.first,
                    );
                    displayImageUrl = primaryImage.imageUrl;
                  }

                  // Para Birimi Simgesi
                  final currencySymbol = product.currency == 'TRY' ? '₺' : product.currency;

                  return Container(
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ürün Görseli
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: displayImageUrl != null && displayImageUrl.isNotEmpty
                                ? Image.network(
                                    displayImageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[200],
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Kategori Adı (CategoryModel üzerinden)
                        Text(
                          product.category.name,
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        // Ürün Adı
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 4),

                        // Fiyat ve Para Birimi
                        Text(
                          '$currencySymbol${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Color(0xFF1D61E7),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => const Center(child: Text('Önerilen ürünler yüklenemedi.')),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ==========================================
  // 2. DOLU SEPET GÖRÜNÜMÜ (2. Görsel Birebir)
  // ==========================================
  Widget _buildFilledCartView(BuildContext context, WidgetRef ref, dynamic cartState) {
    final cart = cartState.cart!;
    final total = cart.totalPrice;

    return Column(
      children: [
        // Ürün Kartları Listesi
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cart.items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = cart.items[index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: Row(
                children: [
                  // Ürün Resmi
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[100],
                      child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                          ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                          : const Icon(Icons.headset, size: 40, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Detaylar ve Adet Değiştirici
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                item.productName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            InkWell(
                              onTap: () => ref.read(cartProvider.notifier).removeFromCart(item.productId),
                              child: const Row(
                                children: [
                                  Icon(Icons.delete_outline, size: 16, color: Colors.grey),
                                  SizedBox(width: 2),
                                  Text('Sil', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description != null && item.description!.isNotEmpty
                              ? item.description!
                              : 'Adet: ${item.quantity} • Fiyat: ₺${item.price.toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₺${item.price.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),

                            // Artır / Azalt Kontrolü
                            Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28),
                                    icon: const Icon(Icons.remove, size: 16),
                                    onPressed: () {
                                      if (item.quantity > 1) {
                                        ref.read(cartProvider.notifier).updateQuantity(item.productId, item.quantity - 1);
                                      } else {
                                        ref.read(cartProvider.notifier).removeFromCart(item.productId);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 28),
                                    icon: const Icon(Icons.add, size: 16),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).updateQuantity(item.productId, item.quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Sipariş Özeti Kartı
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Sipariş Özeti', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ara Toplam', style: TextStyle(color: Colors.black54)),
                  Text('₺${total.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Kargo Ücreti', style: TextStyle(color: Colors.black54)),
                  Text('Ücretsiz', style: TextStyle(color: Color(0xFF16A34A), fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Toplam', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    '₺${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Ödemeye Geç Butonu (Yeşil)
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.push(AppRouter.checkout);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Ödemeye Geç', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(width: 6),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}