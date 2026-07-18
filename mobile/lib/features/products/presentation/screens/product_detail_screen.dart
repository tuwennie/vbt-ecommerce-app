import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/product_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  final String title;

  const ProductDetailScreen({
    super.key,
    required this.productId,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Provider'daki ürün listesinden bu sayfaya ait olan ürünü buluyoruz
    final productsState = ref.watch(productListProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ürün Detayı', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: productsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
        data: (products) {
          // İlgili ürünü ID eşleşmesiyle çekiyoruz
          final product = products.firstWhere((p) => p.id == productId);

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Ürün Büyük Görseli
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          image: DecorationImage(
                            image: NetworkImage(product.images.first.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                      // 2. Detay Bilgileri
                      Padding(
                        padding: const EdgeInsets.all(24.0),                     
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${product.price.toStringAsFixed(2)} TRY',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandBlue,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Ürün Açıklaması',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ?? 'Bu ürün için bir açıklama girilmemiş.',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // 3. Alt Sepete Ekleme Alanı (Sticky Bottom)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
                ),
                child: SafeArea(
                  top: false,
                  child: CustomButton(
                    text: 'Sepete Ekle',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${product.name} sepete eklendi!')),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}