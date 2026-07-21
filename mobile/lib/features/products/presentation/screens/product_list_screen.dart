import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../core/widgets/error_state_widgets.dart';
import '../providers/product_provider.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod ile ürün durumunu dinliyoruz
    final productsState = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Keşfet', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: productsState.when(
        // 1. Durum: Veri Yüklenirken (DoD Kriteri: Skeleton Görünümü)
        loading: () => _buildSkeletonGrid(),

        // 2. Durum: Hata Alındığında (Timeout, Late Initialization, 401 vb.)
        error: (err, stack) {
          final errorMessage = err.toString().replaceAll("Exception: ", "");

          // Hata kodunu dinamik belirliyoruz (Varsayılan: ERR_CONNECTION_REFUSED)
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
              // Riverpod state'ini yenileyip isteği baştan tetikliyoruz
              ref.refresh(productListProvider);
            },
            onGoHome: () {
              // Ana sayfaya / Keşfet sekmesine yönlendirme
              context.go(AppRouter.productList);
            },
          );
        },

        // 3. Durum: Veri Başarıyla Geldiğinde
        data: (products) {
          // Boş Veri Kontrolü (Empty State)
          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "Henüz sergilenecek ürün bulunamadı.",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(productListProvider),
                    child: const Text("Yenile"),
                  ),
                ],
              ),
            );
          }

          // Pull-to-Refresh 
          return RefreshIndicator(
            onRefresh: () async {
              return ref.refresh(productListProvider);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const AlwaysScrollableScrollPhysics(), // Pull-to-refresh'in çalışması için gerekli
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                // Görsel URL kontrolü
                final String? imageUrl = (product.images != null && product.images.isNotEmpty)
                    ? product.images.first.imageUrl
                    : null;

                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRouter.productDetail,
                      extra: {
                        'productId': product.id,
                        'title': product.name,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return _buildImagePlaceholder();
                                      },
                                    )
                                  : _buildImagePlaceholder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product.price.toStringAsFixed(2)} TRY',
                                style: const TextStyle(
                                  color: AppColors.brandBlue,
                                  fontWeight: FontWeight.w600,
                                ),
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
          );
        },
      ),
    );
  }

  // Görsel yüklenemediğinde veya resim olmadığında gösterilecek placeholder
  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(
        Icons.image_not_supported_outlined,
        color: Colors.grey,
        size: 32,
      ),
    );
  }

  // DoD için Skeleton (Yükleniyor) Tasarımı
  Widget _buildSkeletonGrid() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 1. Üst Kısım: 2'li Grid Skeleton
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 2,
          itemBuilder: (context, index) => _buildSkeletonCard(),
        ),
        const SizedBox(height: 16),

        // 2. Orta Kısım: Geniş Banner Skeleton
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
        ),
        const SizedBox(height: 16),

        // 3. Alt Kısım: 2'li Grid Skeleton
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 2,
          itemBuilder: (context, index) => _buildSkeletonCard(),
        ),
      ],
    );
  }

  // Kart Şablonu
  Widget _buildSkeletonCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
    );
  }
}