import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../profile/presentation/providers/favorites_provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/product_search_bar.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? initialSearch;

  const ProductListScreen({
    super.key,
    required this.categoryId,
    this.initialSearch,
  });

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialSearch ?? ref.read(productSearchQueryProvider);
    _searchController = TextEditingController(text: initial);
    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(productSearchQueryProvider.notifier).state = widget.initialSearch!;
      });
    }
  }

  @override
  void deactivate() {
    _searchController.clear();
    Future.microtask(() {
      ref.read(productSearchQueryProvider.notifier).state = '';
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productListProvider(widget.categoryId));
    final searchQuery = ref.watch(productSearchQueryProvider);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'ShopSwift',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: Column(
        children: [
          // 1. Arama Çubuğu (Tasarıma Sadık)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: ProductSearchBar(
              controller: _searchController,
              hintText: 'Ürün arayınız...',
              onChanged: (value) {
                ref.read(productSearchQueryProvider.notifier).state = value;
              },
              onClear: () {
                _searchController.clear();
                ref.read(productSearchQueryProvider.notifier).state = '';
              },
            ),
          ),

          // 2. Arama Sonuç Başlığı (Sadece Arama Yapıldığında Görünecek)
          if (searchQuery.isNotEmpty)
            productsState.maybeWhen(
              data: (products) => Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${products.length} Sonuç Bulundu',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Uygun olan sonuçları göster "$searchQuery"',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.tune,
                        color: Color(0xFF111827),
                        size: 22,
                      ),
                      onPressed: () {
                        // Filtreleme modalı veya aksiyonu
                      },
                    ),
                  ],
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),

          const Divider(height: 1, color: Color(0xFFE5E7EB)),

          // 3. Ürün Listesi İçeriği
          Expanded(
            child: productsState.when(
              loading: () => _buildSkeletonGrid(),
              error: (err, stack) {
                final errorMessage = err.toString().replaceAll("Exception: ", "");
                String errorCode = "ERR_CONNECTION_REFUSED";
                if (errorMessage.contains("401")) {
                  errorCode = "ERR_UNAUTHORIZED";
                } else if (errorMessage.contains("404")) {
                  errorCode = "ERR_NOT_FOUND";
                }

                return ErrorStateWidget(
                  message: errorMessage.contains("Timeout") || errorMessage.contains("bağlantı")
                      ? "Sunucuyla bağlantı kurulamadı veya aradığınız sayfa bulunamadı. Lütfen internet bağlantınızı kontrol edip tekrar deneyin."
                      : errorMessage,
                  errorCode: errorCode,
                  onRetry: () {
                    ref.invalidate(productListProvider(widget.categoryId));
                  },
                  onGoHome: () {
                    context.go(AppRouter.productList);
                  },
                );
              },
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isNotEmpty
                                ? '"$searchQuery" ile eşleşen ürün bulunamadı.'
                                : 'Henüz sergilenecek ürün bulunamadı.',
                            style: const TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          if (searchQuery.isNotEmpty)
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(productSearchQueryProvider.notifier).state = '';
                              },
                              icon: const Icon(Icons.clear, size: 18),
                              label: const Text('Aramayı Temizle'),
                            )
                          else
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => ref.invalidate(productListProvider(widget.categoryId)),
                              child: const Text("Yenile"),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(productListProvider(widget.categoryId));
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      final String imageUrl = product.images.isNotEmpty
                          ? product.images.first.imageUrl
                          : 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600';

                      final isFavorite = favorites.any((p) => p.id == product.id);

                      return ProductCard(
                        imageUrl: imageUrl,
                        category: product.category.name,
                        title: product.name,
                        price: product.price,
                        isFavorite: isFavorite,
                        onFavoriteTap: () {
                          ref.read(favoritesProvider.notifier).toggleFavorite(product);
                        },
                        onAddToCartTap: () async {
                          await ref.read(cartProvider.notifier).addToCart(
                            product.id,
                            productName: product.name,
                            price: product.price,
                            imageUrl: imageUrl,
                          );
                        },
                        onTap: () {
                          context.push(
                            AppRouter.productDetail,
                            extra: {
                              'productId': product.id,
                              'title': product.name,
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}