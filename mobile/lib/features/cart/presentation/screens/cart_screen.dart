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
  // 1. BOÞ SEPET GÖRÜNÜMÜ (1. Görsel Birebir)
  // ==========================================
  Widget _buildEmptyCartView(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(allProductsProvider);

    return Column(
      children: [
        const SizedBox(height: 10),
        // Yuvarlak Ýllüstrasyon / Görsel Alaný
        CircleAvatar(
          radius: 110,
          backgroundColor: Colors.grey[200],
          child: const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
        ),
        const SizedBox(height: 24),

        // Baþlýk ve Açýklama
        const Text(
          'Sepetiniz Boþ',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            'Görünüþe göre henüz bir ürün eklemediniz. En yeni ürünlerimize göz atmaya ne dersiniz?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
          ),
        ),
        const SizedBox(height: 24),

        // Alýþveriþe Baþla Butonu (Yeþil)
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.go(AppRouter.productList),
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            label: const Text(
              'Alýþveriþe Baþla',
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

        // Önceki Sipariþlerim Butonu
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
              'Önceki Sipariþlerim',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1D61E7)),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Sizin Ýçin Seçtiklerimiz Baþlýðý
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Sizin Ýçin Seçtiklerimiz',
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
                return const Center(child: Text('Önerilen ürün bulunamadý.'));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: recommendedProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final product = recommendedProducts[index];

                  // Görsel Seçim Mantýðý (Önce birincil/isPrimary, yoksa ilk imaj)
                  String? displayImageUrl;
                  if (product.images.isNotEmpty) {
                    final primaryImage = product.images.firstWhere(
                      (img) => img.isPrimary,
                      orElse: () => product.images.first,
                    );
                    displayImageUrl = primaryImage.imageUrl;
                  }

                  // Para Birimi Simgesi
                  final currencySymbol = product.currency == 'TRY' ? '?' : product.currency;

                  return Container(
                    width: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black.withOpacity(0.08)),
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

                        // Kategori Adý (CategoryModel üzerinden)
                        Text(
                          product.category.name,
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),

                        // Ürün Adý
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
            error: (error, stackTrace) => const Center(child: Text('Ürünler yüklenemedi.')),
          ),
        ),
      ],
    );
  }

  Widget _buildFilledCartView(
    BuildContext context,
    WidgetRef ref,
    dynamic cartState,
  ) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          'Sepetinizdeki Ürünler',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cartState.cart?.items.length ?? 0,
          itemBuilder: (context, index) {
            final item = cartState.cart!.items[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.shopping_bag, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item.quantity} adet',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
