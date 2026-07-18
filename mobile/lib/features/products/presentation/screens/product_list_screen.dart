import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/navigation/app_router.dart';
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

        // 2. Durum: Hata Alındığında
        error: (err, stack) {

          final cleanErrorMessage = err.toString().replaceAll("Exception: ", "");

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded, 
                    color: Colors.redAccent, 
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    cleanErrorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Riverpod'ın bu provider'ı sıfırlayıp API'yi tekrar tetiklemesini sağlar
                      ref.invalidate(productListProvider);
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text("Yeniden Dene"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        
        // 3. Durum: Veri Başarıyla Geldiğinde (Grid Listeleme)
        data: (products) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Yan yana 2 kart
              childAspectRatio: 0.7, // Kart boyutu en-boy oranı
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              
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
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
                            child: product.images.isNotEmpty
                                ? Image.network(
                                    // model yapısına göre liste elemanının 'imageUrl' alanına ulaşıyoruz.
                                    product.images.first.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      );
                                    },
                                  )
                                // Eğer backend'den hiç görsel gelmediyse (.first çökmesini önlemek için) direkt hata widget'ını gösteriyoruz.
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  ),
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
          );
        },
      ),
    );
  }

  // DoD için Skeleton (Yükleniyor) Tasarımı
  Widget _buildSkeletonGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 4, // 4 adet sahte yükleniyor kutusu
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300]!.withValues(alpha: 0.5),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 100, height: 12, color: Colors.grey[300]!.withValues(alpha: 0.5)),
                  const SizedBox(height: 8),
                  Container(width: 60, height: 12, color: Colors.grey[300]!.withValues(alpha: 0.5)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}